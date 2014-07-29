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
	 * 
	 * @author cwin5
	 */
	public class C5ResLoader extends EventDispatcher
	{
		private var _url:String = "";			// 载入地址
		private var _domain:ApplicationDomain = null;		// 所在域
		
		/**
		 * 构造
		 */
		public function C5ResLoader(url:String, domain:ApplicationDomain = null) 
		{
			_url = url;
			_domain = domain;
		}
		
		public function load():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(ProgressEvent.PROGRESS , onProgress);
			urlLoader.addEventListener(Event.COMPLETE , onComplete);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(new URLRequest(_url));
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
			var bytes:ByteArray = urlLoader.data;
			bytes.uncompress();
		}
		
	}

}