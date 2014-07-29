package cwin5.control 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 全局事件中心
	 * @author cwin5
	 */
	public class EventCenter 
	{
		/**
		 * 添加事件侦听
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
												priority:int = 0, useWeakReference:Boolean = false):void
		{
			_globalEvent.addEventListener(type , listener , useCapture , priority , useWeakReference);
		}
		
		/**
		 * 移除事件侦听
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		public static function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void
		{
			_globalEvent.removeEventListener(type , listener , useCapture);
		}
		
		/**
		 * 派发事件
		 * @param	event		事件对象
		 * @return
		 */
		public static function dispatchEvent(event:Event):Boolean
		{
			return _globalEvent.dispatchEvent(event);
		}
		
		/// 事件对象
		private static const _globalEvent:EventDispatcher = new EventDispatcher();
		
	}
	
}