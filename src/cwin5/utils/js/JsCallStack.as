/**
 * @author: Sebastian Martens; sebastian@sebastian-martens.de
 * @copyright: Creative Commons. Free to use "as is"
 * @svn: $Id: JsCallStack.as 23 2009-05-29 19:17:36Z dinnerout $
 */ 
package cwin5.utils.js 
{
	
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	/**
	 * @classdescription: JsCallStack implements a stack for JavaScript calls from AS3 via the ExternalInterface Class. Sometimes
	 * 					  if you use too many JS Calls at the same time, not all JS Calls will be handled correctly. With this 
	 * 					  class you can use a stack which will call the js functions asynchronous with a timer. You are also able to
	 * 					  get ridd of double called functions
	 */ 
	public class JsCallStack
	{
		public static const STACK_MODE_LIFO:int = 0;
		public static const STACK_MODE_FIFO:int = 1;
		
		private var _stack:Vector.<Object>; // stack of javascript calls
		private var _callTimer:Timer; // timer object
		private var _timerInterval:int = 500; // interval timer calles javascript functions in ms
		private var _stackMode:int = JsCallStack.STACK_MODE_LIFO; // sets internal stack mode 
		private var _isExAvailable:Boolean;
		
		private var _checkId:int;
		private var _checkString:String;

		/**
		 * setter method for timer interval value
		 * @param value:Int - timer interval in milliseconds
		 */ 
		public function set timerInterval( value:int ):void{
			var isRunning:Boolean = this._callTimer.running;
			
			// stop timer, set new value and restart if timeer was running
			this._callTimer.stop();
			this._timerInterval = value;
			this._callTimer.delay = this._timerInterval;
			
			if( isRunning ) this._callTimer.start();
		}
		
		/**
		 * getter method for timer interval
		 * @return Int - set timer interval
		 */ 
		public function get timeInterval():int{
			return this._timerInterval;
		}
		
		/**
		 * pauses the execution of javascript calls
		 */
		public function pauseExecution():void{
			this._callTimer.stop();
		}
		
		/**
		 * restarts the execution of javascript calls 
		 */ 
		public function startExecution():void{
			if( this._stack.length > 0 ){
				this._callTimer.start();
			}
		}
		
		/**
		 * returns if the timer is running 
		 * @return Boolean - is the execution timer running 
		 */ 
		public function isExecutionRunning():Boolean{
			return this._callTimer.running;
		}
		
		/**
		 * constructor method
		 * @param stackMode:int - stack mode of handling stack entries
		 */ 
		public function JsCallStack( stackMode:int=JsCallStack.STACK_MODE_FIFO ){
			// test if ExInterface is available
			this._isExAvailable = ExternalInterface.available;
			
			// init stack
			this._stack = new Vector.<Object>();
			
			// timer 
			this._callTimer = new Timer( this._timerInterval );
			this._callTimer.addEventListener(TimerEvent.TIMER, stackHandler);
			
			// stack mode 
			this._stackMode = stackMode;
		}
		
		/**
		 * adds an javascript function call to call stack
		 * @param funcName:String - function name of js function to call
		 * @param paramter:Object - object of paramters to path to the javascript function
		 * 							Object will be converted to JSON and hand over an JSON-Object
		 * @param resultHandler:Function - method to handler javascript results
		 * @param skipOldCalls:Boolean - if true older calls in stack of the same functionname won't be 
		 * 								 called any more, only latest call
		 * @param convert2JSON:Boolean - if true the parameter object will be converted to JSON for the javascript call
		 * @return Int value of stack position, returns -1 if External Interface is not available
		 */ 
		public function addJSCall( funcName:String, parameter:Object=null, resultHandler:Function=null, skipOldCalls:Boolean=false, convert2JSON:Boolean=false ):int{
			var position:int = this._stack.length;
			
			// External Interface not available
			if( !this._isExAvailable ) return -1;
			
			// create object and add to stack
			var o:Object = { functionName:funcName, params:parameter, resHandler:resultHandler, skip:skipOldCalls, id:position, convertToJSON:convert2JSON };
			this._stack.push( o );
			
			// start timer if not running
			if( !this._callTimer.running ) this._callTimer.start(); 
			
			return position;
		}
		
		/**
		 * filter method fromstack Vector in removeJSCall
		 * @param item:Object - current vector object
		 * @param index:int - current vector index
		 * @param vector:Vector.<Object> - current vector
		 * @return Boolean - is the current id the searched id 
		 */ 
		private function removeJSCallFilter(item:Object, index:int, vector:Vector.<Object> ):Boolean{
			return Object( item ).id == this._checkId;
		}
		
		/**
		 * removes an javascript call from stack
		 * @param id:int - identifier position of call which was returned from addJSCall Method
		 * @return Boolean - function found an removed, false if already called
		 */ 
		public function removeJSCall( id:int ):Boolean{
			var result:Boolean = false;
			var isRunning:Boolean = this._callTimer.running;
			
			// no item in stack
			if( this._stack.length==0 ) return true; 
			
			// stop call timer to avoid access confilcts
			this._callTimer.stop();
			
			this._checkId = id;
			this._stack = this._stack.filter( this.removeJSCallFilter );
			
			// restart timer
			if( isRunning ) this._callTimer.start();
			
			return result;
		}
		
		/**
		 * returns a JSON string of an object
		 * @param obj:Object - object to convert into json string
		 * @return JSON String
		 */ 
		private function objToJSON( obj:Object ):String{
			var json:String;
			
			// parse object to json string
			json = "{";
			for( var o:Object in obj.params ){
				json += o + ":'" + obj.params[ o ] + "',";
			}
			json = json.substring(0,json.length-1) + "}";
			
			return json;
		}
		
		/**
		 * filter method for Vector in cleanStack
		 * @param item:Object - current vector object
		 * @param index:int - current vector index
		 * @param vector:Vector.<Object> - current vector
		 * @return Boolean - is the current functionname the searched functionname 
		 */ 
		private function cleanStackFilter( item:Object, index:int, vector:Vector.<Object> ):Boolean{
			return Object( item ).functionName == this._checkString;
		}
		
		/**
		 * search for functions with functionname = name and removes it from stack
		 * @param name:String - name of function to delete from stack
		 * @return Int - number of removed entries
		 */ 
		private function cleanStack( name:String ):int{
			var found:int = 0;
			
			this._stack = this._stack.filter( this.cleanStackFilter );
			
			return found;
		}
		
		/**
		 * handles timer event and calls single javascript function from stack
		 * @param event:Timer - timer event
		 */  
		private function stackHandler( event:TimerEvent ):void{
			var obj:Object;
			var json:String;
			var jsResult:Object;
			
			// get call object by stack mode
			switch( this._stackMode ){
				case JsCallStack.STACK_MODE_LIFO: 
					obj = this._stack.pop(); 
					break;
				
				case JsCallStack.STACK_MODE_FIFO:
				default: 
					obj = this._stack.shift();
					break; 	
			}
			
			// convert object to JSON String
			json = objToJSON( obj );
			
			// find older calls and remove
			if( Boolean( obj.skip ) ){
				this.cleanStack( obj.functionName );	
			}
			
			// call javascript function
			jsResult = ExternalInterface.call( obj.functionName, obj.convertToJSON?json:obj.params );
			if( obj.resHandler ) obj.resHandler( jsResult );
			
			// stop timer on last stack entry
			if( this._stack.length == 0 ) this._callTimer.stop();
			
		}
		
		/**
		 * returns the n number of registered functions at this momment 
		 * @return INT - numer of registered functions, which are not executed yet
		 */ 
		public function getRegisteredFunctionsCount():int{
			return this._stack.length;
		}

	}

}