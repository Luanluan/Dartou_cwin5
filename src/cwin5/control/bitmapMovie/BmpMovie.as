package cwin5.control.bitmapMovie 
{
	import cwin5.control.StageProxy;
	import cwin5.utils.C5Utils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author luanluan
	 */
	public class BmpMovie extends EventDispatcher
	{
		private var _mc:MovieClip;
		
		private var _frames:Vector.<BmpFrame>;
		private var _frame_current:BmpFrame;
		
		private var _bmp:Bitmap;
		
		private var _bounds:Rectangle;
		
		private var _container:DisplayObjectContainer;
		
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		private var _x:Number;
		private var _y:Number;
		private var _alpha:Number;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _rotation:Number;
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _isPlaying:Boolean;
		private var _view:Sprite;
		
		private var _scriptDic:Dictionary = new Dictionary();
		
		private var _visible:Boolean = true;
		
		private var _mouseChildren:Boolean = true;
		private var _mouseEnabled:Boolean = true;
		
		private var _drawFrame:int = 1;
		private var _isDrawing:Boolean = false;
		
		/**
		 * 位图影片，将影片剪辑转换成序列位图
		 * @param	mc			源MovieClip
		 */
		public function BmpMovie(mc:MovieClip , drawAsyn:Boolean = false) 
		{
			_mc = mc;
			init();
			drawMc(drawAsyn);
		}
		
		private function init():void
		{
			_view = new Sprite();
			_bounds = getMcRect(_mc);
			createBitmap(_bounds.right, _bounds.bottom , _mc, _view);
		}
		
		private function drawMc(drawAsyn:Boolean):void 
		{
			_totalFrames = _mc.totalFrames;
			
			_initWidth = _mc.width;
			_initHeight = _mc.height;
			this.scaleX = _mc.scaleX;
			this.scaleY = _mc.scaleY;
			this.x = _mc.x;
			this.y = _mc.y;
			
			_frames = new Vector.<BmpFrame>(_totalFrames, true);
			_drawFrame = 1;
			_isDrawing = true;
			if (!drawAsyn)
			{
				for (_drawFrame; _drawFrame < _totalFrames + 1; _drawFrame++) 
				{
					drawFrame();
				}
				_mc = null;
				_isDrawing = false;
			}
			else
			{
				_bmp.addEventListener(Event.ENTER_FRAME , drawFrameAsyn);
			}
			
			_currentFrame = 1;
			_frame_current = _frames[0];
		}
		
		private function drawFrameAsyn(e:Event):void 
		{
			if (_drawFrame > _totalFrames)
			{
				_bmp.removeEventListener(Event.ENTER_FRAME , drawFrameAsyn);
				_isDrawing = false;
				_mc = null;
				return;
			}
			drawFrame();
			_drawFrame++;
		}
		
		private function drawFrame():void
		{
			var bmpData:BitmapData;
			var bmpFrame:BmpFrame;
			_mc.gotoAndStop(_drawFrame);
			
			bmpData = null;
			bmpData = new BitmapData(_bounds.width, _bounds.height, true, 0);
			bmpData.draw(_mc, new Matrix(1, 0, 0, 1, -_bounds.left, -_bounds.top));
			
			bmpFrame = new BmpFrame(_drawFrame, bmpData);
			_frames[_drawFrame - 1] = bmpFrame;
		}
		
		private function createBitmap(right:Number, bottom:Number, mc:MovieClip, container:Sprite):void
		{
			if (this._bmp) return;
			this._bmp = new Bitmap();
			this._bmp.smoothing = true;
			this._bmp.x = right;
			this._bmp.y = bottom;
			container.addChild(this._bmp);
		}
		
		private function getMcRect(mc:MovieClip):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			var maxRight:Number = 0;
			var maxBottom:Number = 0;
			var maxLeft:Number = 0;
			var maxTop:Number = 0;
			for (var i:int = 0; i < mc.totalFrames; i++) 
			{
				mc.gotoAndStop(i +1);
				rect = mc.getBounds(mc);
				
				if (rect.right > maxRight) 
					maxRight = rect.right;
				if (rect.bottom > maxBottom) 
					maxBottom = rect.bottom;
				if (rect.left < maxLeft) 
					maxLeft = rect.left;
				if (rect.top < maxTop)
					maxTop = rect.top;
			}
			mc.gotoAndStop(1);
			rect.right = maxRight;
			rect.bottom = maxBottom;
			rect.left = maxLeft;
			rect.top = maxTop;
			return rect;
		}
		
		
		/**
		 * 播放
		 */
		public function play():void
		{
			if (_bmp)
			{
				_bmp.addEventListener(Event.ENTER_FRAME , render);
			}
			_isPlaying = true;
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			if (_bmp)
			{
				_bmp.removeEventListener(Event.ENTER_FRAME , render);
			}
			_isPlaying = false;
		}
		
		/**
		 * 跳到目标帧并播放
		 * @param	target
		 */
		public function gotoAndPlay(target:int):void
		{
			_currentFrame = target;
			gotoFrame();
			if (!_isPlaying)
				play();
		}
		
		/**
		 * 跳到目标帧并停止
		 * @param	target
		 */
		public function gotoAndStop(target:int):void
		{
			_currentFrame = target;
			gotoFrame();
			if (_isPlaying)
				stop();
		}
		
		/**
		 * 添加到容器
		 * @param	container
		 */
		public function addToContainer(container:DisplayObjectContainer , index:int = -1):void
		{
			_container = container;
			if (index < 0)
				_container.addChild(_view);
			else
				_container.addChildAt(_view ,  index);
		}
		
		/**
		 * 从容器中移除
		 */
		public function removeFromContainer():void
		{
			if (_view.parent)
				_view.parent.removeChild(_view);
			for (var i:int = 0; i < _frames.length; i++) 
			{
				var bmp:BmpFrame = _frames[i];
			}
		}
		
		/**
		 * 向指定帧添加函数
		 * @param	frame	
		 * @param	func
		 */
		public function addFrameScript(frame:int , func:Function):void
		{
			if (func == null)
				delete _scriptDic[frame];
			else
				_scriptDic[frame] = func;
		}
		
		private function gotoFrame():void
		{
			if (_currentFrame <1 || _currentFrame >_totalFrames)
				_currentFrame = 1;
			
			if (_frame_current)
				_frame_current = null;
			_frame_current = _frames[_currentFrame -1];
			
			_bmp.bitmapData = _frame_current.bitmapData;
			
			if (_scriptDic[_currentFrame])
			 _scriptDic[_currentFrame]();
		}
		
		private function render(e:Event):void
		{
			if(!_isDrawing)
				gotoFrame();
			_currentFrame++;
		}
		
		public function get x():Number 								{			return _x;										}
		
		public function set x(value:Number):void 					{			_view.x = _x = value - _initWidth;		}
		
		public function get alpha():Number							{			return _alpha;									}
		
		public function set alpha(value:Number):void				{			_view.alpha = _alpha = value;					}
		
		public function get y():Number 								{			return _y;										}
		
		public function set y(value:Number):void 					{			_view.y = _y = value - _initHeight;		}
		
		public function get currentFrame():int 						{			return _currentFrame;							}
		
		public function get totalFrames():int 						{			return _totalFrames;							}
		
		public function get isPlaying():Boolean 					{			return _isPlaying;								}
		
		public function get container():DisplayObjectContainer 		{			return _container;								}
		
		public function get visible():Boolean 						{			return _visible;								}
		
		public function set visible(value:Boolean):void 			{			_view.visible = _visible = value;				}
		
		public function get rotation():Number 						{			return _rotation;								}
		
		public function set rotation(value:Number):void 			{			_view.rotation = _rotation = value;				}
		
		public function get scaleY():Number 						{			return _scaleY;									}
		
		public function set scaleY(value:Number):void 				{			_view.scaleY = _scaleY = value;					}
		
		public function get scaleX():Number 						{			return _scaleX;									}
		
		public function set scaleX(value:Number):void 				{			_view.scaleX = _scaleX = value;					}
		
		public function get mouseEnabled():Boolean 					{			return _mouseEnabled;							}
		
		public function set mouseEnabled(value:Boolean):void 		{			_view.mouseEnabled = _mouseEnabled = value;		}
		
		public function get mouseChildren():Boolean 				{			return _mouseChildren;							}
		
		public function set mouseChildren(value:Boolean):void 		{			_view.mouseChildren = _mouseChildren = value;	}
		
		public function set frames(value:Vector.<BmpFrame>):void 
		{
			_frames = value;
			_currentFrame = 1;
			_frame_current = _frames[0];
		}
		
		
	}

}