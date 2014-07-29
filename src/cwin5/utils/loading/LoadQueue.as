package cwin5.utils.loading 
{
	import cwin5.events.LoadingEvent;
	import cwin5.utils.cache.CacheManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * 载入完成
	 * @eventType cwin5.events.LoadingEvent.COMPLETE
	 */
	[Event(name = "cwin5.events.LoadingEvent.LoadComplete", type = "cwin5.events.LoadingEvent")] 
	
	/**
	 * 载入错误
	 * @eventType cwin5.events.LoadingEvent.ERROR
	 */
	[Event(name="cwin5.events.LoadingEvent.LoadError", type="cwin5.events.LoadingEvent")] 
	
	/**
	 * 队列载入
	 * @author cwin5
	 */
	public class LoadQueue extends EventDispatcher
	{
		private var _loadHandler:ILoadHandler = null;				// 载入界面
		private var _loadQueue:Array = null;				// 载入队列
		private var _loadIndex:int = 0;						// 载入索引
		private var _countSize:int = 0;						// 总大小
		private var _loaded:int = 0;						// 已载入大小
		private var _urlLoader:URLLoader = null;			// 当前载入对象
		private var _loading:Boolean = false;				// 正在载入
		private var _useSize:Boolean = false;				// 是否使用大小方式计算进茺
		private var _totalPercent:Number = 0;				// 总加载百分比
		
		public var throwError:Boolean = true;					// 是否抛出错误 
		private const MAX_RELOAD:int = 3;
		public var _reload:int = 0;
		
		/// 初始化
		private function init():void
		{
			_loadQueue = null;
			_loadIndex = 0;
			_countSize = 0;
			_loaded = 0;
			_reload = 0;
			_loading = false;
			_loadHandler = null;
			_totalPercent = 0;
			CacheManager.instance.delObject(this);
		}
		
		/**
		 * 设置载入处理
		 * 0-100
		 * @param	loadHandler
		 */
		public function setLoadHandler(loadHandler:ILoadHandler):void
		{
			_loadHandler = loadHandler;
			_loadHandler.setPercent(_totalPercent);
		}
		
		/**
		 * 载入
		 * @param	loadQueue		队列,都为loadData对象
		 */
		public function load(loadQueue:Array , useSize:Boolean = false):void
		{
			if (_loading)
				throw new Error("is Loading!");
			
			_useSize = useSize;
			_loadQueue = loadQueue;
			_loading = true;
			_countSize = getCountSize(loadQueue);
			loadNext();
		}
		
		/// 获取总大小
		private function getCountSize(loadQueue:Array):int
		{
			var countSize:int = 0;
			for (var i:int = 0; i < loadQueue.length; i++) 
			{
				var loadData:LoadData = loadQueue[i];
				countSize += loadData.size;
			}
			return countSize;
		}
		
		/// 载入下一个
		private function loadNext():void
		{
			// 取出地址
			var loadData:LoadData = _loadQueue[_loadIndex];
			var url:String = loadData.url;
			
			// 以二进制载入
			_urlLoader = new URLLoader();
			addLoadEvent();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.load(new URLRequest(url));
		}
		
		/// 添加载入事件
		private function addLoadEvent():void
		{
			_urlLoader.addEventListener(ProgressEvent.PROGRESS , onProgress);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onError);
			_urlLoader.addEventListener(Event.COMPLETE , onComplete);
		}
		
		/// 移除载入事件
		private function removeLoadEvent():void
		{
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS , onProgress);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , onError);
			_urlLoader.removeEventListener(Event.COMPLETE , onComplete);
		}
		
		/// 出错
		private function onError(e:Event):void 
		{
			removeLoadEvent();
			
			if (_reload < MAX_RELOAD)
			{
				loadNext();
				_reload++;
				return;
			}
			
			_urlLoader = null;
			if (throwError)
				throw new Error("Load Error" + e);
			dispatchEvent(new LoadingEvent(LoadingEvent.ERROR , _loadQueue[_loadIndex]));
			init();
		}
		
		/// 收到数据
		private function onProgress(e:ProgressEvent):void 
		{
			if (e.bytesTotal != 0)
				setPercent(e.bytesLoaded , e.bytesTotal);
			else
				setPercent(0 , 1);
		}
		
		// 完成
		private function onComplete(e:Event):void 
		{	
			// 写入数据
			var loadData:LoadData = _loadQueue[_loadIndex];
			loadData.data = _urlLoader.data;
			_loaded += loadData.size;
			
			// 移除
			removeLoadEvent();
			_urlLoader = null;
			
			// 载入下一个
			_loadIndex++;
			if (_loadIndex < _loadQueue.length)
			{
				loadNext();
			}
			else
			{
				dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, _loadQueue));
				init();
			}
		}
		
		/**
		 * 设置百分比
		 * @param	loadedBytes
		 */
		private function setPercent(cunrrentLoaded:int , currentTotal:int):void
		{
			if (_loadHandler == null)
				return;
				
			var percent:int;
			
			if (_useSize)
			{
				percent = int(((cunrrentLoaded + _loaded) / _countSize) * 100);
			}
			else
			{
				percent = int((((cunrrentLoaded / currentTotal) + _loadIndex) / _loadQueue.length) * 100);
			}
			
			// 验证长度
			if (percent > 100)
				percent = 100;
			else if (percent < 0)
				percent = 0;
			
			_loadHandler.setPercent(_totalPercent = percent);
		}
		
		/**
		 * 构造
		 */
		public function LoadQueue() 
		{
			//init();
		}
		
	}

}