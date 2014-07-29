package cwin5.events 
{
	import flash.events.Event;
	
	/**
	 * 资源事件
	 * @author cwin5
	 */
	public class ResEvent extends Event 
	{
		
		/**
		 * 读取完成
		 */
		public static const COMPLETE:String = "cwin5.events.LoadResComplete";
		
		// 参数
		private var _param:Object = null;
		
		/**
		 * 构造
		 * @param	type
		 * @param	param
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function ResEvent(type:String, param:Object = null , bubbles:Boolean=false, cancelable:Boolean=false) 
		
		{
			_param = param;
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * 克隆
		 * @return
		 */
		public override function clone():Event 
		{ 
			return new ResEvent(type, param , bubbles, cancelable);
		} 
		
		/**
		 * 转为文本
		 * @return
		 */
		public override function toString():String 
		{ 
			return formatToString("ResEvent", "param" , "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * 参数
		 */
		public function get param():Object { return _param; }
		
	}
	
}