package cwin5.control 
{
	import cwin5.utils.C5Utils;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 存储stage对象,
	 * 添加改变处理函数后,
	 * 直接取本类静态get宽高函数
	 * @author cwin5
	 */
	public class StageProxy
	{
		private static var _stage:Stage = null;				// 舞台
		private static const _handlerList:Array = [];		// 处理器列表
		
		/**
		 * 添加改变舞台侦听
		 * @param	func
		 */
		public static function addHandler(func:Function):void
		{
			C5Utils.addElement(_handlerList, func);
		}
		
		/**
		 * 删除舞台改变侦听
		 * @param	func
		 */
		public static function delHandler(func:Function):void
		{
			C5Utils.removeElement(_handlerList, func);
		}
		
		/**
		 * 宽
		 */
		public static function get width():Number	{	return stage.stageWidth; }
		
		/**
		 * 高
		 */
		public static function get height():Number	{	return stage.stageHeight;}
		
		/**
		 * 舞台对象
		 */
		public static function get stage():Stage 
		{
			if (_stage == null)
				throw new Error("Stage is null!");
			return _stage; 
		}
		public static function set stage(value:Stage):void 
		{
			if (_stage)
				return;
			_stage = value;
			_stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		/// 舞台改变处理
		private static function onStageResize(e:Event):void 
		{
			for (var i:int = 0; i < _handlerList.length; i++) 
			{
				var func:Function = _handlerList[i];
				func();
			}
		}
		
	}

}