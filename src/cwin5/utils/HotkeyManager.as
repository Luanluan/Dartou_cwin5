package cwin5.utils 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 热键管理
	 * @author cwin5
	 */
	public class HotkeyManager
	{
		
		private var _focusKeyDict:Dictionary = null;			// 焦点热键目录
		private var _focusObj:Object = null;					// 焦点对象
		
		private var _globalKeyDict:Dictionary = null;			// 全局热键目录
		private var _globalParamsDict:Dictionary = null;		// 全局参数目录
		
		private var _stage:Stage = null;						// 舞台对象
		
		/**
		 * 初始化,传入舞台对象,用于侦听事件
		 * @param	stage
		 */
		public function init(stage:Stage):void
		{
			if (_stage != null)
			{
				throw new Error("This manager is initialized!");
			}
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			
			_focusKeyDict = new Dictionary(true);
			_globalKeyDict = new Dictionary(true);
			_globalParamsDict = new Dictionary(true);
		}
		
		/**
		 * 销毁
		 */
		public function destroy():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
			_focusKeyDict = null;
			_globalKeyDict = null;
			_globalParamsDict = null;
			_stage = null;
		}
		
		/**
		 * 设置焦点对象,参数为空则为清除
		 * @param	focusObj
		 */
		public function setFocusObj(focusObj:Object = null):void
		{
			_focusObj = focusObj;
		}
		
		/**
		 * 注册焦点热键
		 * @param	focusObj
		 * @param	keyCode
		 * @param	func
		 * @param	params
		 */
		public function registerFocusKey(focusObj:Object, keyCode:int, func:Function, params:Array = null):void
		{
			var dict:Dictionary = getFocusKeyCodeMap(keyCode);
			dict[focusObj] = [func, params];
		}
		
		/**
		 * 取消焦点热键
		 * @param	focusObj
		 * @param	keyCode
		 * @param	func
		 */
		public function unRegisterFocusKey(focusObj:Object, keyCode:int, func:Function):void
		{
			var dict:Dictionary = getFocusKeyCodeMap(keyCode);
			delete dict[focusObj];
		}
		
		/**
		 * 注册全局热键
		 * @param	keyCode
		 * @param	func
		 */
		public function registerGlobalKey(keyCode:int, func:Function, params:Array = null):void
		{
			var funcList:Array = getGlobalKeyCodeArr(keyCode);
			C5Utils.addElement(funcList, func);
			_globalParamsDict[func] = params;
		}
		
		/**
		 * 取消全局热键
		 * @param	keyCode
		 * @param	func
		 */
		public function unRegisterGlobalKey(keyCode:int, func:Function):void
		{
			var funcList:Array = getGlobalKeyCodeArr(keyCode);
			if (C5Utils.removeElement(funcList , func))
				delete _globalParamsDict[func];
		}
		
		/**
		 * 获取keyCode对应的焦点目录 
		 * @return
		 */
		private function getFocusKeyCodeMap(keyCode:int):Dictionary
		{
			if (_focusKeyDict[keyCode] is Dictionary)
				return _focusKeyDict[keyCode];
			return _focusKeyDict[keyCode] = new Dictionary(true);
		}
		
		/**
		 * 获取全局热键函数列表
		 * @param	keyCode
		 * @return
		 */
		private function getGlobalKeyCodeArr(keyCode:int):Array
		{
			if (_globalKeyDict[keyCode] is Array)
				return _globalKeyDict[keyCode];
			return _globalKeyDict[keyCode] = [];
		}
		
		/**
		 * 按键事件处理
		 * @param	e
		 */
		private function onKey(e:KeyboardEvent):void 
		{
			// 创建变量
			var func:Function;
			
			// 处理焦点按键
			var dict:Dictionary = getFocusKeyCodeMap(e.keyCode);
			var arr:Array = dict[_focusObj];
			if (arr)
			{
				func = arr[0];
				func.apply(null , arr[1]);
			}
			
			// 处理全局按键
			var funcList:Array = getGlobalKeyCodeArr(e.keyCode);
			for ( var i:int = 0; i < funcList.length; i++)
			{
				func = funcList[i];
				func.apply(null , _globalParamsDict[func]);
			}
		}
		
		
		/**
		 * 构造
		 */
		public function HotkeyManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():HotkeyManager
		{
			if(_instance == null)
			{
				_instance = new HotkeyManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:HotkeyManager = null;
	}
	
}
class Single{}