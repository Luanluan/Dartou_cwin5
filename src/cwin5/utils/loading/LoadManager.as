package cwin5.utils.loading 
{
	import cwin5.control.EventCenter;
	import cwin5.events.LoadingEvent;
	import cwin5.net.C5Loader;
	import cwin5.utils.C5Timer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	/**
	 * 载入完成
	 * @eventType cwin5.events.LoadingEvent.COMPLETE
	 */
	[Event(name = "COMPLETE", type = "cwin5.events.LoadingEvent")] 
	
	/**
	 * 载入错误
	 * @eventType cwin5.events.LoadingEvent.ERROR
	 */
	[Event(name="ERROR", type="cwin5.events.LoadingEvent")] 
	
	/**
	 * 资源载入管理器
	 * 载入完成与失败会在EventCenter发出全局事件
	 * _loadHandler对外设置的值为1-100的值
	 * @author cwin5
	 */
	public class LoadManager
	{
		private var _loadHandler:ILoadHandler = null;				// 载入界面
		private var _loadQueue:Array = null;			// 载入队列
		private var _loadIndex:int = 0;					// 载入索引
		private var _countSize:int = 0;					// 总大小
		private var _loaded:int = 0;					// 已载入大小
		private var _urlLoader:URLLoader = null;		// 当前载入对象
		private var _loading:Boolean = false;			// 正在载入
		private var _useSize:Boolean = false;			// 是否使用大小方式计算进茺
		
		public var throwError:Boolean = true;			// 是否抛出错误 
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
		}
		
		/**
		 * 设置载入处理
		 * @param	loadHandler
		 */
		public function setLoadHandler(loadHandler:ILoadHandler):void
		{
			_loadHandler = loadHandler;
		}
		
		/**
		 * 载入
		 * @param	loadQueue		队列,都为loadData对象
		 */
		public function load(loadQueue:Array , useSize:Boolean = false):void
		{
			if (_loading)
				throw new Error("LoadManager is Loading!");
			
			if (!loadQueue || loadQueue.length < 1)
			{
				setHandlerPercent(100);
				EventCenter.dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, _loadQueue));
				return;
			}
			
			_useSize = useSize;
			_loadQueue = loadQueue;
			_loading = true;
			_countSize = getCountSize(loadQueue);
			loadNext(true);
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
		private function loadNext(isFirst:Boolean):void
		{
			// 取出地址
			var loadData:LoadData = _loadQueue[_loadIndex];
			var url:String = loadData.url;
			
			// 以二进制载入
			_urlLoader = new URLLoader();
			addLoadEvent();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.load(new URLRequest(url));
			if (loadData.hasNextUrl && isFirst)	// 只有第一次加载，才会做转换, 2秒没收到数据，转换地址
			{
				C5Timer.add(2, reLoadCur);
			}
		}
		
		/// 重新加载当前项
		private function reLoadCur():void 
		{
			removeLoadEvent();
			var loadData:LoadData = _loadQueue[_loadIndex];
			loadData.getNextUrl();
			loadNext(false);
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
			C5Timer.remove(reLoadCur);
			removeLoadEvent();
			
			if (_reload < MAX_RELOAD)
			{
				var loadData:LoadData = _loadQueue[_loadIndex];
				if (!loadData.getNextUrl())
				{
					_reload++;
				}
				loadNext(false);
				return;
			}
			
			_urlLoader = null;
			if (!ExternalInterface.available)
			{
				throw new Error("Load Error" + e);
			}
			EventCenter.dispatchEvent(new LoadingEvent(LoadingEvent.ERROR , _loadQueue[_loadIndex]));
			init();
		}
		
		/// 收到数据
		private function onProgress(e:ProgressEvent):void 
		{
			C5Timer.remove(reLoadCur);
			if (e.bytesTotal != 0)
				setPercent(e.bytesLoaded , e.bytesTotal);
			else
				setPercent(0 , 1);
		}
		
		// 完成
		private function onComplete(e:Event):void 
		{	
			C5Timer.remove(reLoadCur);
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
				loadNext(true);
			}
			else
			{
				EventCenter.dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, _loadQueue));
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
			
			//trace("cunrrentLoaded:" + cunrrentLoaded, "currentTotal:" + currentTotal , "_loadIndex:" + _loadIndex , "percent:" + percent);
			
			// 验证长度
			if (percent > 100)
				percent = 100;
			else if (percent < 0)
				percent = 0;
			
			_loadHandler.setPercent(percent);
		}
		
		/**
		 * 设置百分比 1-100
		 * @param	loadedBytes
		 */
		private function setHandlerPercent(percent:int):void
		{
			_loadHandler.setPercent(percent);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private var _loadDataIndex:int = 0;			// 数据索引
		private var _loadDataQueue:Array = null;	// 读取数据列表
		
		/**
		 * 读取数据,并写到loaddata里的域
		 * @param	loadQueue
		 */
		public function loadData(loadQueue:Array):void
		{
			if (!loadQueue || loadQueue.length < 1)
			{
				setHandlerPercent(100);
				EventCenter.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_DATA_COMPLETE, _loadDataQueue));
				return;
			}
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
				EventCenter.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_DATA_COMPLETE, _loadDataQueue));
				_loadDataQueue = null;
				_loadDataIndex = 0;
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 构造
		 */
		public function LoadManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():LoadManager
		{
			if(_instance == null)
			{
				_instance = new LoadManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:LoadManager = null;
	}
	
}
class Single{}