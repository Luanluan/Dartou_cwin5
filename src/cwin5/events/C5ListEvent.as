package cwin5.events 
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author cwin5
	 */
	public class C5ListEvent extends Event 
	{
		/**
		 * 选项卡改变
		 * { id , bool(true小, false大} }
		 */
		public static const OPTION_CHANGE:String = "cwin5.events.C5ListEvent.optionchange";
		
		public static const ITEM_SELECTED:String = "cwin5.events.C5ListEvent.itemSelected";
		
		// 参数
		private var _param:Object = null;
		
		/**
		 * 构造
		 * @param	type
		 * @param	param
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function C5ListEvent(type:String, param:Object = null , bubbles:Boolean=false, cancelable:Boolean=false) 
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
			return new C5ListEvent(type, param , bubbles, cancelable);
		} 
		
		/**
		 * 转为文本
		 * @return
		 */
		public override function toString():String 
		{ 
			return formatToString("C5ListEvent", "param" , "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * 参数
		 */
		public function get param():Object { return _param; }
		
	}
	
}