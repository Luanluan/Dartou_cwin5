package cwin5.basic 
{
	import flash.events.Event;
	
	/**
	 * 完成
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")] 
	
	/**
	 * 带有完成事件的基类
	 * @author cwin5
	 */
	public class BasicComplete extends C5EventDispatcher
	{
		
		/**
		 * 构造
		 */
		public function BasicComplete() 
		{
			
		}
		
		/**
		 * 开始 , 子类复写
		 */
		public function start():void
		{
			throw new Error("This hasn'st override");
		}
		
		/**
		 * 发出完成事件
		 */
		protected function complete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}