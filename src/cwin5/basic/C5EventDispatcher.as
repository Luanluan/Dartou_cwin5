package cwin5.basic 
{
	import cwin5.debug.Debug;
	import flash.events.EventDispatcher;
	
	/**
	 * 事件派发者
	 * @author cwin5
	 */
	public class C5EventDispatcher extends EventDispatcher
	{
		
		public function C5EventDispatcher() 
		{
			
		}
		
		/**
		 * 调试
		 * @param	obj		要输出的信息
		 */
		protected function debug(obj:Object):void
		{
			Debug.debug(this , obj);
		}
		
	}

}