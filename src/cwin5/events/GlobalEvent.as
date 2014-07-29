package cwin5.events 
{
	import flash.events.Event;
	
	/**
	 * 全局事件对象
	 * @author cwin5
	 */
	public class GlobalEvent extends Event 
	{
		// 实际发出事件对象
		private var _factTarget:Object = null;
		
		// 参数
		private var _param:Object = null;
		
		/**
		 * 构造
		 * @param	type
		 * @param	factTarget
		 * @param	param
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function GlobalEvent(type:String, factTarget:Object, param:Object = null , bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			_factTarget = factTarget;
			_param = param;
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * 克隆
		 * @return
		 */
		public override function clone():Event 
		{ 
			return new GlobalEvent(type, param , bubbles, cancelable);
		} 
		
		/**
		 * 转为文本
		 * @return
		 */
		public override function toString():String 
		{ 
			return formatToString("C5GlobalEvent", "param" , "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * 参数
		 */
		public function get param():Object { return _param; }
		
		/**
		 * 实际发出事件对象
		 */
		public function get factTarget():Object { return _factTarget; }
		
	}
	
}