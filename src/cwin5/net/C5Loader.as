package cwin5.net 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 收到数据事件
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")] 
	
	/**
	 * 载入完成
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")] 
	
	/**
	 * 资源|模块载入器
	 * @author cwin5
	 */
	public class C5Loader extends EventDispatcher
	{
		private var _loader:Loader = null;		// 载入器
		private var _url:String = "";			// 载入地址
		
		private var _decodeFunc:Function = null;	// 解码函数
		private var _domain:ApplicationDomain = null;		// 所在域
		
		/**
		 * 构造函数
		 * 
		 * @param	isSameDomain		是否同域,默认为同域
		 * @param	decodeFunc			解码函数,默认null,不解码
		 */
		public function C5Loader(domain:ApplicationDomain = null, decodeFunc:Function = null) 
		{
			_decodeFunc = decodeFunc;
			_domain = domain;
		}
		
		/**
		 * 获取loader
		 * @return
		 */
		public function getLoader():Loader
		{
			return _loader;
		}
		
		/**
		 * 关闭连接
		 */
		public function close():void
		{
			_loader.close();
		}
		
		/**
		 * 加载
		 */
		public function load(url:String):void
		{
			_url = url;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(ProgressEvent.PROGRESS , onProgress);
			urlLoader.addEventListener(Event.COMPLETE , onComplete);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(new URLRequest(url));
		}
		
		// 进度事件
		private function onProgress(e:ProgressEvent):void 
		{
			dispatchEvent(e);
		}
		
		// 读取完成
		private function onComplete(e:Event):void 
		{
			var urlLoader:URLLoader = e.currentTarget as URLLoader;
			urlLoader.removeEventListener(ProgressEvent.PROGRESS , onProgress);
			urlLoader.removeEventListener(Event.COMPLETE , onComplete);
			
			/// 载入字节
			loadBytes(urlLoader.data);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		
		/**
		 * 载入字节 , 用于swf载入
		 * @param	data
		 */
		public function loadBytes(data:ByteArray):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoadByteComplete);
			var bytes:ByteArray = (_decodeFunc != null) ? _decodeFunc(data) : data;
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = _domain;
			_loader.loadBytes(bytes , context);
		}
		
		/// 载入完成
		private function onLoadByteComplete(e:Event):void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onLoadByteComplete);
			complete();
		}
		
		// 发出完成事件
		private function complete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}