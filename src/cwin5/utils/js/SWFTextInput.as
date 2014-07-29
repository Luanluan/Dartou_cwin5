/**
 * @author: Sebastian Martens; sebastian@sebastian-martens.de
 * @copyright: Creative Commons. Free to use "as is"
 * @svn: $Id: SwfTextInput.as 5 2008-12-07 18:12:12Z dinnerout $
 */ 
package cwin5.utils.js 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	/**
	 * @classdescription:
	 */ 
	public class SWFTextInput extends TextField
	{
		private var _jsCalls:JsCallStack;
		private var _jsImplementationNeeded:Boolean = false;
		private var _isRegistered:Boolean = false;
		private var _channel:String = "_swfIDefCh";
		private static const INPUT_TYPE:String = "SWFTextInput";
		public var id:String;
		
		/**
		 * constructor method
		 */ 
		public function SWFTextInput(){
			// init JS function call stack
			this._jsCalls = new JsCallStack();
			this._jsCalls.timerInterval = 30;
			
			// add event listener to complete event
			//addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
		}
		
		public function init():void
		{
			this._jsCalls.addJSCall("swfInputs.swfInputInit", {}, jsInitCompleteHandler);
		}
		
		/**
		 * setter method for channel attribute
		 * @param value:String - channel name
		 */ 
		public function set channel( value:String ):void{
			this._channel = value;
		}
		
		/**
		 * getter method for channel attribute
		 * @return String channel name
		 */ 
		public function get channel():String{
			return this._channel;
		}
		
		/**
		 * tests if javascript initialization is complete
		 * @param event:Event - creation complete event
		 */ 
		//private function creationCompleteHandler( event:Event ):void{
			//removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
			//this._jsCalls.addJSCall("swfInputs.swfInputInit", {}, jsInitCompleteHandler);
		//}
		
		/**
		 * javascript call handler for JS init complete 
		 * @param obj:Object - JS result
		 */  
		private function jsInitCompleteHandler( obj:Object ):void{
			if( Boolean( obj ) ){
				// test if SWFInputs needed
				this._jsCalls.addJSCall("swfInputs.swfInputsRequiered", {}, setImplementationRequiered);
			}else trace("JavaScript not ready.");
		}
		
		/**
		 * javascript call result handler to set if the swfInputs implementation is needed for actual browser 
		 * @param obj:Object - JS result 
		 */  
		private function setImplementationRequiered( obj:Object ):void{
			this._jsImplementationNeeded = Boolean( obj );
			if( this._jsImplementationNeeded ){ 
				this.registerToJS();	
			}else trace("SWFInputs not required.");
		}
		
		/**
		 * walk through the dom tree and measures the absolute x and y position of an element
		 * @param node:UIComponent - component to measrue x,y-position
		 * @param x:int - local x-position
		 * @param y:int - local y-position
		 * @return Object {x:VALUE,y:VALUE}
		 */ 		
		//private function getFullPosition(node:UIComponent,xV:int,yV:int):Object{
			//if( !node.parentApplication ) return {x:xV,y:yV};
			//return getFullPosition(UIComponent(node.parent),x+node.x,y+node.y);
		//}
		
		public var fontSize:int = 12;
		public var fontFamily:String = "Arial";
		
		/**
		 * registers SWFTextInput to JavaScript Class
		 */ 
		private function registerToJS():void{
			//var coords:Object = getFullPosition(this,0,0);
			var regObj:Object = {
				type:SWFTextInput.INPUT_TYPE,
				channel:this._channel,

				x:x,
				y:y,
				id:this.id,
				
				width:this.width,
				height:this.height,
				
				//borderStyle: this.getStyle('borderStyle'),
				//borderColor: this.rgbToHex( this.getStyle('borderColor') ),
				//border: this.getStyle('borderThickness'),
				
				font_family: fontFamily,
				font_size: fontSize				
			};
			// create callbacks
			ExternalInterface.addCallback( "onChange"+this._channel+this.id, this.callBackHandler );
			//ExternalInterface.addCallback( "onPreFocuspre"+this._channel+this.id, this.preFocusHandler );
			//ExternalInterface.addCallback( "onPostFocuspost"+this._channel+this.id, this.postFocusHandler );
			// registers this object to javascript
			this._jsCalls.addJSCall("swfInputs.addSWFInput", regObj, jsRegisterCompleteHandler);
		}
		
		//public function preFocusHandler():void{
			//var prev:IFocusManagerComponent= focusManager.getNextFocusManagerComponent();
			//prev.setFocus();
		//}
		//
		//public function postFocusHandler():void{
			//var next:IFocusManagerComponent = focusManager.getNextFocusManagerComponent(true);
			//next.setFocus();
		//}
		
		/**
		 * helper method to convert uint color values to Hex values
		 * @param color:uint - color values
		 * @return String - Hex color value
		 */ 
		private function rgbToHex(color:uint):String{
			// Find hex number in the RGB offset
			var colorInHex:String = color.toString(16);
			var c:String = "00000" + colorInHex;
			var e:int = c.length;
			c = c.substring(e - 6, e);
			return "#"+ c.toUpperCase();
		}
		
		/**
		 * update javascript content when flex content is updated
		 * @param event:Changeevent on input
		 */ 
		private function changeContentHandler( event:Event ):void{
			var regObj:Object = { value:this.text, channel:this._channel, id:this.id };
			this._jsCalls.addJSCall("swfInputs.updateContent", regObj );
		}
		
		/**
		 * handles focusin event on input field. sets focus to javascript element
		 * @param event:Event - FocusIn event
		 */ 	
		private function getFocusHandler( event:Event ):void{
			var regObj:Object = { value:this.text, channel:this._channel, id:this.id };
			this._jsCalls.addJSCall("swfInputs.setFocus", regObj );
		}
		
		/**
		 * callback handler for text inputs
		 * @param input:Object - transfered content from html-input
		 */ 
		public function callBackHandler( input:Object ):void{
			removeEventListener( Event.CHANGE, changeContentHandler );
			this.text = input.toString();
			if( this._jsImplementationNeeded ){ 
				addEventListener( Event.CHANGE, changeContentHandler );
			}
		}
		
		/**
		 * helper method creates an debug output on firebug
		 * @param obj:Object - Object to trace
		 */ 
		public function debug( obj:Object ):void{
			this._jsCalls.addJSCall("console.info",obj);
		}
		
		/**
		 * complete handler for javascript registration
		 * @param obj:Object - js result obj
		 */
		private function jsRegisterCompleteHandler( obj:Object ):void{
			this._isRegistered = (parseInt( obj.toString() ) >= 0);
			if( !this._isRegistered ){
				trace("SWFInput is not registered correct. Did you set an Id ?");
			}
			
			//
			this.alpha = 0.0; 
			this.x = -1000;
			
			// add event listener to sync between flex and js
			if( this._jsImplementationNeeded ){ 
				addEventListener( Event.CHANGE, changeContentHandler );
				addEventListener( FocusEvent.FOCUS_IN, getFocusHandler );
			}
		}

	}

}