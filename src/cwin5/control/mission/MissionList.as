package cwin5.control.mission 
{
	import cwin5.utils.cache.CacheManager;
	import flash.events.Event;
	
	/**
	 * 序列任务基类
	 * @author cwin5
	 */
	public class MissionList extends BasicMission
	{
		
		protected var _list:Array = null;
		protected var _curID:int = 0;
		
		/**
		 * 构造
		 */
		public function MissionList() 
		{
			
		}
		
		/**
		 * 开始 , 子类复写
		 */
		override public function start():void
		{
			init();
			nextMission();
		}
		
		/// 初始化
		protected function init():void
		{
			
		}
		
		/// 处理完成
		protected function processComplete():void
		{
			
		}
		
		/// 处理任务
		protected function processMission(mission:BasicMission):void
		{
			
		}
		
		// 下一个任务
		private function nextMission():void
		{
			if (_curID >= _list.length)
			{
				processComplete();
				cache();
				complete();
				return;
			}
			var mission:BasicMission = _list[_curID];
			mission.addEventListener(Event.COMPLETE , onMissionComplete);
			mission.start();
		}
		
		// 缓存Action
		override public function cache():void
		{
			if (_list == null)
				return;
			for (var i:int = 0; i < _list.length; i++) 
			{
				_list[i].cache();
			}
			_list = null;
			
			super.cache();
		}
		
		/// 任务完成
		private function onMissionComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			processMission(e.currentTarget as BasicMission);
			_curID++;
			nextMission();
		}
		
		public function get curID():int { return _curID; }
		public function set curID(value:int):void 
		{
			_curID = value;
		}
		
	}

}