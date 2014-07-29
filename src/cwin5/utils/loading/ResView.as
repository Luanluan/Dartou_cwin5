package cwin5.utils.loading 
{
	import cwin5.control.EventCenter;
	import cwin5.events.LoadingEvent;
	import cwin5.utils.C5Utils;
	import cwin5.utils.cache.CacheManager;
	import cwin5.utils.ResManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	
	/**
	 * 需為居中
	 * @author cwin5
	 */
	public class ResView
	{
		
		public static var LOAD_CLASS:Class = null;
		
		protected var _load:MovieClip;
		protected var _container:DisplayObjectContainer;
		private var _url:String = "";
		protected var _view:MovieClip;
		public function get view():MovieClip { return _view; }
		
		protected var _scale:Number = 1;
		
		/**
		 * 构造
		 */
		public function ResView() 
		{
			
		}
		
		public function showScale(container:DisplayObjectContainer , url:String, scale:Number):void
		{
			_scale = scale;
			show(container , url);
		}
		
		public function show(container:DisplayObjectContainer , url:String):void
		{
			_container = container;
			_url = url;
			if (ResManager.instance.getLoader(_url))
			{
				update();
			}
			else
			{
				_load = CacheManager.instance.getObject(LOAD_CLASS);
				_load.play();
				_container.addChild(_load);
				_load.x = _load.y = 0;
				setLosdPos();
				
				EventCenter.addEventListener(LoadingEvent.LOADED_RES , onLoadedRes);
				ResManager.instance.loadRes(url);
			}
		}
		
		protected function setLosdPos():void 
		{
			
		}
		
		public function cache():void
		{
			_scale = 1;
			clearLoad();
			if (_view)
			{
				C5Utils.stopAll(_view);
				_view.scaleX = _view.scaleY = 1;
				C5Utils.removeFromStage(_view);
				CacheManager.instance.delObject(_view);
				_view = null;
			}
			_container = null;
			_url = "";
			CacheManager.instance.delObject(this);
		}
		
		private function clearLoad():void
		{
			EventCenter.removeEventListener(LoadingEvent.LOADED_RES , onLoadedRes);
			if (_load)
			{
				_load.stop();
				C5Utils.removeFromStage(_load);
				CacheManager.instance.delObject(_load);
				_load = null;
			}
		}
		
		protected function onLoadedRes(e:LoadingEvent):void 
		{
			if (e.param == _url)
			{
				clearLoad();
				update();
			}
		}
		
		protected function update():void
		{
			var loader:Loader = ResManager.instance.getLoader(_url);
			//_view = loader.content["getChildAt"](0) as MovieClip;
			_view = CacheManager.instance.getObject(loader.content["constructor"] as Class);
			_view.x = _view.y = 0;
			_view.filters = [];
			addToContainer();
			C5Utils.playAll(_view);
			
			_view.scaleX = _view.scaleY = _scale;
			setPos();
		}
		
		protected function setPos():void 
		{
			
		}
		
		private function addToContainer():void 
		{
			_container.addChild(_view);
		}
		
	}

}