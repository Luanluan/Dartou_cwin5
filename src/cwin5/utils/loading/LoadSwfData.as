package cwin5.utils.loading 
{
	import cwin5.events.LoadingEvent;
	import cwin5.net.C5Loader;
	import cwin5.utils.cache.CacheManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 载入完成
	 * @eventType cwin5.events.LoadingEvent.LOAD_DATA_COMPLETE
	 */
	[Event(name = "cwin5.events.LoadingEvent.LoadDataComplete", type = "cwin5.events.LoadingEvent")] 
	
	/**
	 * 
	 * @author cwin5
	 */
	public class LoadSwfData extends EventDispatcher
	{
		
		/**
		 * 构造
		 */
		public function LoadSwfData() 
		{
			
		}
		
		private var _loadDataIndex:int = 0;			// 数据索引
		private var _loadDataQueue:Array = null;	// 读取数据列表
		
		/**
		 * 读取数据,并写到loaddata里的域
		 * @param	loadQueue
		 */
		public function loadData(loadQueue:Array):void
		{
			_loadDataQueue = loadQueue;
			loadNextData();
		}
		
		/// 读取下一个数据
		private function loadNextData():void
		{
			var loadData:LoadData = _loadDataQueue[_loadDataIndex];
			var loader:C5Loader = new C5Loader(loadData.domain);
			loader.addEventListener(Event.COMPLETE , onLoadDataComplete);
			loader.loadBytes(loadData.data);
		}
		
		/// 读取数据完成
		private function onLoadDataComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			
			_loadDataIndex++;
			if (_loadDataIndex < _loadDataQueue.length)
			{
				loadNextData();
			}
			else
			{
				dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_DATA_COMPLETE, _loadDataQueue));
				_loadDataQueue = null;
				_loadDataIndex = 0;
				CacheManager.instance.delObject(this);
			}
		}
		
	}

}