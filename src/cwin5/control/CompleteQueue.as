package cwin5.control 
{
	import cwin5.basic.BasicComplete;
	import cwin5.utils.C5Timer;
	import flash.events.Event;
	
	/**
	 * 完成队列
	 * @author cwin5
	 */
	public class CompleteQueue extends BasicComplete 
	{
		
		private var _queue:Array = null;	// 队列
		
		/**
		 * 按顺序传值进来
		 * @param	queue
		 */
		public function CompleteQueue(queue:Array) 
		{
			_queue = queue;
		}
		
		/**
		 * 开始 , 子类复写
		 */
		override public function start():void
		{
			nextCompleteObj();
		}
		
		/// 下一个完成对象
		private function nextCompleteObj():void
		{
			if (_queue.length == 0)
			{
				complete();
				return;
			}
			
			var completeObj:BasicComplete = new (_queue[0])() as BasicComplete;
			_queue.shift();
			completeObj.addEventListener(Event.COMPLETE , onComplete);
			completeObj.start();
		}
		
		/// 初始化完成
		private function onComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			C5Timer.add(.1 , nextCompleteObj);
		}
		
	}

}