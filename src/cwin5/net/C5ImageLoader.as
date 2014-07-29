package cwin5.net 
{
	import cwin5.basic.BasicComplete;
	import cwin5.utils.C5Utils;
	import cwin5.utils.cache.CacheManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	/**
	 * 图像载入器, 默认图像会居中
	 * 例 :
	 * addChild(new C5ImageLoader("img.jpg" , 100 , 100).container);
	 * @author cwin5
	 */
	public class C5ImageLoader extends BasicComplete
	{
		public static var DEFAULT_IMG:Class;
		
		private static const IMG_DICT:Dictionary = new Dictionary();
		
		private static function getList(url:String , create:Boolean):Array
		{
			if (IMG_DICT[url] == null && create)
				IMG_DICT[url] = [];
			return IMG_DICT[url];
		}
		
		/**
		 * 创建图片
		 * @param	url
		 * @param	width
		 * @param	height
		 * @param	isCenter
		 * @return
		 */
		public static function createImg(url:String , width:Number = 0 , 
							height:Number = 0 , isCenter:Boolean = true, defaultClass:Class = null):C5ImageLoader
		{
			var img:C5ImageLoader;
			var list:Array = getList(url, false);
			
			if (list && list.length > 0)
			{
				img = list[0];
				list.shift();
				img.updateParam(width, height, isCenter);
			}
			else
			{
				img = new C5ImageLoader(url, width, height, isCenter, defaultClass);
			}
			
			return img;
		}
		
		
		private var _isSuccess:Boolean = false;
		
		private var _loader:Loader = null;
		
		private var _container:DisplayObjectContainer = null;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _isLoading:Boolean = false;
		private var _isCenter:Boolean = false;
		
		private var _url:String = "";
		
		private var _defaultImg:DisplayObject;
		
		
		/**
		 * 构造,默认不设置宽高
		 * @param	url				头像地址
		 * @param	width			最大宽
		 * @param	height			最大高
		 * @param	isCenter		是否居中
		 * @param	defalutClass	默认图像
		 */
		public function C5ImageLoader(url:String , width:Number = 0 , height:Number = 0 , isCenter:Boolean = true , defaultClass:Class = null) 
		{
			updateParam(width, height, isCenter);
			_container = new Sprite();
			_container.cacheAsBitmap = true;
			_url = url;
			
			if (defaultClass == null)
				defaultClass = DEFAULT_IMG;
			
			if (defaultClass)
			{
				_defaultImg = CacheManager.instance.getObject(defaultClass);
				_defaultImg.cacheAsBitmap = true;
				_container.addChild(_defaultImg);
			}
		}
		
		/**
		 * 更新参数
		 * @param	width
		 * @param	height
		 * @param	isCenter
		 */
		internal function updateParam(width:Number = 0 , height:Number = 0 , isCenter:Boolean = true):void
		{
			_width = width;
			_height = height;
			_isCenter = isCenter;
		}
		
		/**
		 * 开始 , 子类复写
		 */
		override public function start():void
		{
			if (_isSuccess)
			{
				updateSize(_loader);
				complete();
				return;
			}
			
			updateSize(_defaultImg);
			
			if (_isLoading)
				return;
			
			if (!_url)
				return;
			
			_loader = new Loader();
			_container.addChild(_loader);
			
			addEvent();
			var urlReq:URLRequest = new URLRequest(_url);
			_loader.load(urlReq, new LoaderContext(true));
		}
		
		/**
		 * 缓存
		 */
		public function cache():void
		{
			if (_loader)
			{	
				_loader.scaleX = _loader.scaleY = 1;
				_container.x = _container.y = _loader.x = _loader.y = 0;
				_container.alpha = 1;
			}
			_container.mask = null;
			C5Utils.removeFromStage(_container);
			var list:Array = getList(_url, true);
			C5Utils.addElement(list, this);
		}
		
		/**
		 * 释放
		 */
		public function destroy():void
		{
			clearDefaultImg();
			C5Utils.removeFromStage(_container);
			if (_isLoading)
			{
				removeEvent();
			}
			else if(_loader)
				_loader.unload();
		}
		
		/**
		 * 载入图像完成
		 * @param	e
		 */
		private function onLoaderImageComplete(e:Event):void 
		{
			_isSuccess = true;
			removeEvent();
			
			updateSize(_loader);
			
			clearDefaultImg();
			
			complete();
		}
		
		private function clearDefaultImg():void
		{
			if (_defaultImg)
			{
				_defaultImg.scaleX = _defaultImg.scaleY = 1;
				C5Utils.removeFromStage(_defaultImg);
				CacheManager.instance.delObject(_defaultImg);
				_defaultImg = null;
			}
		}
		
		private function updateSize(displayObj:DisplayObject):void
		{
			if (!displayObj)
				return;
			
			if (_width != 0 || _height != 0)
			{
				if (_width != 0 && _height != 0) 
				{
					if (_width == _height)			// 相等时即为正方形
					{
						if (displayObj.width < displayObj.height)
						{
							setSizeByWidth(displayObj);
						}
						else
						{
							setSizeByHeight(displayObj);
						}
					}
					else			// 外部强制设为这个宽高
					{
						displayObj.width = _width;
						displayObj.height = _height;
					}
				}
				else if ( _width != 0)			// 以宽为标准
				{
					setSizeByWidth(displayObj);
				}
				else							// 以高为标准
				{
					setSizeByHeight(displayObj);
				}
			}
			
			// 是否居中
			if (displayObj == _loader && _isCenter)
			{
				_loader.x = -_loader.width / 2;
				_loader.y = -_loader.height / 2;
			}
		}
		
		// 根据宽来设置大小
		private function setSizeByWidth(displayObj:DisplayObject):void
		{
			displayObj.width = _width;
			//_loader.y = (1 - _loader.scaleX) / 2 * _loader.height;
			displayObj.scaleY = displayObj.scaleX;
		}
		
		// 根据高来设置大小
		private function setSizeByHeight(displayObj:DisplayObject):void
		{
			displayObj.height = _height;
			//_loader.x = (1 - _loader.scaleY) / 2 * _loader.width;
			displayObj.scaleX = displayObj.scaleY;
		}
		
		/**
		 * IO错误
		 * @param	e
		 */
		private function onError(e:ErrorEvent = null):void 
		{
			removeEvent();
			C5Utils.removeFromStage(_loader);
			_loader = null;
			complete();
		}
		
		/**
		 * 添加事件
		 */
		private function addEvent():void
		{
			_isLoading = true;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoaderImageComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		/**
		 * 移除事件
		 */
		private function removeEvent():void
		{
			_isLoading = false;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onLoaderImageComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		/**
		 * loader对象
		 */
		public function get loader():Loader { return _loader; }
		
		/**
		 * 是否成功载入
		 */
		public function get isSuccess():Boolean { return _isSuccess; }
		
		/**
		 * 容器
		 */
		public function get container():DisplayObjectContainer { return _container; }
		
		/**
		 * 地址
		 */
		public function get url():String { return _url; }
		
	}
	
}