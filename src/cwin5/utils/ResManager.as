package cwin5.utils 
{
	import cwin5.control.EventCenter;
	import cwin5.events.LoadingEvent;
	import cwin5.events.ResEvent;
	import cwin5.utils.loading.LoadData;
	import cwin5.utils.loading.LoadManager;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * 资源管理器
	 * @author cwin5
	 */
	public class ResManager
	{
		/// 读取完列表, 以url为键值
		private var _loadedDict:Dictionary = null;
		
		/// 读取列表
		private var _loadList:Array = null;
		
		/// 是否载入中
		private var _isLoading:Boolean = false;
		public function get isLoading():Boolean { return _isLoading; }
		
		/// 初始化
		private function init():void
		{
			_loadedDict = new Dictionary();
			_loadList = [];
		}
		
		/**
		 * 添加
		 * @param	url
		 * @param	domain		所在程序域
		 */
		public function addItem(url:String , domain:ApplicationDomain = null):void
		{
			if (_loadedDict[url])
				return;
			var loadData:LoadData = new LoadData(url);
			if (domain)
			{
				loadData.domain = domain;
			}
			else
			{
				loadData.domain = ApplicationDomain.currentDomain;
			}
			_loadList.push(loadData);
			_loadedDict[url] = true;
		}
		
		/**
		 * 开始读取
		 */
		public function load():void
		{
			if (_isLoading)
				throw new Error("Loading Res, Error!");
			
			if (_loadList.length == 0)
			{
				complete();
				return;
			}
			_isLoading = true;
			EventCenter.addEventListener(LoadingEvent.COMPLETE , onLoadComplete);
			LoadManager.instance.load(_loadList);
		}
		
		/// 读取2进制完成
		private function onLoadComplete(e:LoadingEvent):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			
			EventCenter.addEventListener(LoadingEvent.LOAD_DATA_COMPLETE , onLoadDataComplete);
			LoadManager.instance.loadData(_loadList);
		}
		
		/// 写入程序域完成
		private function onLoadDataComplete(e:LoadingEvent):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			
			//for (var i:int = 0; i < _loadList.length; i++) 
			//{
				//var loadData:LoadData = _loadList[i];
			//}
			
			_isLoading = false;
			_loadList = [];
			complete();
		}
		
		/// 发成完成事件
		private function complete():void
		{
			EventCenter.dispatchEvent(new ResEvent(ResEvent.COMPLETE));
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private var _resDict:Dictionary = new Dictionary();
		private var _resOKDict:Dictionary = new Dictionary();
		
		public function getLoader(url:String):Loader
		{
			if (!_resOKDict[url])
				return null;
			return _resDict[url];
		}
		
		public function loadRes(url:String):void
		{
			if (_resDict[url])
				return;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoaderComplete);
			loader.load(new URLRequest(url));
			_resDict[url] = loader;
			_resDict[loader] = url;
		}
		
		private function onLoaderComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, onLoaderComplete);
			
			var lif:LoaderInfo = e.currentTarget as LoaderInfo;
			var loader:Loader = lif.loader;
			_resOKDict[_resDict[loader]] = true;
			EventCenter.dispatchEvent(new LoadingEvent(LoadingEvent.LOADED_RES, _resDict[loader]));
		}
		
		/**
		 * 构造
		 */
		public function ResManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
			init();
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():ResManager
		{
			if(_instance == null)
			{
				_instance = new ResManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:ResManager = null;
	}
	
}
class Single{}