package cwin5.events 
{
	import flash.events.Event;
	
	/**
	 * 载入事件
	 * @author cwin5
	 */
	public class LoadingEvent extends Event 
	{
		/**
		 * 读取完成
		 */
		public static const COMPLETE:String = "cwin5.events.LoadingEvent.LoadComplete";
		
		/**
		 * 读取错误
		 */
		public static const ERROR:String = "cwin5.events.LoadingEvent.LoadError";
		
		/**
		 * 读取数据完成
		 */
		public static const LOAD_DATA_COMPLETE:String =  "cwin5.events.LoadingEvent.LoadDataComplete";
		
		
		public static const LOADED_RES:String = "cwin5.events.LoadingEvent.LoadedRes";
		
		// 参数
		private var _param:Object = null;
		
		/**
		 * 构造
		 * @param	type
		 * @param	param
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function LoadingEvent(type:String, param:Object = null , bubbles:Boolean=false, cancelable:Boolean=false) 
		
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
			return new LoadingEvent(type, param , bubbles, cancelable);
		} 
		
		/**
		 * 转为文本
		 * @return
		 */
		public override function toString():String 
		{ 
			return formatToString("LoadingEvent", "param" , "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * 参数
		 */
		public function get param():Object { return _param; }
		
	}
	
}