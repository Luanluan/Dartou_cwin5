package cwin5.control 
{
	import com.adobe.serialization.json.JSON;
	//import com.cwin5.dice.module.room.BitmapRes;
	import cwin5.utils.C5Static;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author ...
	 */
	public class Animation extends Sprite
	{
		private var _totalFrames:int;
		private var _view:Bitmap;
		private var _srcBmd:DisplayObject;
		private var _rect:Rectangle;
		private var _width:Number;
		private var _height:Number;
		private var _curFrames:int;
		private var _onCompleteCallBack:Function;
		private var _bmdArr:Array;
		
		private var _lableDic:Dictionary;
		private var _frameScriptDic:Dictionary = new Dictionary();
		/**
		 * 构造
		 */
		public function Animation(srcBmd:DisplayObject , frames:int , onCompleteCallBack:Function = null ,lables:Dictionary = null) 
		{
			_srcBmd = srcBmd;
			_totalFrames = frames;
			_onCompleteCallBack = onCompleteCallBack;
			_width = srcBmd.width;
			_height = srcBmd.height / frames;
			_rect = new Rectangle(0 , 0 , _width , _height);
			initBmdArr();
			_view = new Bitmap(_bmdArr[0] , "auto" , true);
			_view.x = -_width / 2;
			_view.y = -_height / 2;
			this.mouseEnabled = this.mouseChildren = false;
			
			addChild(_view);
			
			if (lables != null ) 
			{
				if (checkLables(lables)) 
				{
					_lableDic = lables;
				}
				else
				{
					throw new Error ("Animation: Wrong lables setting")
				}
			}
		}
		
		private function checkLables(lables:Dictionary):Boolean 
		{
			for (var key:Object in lables)
			{
				if (!(key is String)) 
				{
					return false;
				}
				
				if (!(lables[key] is int)) 
				{
					return false;
				}
			}
			return true;
		}
		
		private function initBmdArr():void
		{
			_bmdArr = [];
			if (_srcBmd is MovieClip)
			{
				var mc:MovieClip = _srcBmd as MovieClip;
				for (var j:int = 0; j < mc.totalFrames; ++j )
				{
					var bmd2:BitmapData = new BitmapData(mc.width , mc.height , true , 0x00FFFFFF);
					mc.gotoAndStop(j + 1);
					bmd2.draw(mc);
					_bmdArr.push(bmd2);
				}
			}
			else if(_srcBmd is BitmapData)
			{
				var bd:BitmapData = _srcBmd as BitmapData;
				var i:int;
				for (i = 0; i < _totalFrames; i++)
				{
					var bmd:BitmapData = new BitmapData(_width , _height , true , 0x00FFFFFF);
					_rect.y = i * _height;
					bmd.copyPixels(bd , _rect , C5Static.ORIGIN);
					_bmdArr.push(bmd);
				}
			}
		}
		
		public function kill():void
		{
			for (var i:int = 0; i < _bmdArr.length; i++) 
			{
				var item:BitmapData = _bmdArr[i];
				item.dispose();
			}
		}
		
		private function play():void
		{
			addEventListener(Event.ENTER_FRAME , nextFrame);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME , nextFrame);
		}
		
		private function nextFrame(e:Event):void
		{
			setFrame(_curFrames + 1);
		}
		
		public function get curFrames():int
		{
			return _curFrames;
		}
		
		private function setFrame(frame:int):void
		{
			//trace(frame);
			if (_frameScriptDic.hasOwnProperty(frame)) 
			{
				_frameScriptDic[frame].call();
			}
			
			
			if (frame > _totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME , nextFrame);
				if (_onCompleteCallBack != null)
					_onCompleteCallBack();
				return;
			}
			if (frame < 1) 
			{
				frame = 1;
			}
			
			_curFrames = frame;
			_view.bitmapData = _bmdArr[_curFrames - 1] as BitmapData;
			_view.smoothing = true;
		}
		
		public function gotoAndStop(object:Object):void
		{
			goto(object);
			stop();
		}
		
		public function gotoAndPlay(object:Object):void
		{
			goto(object);
			play();
		}
		
		private function goto(object:Object):void
		{
			var targetFrame:int;
			if (_lableDic != null && _lableDic[object]!= null) 
			{
				targetFrame = _lableDic[object];
			}
			else if (object is int)
			{
				targetFrame = object as int;
			}
			else
			{
				targetFrame = 1;
			}
			setFrame(targetFrame);
		}
		
		public function addFrameScript(...arg):void
		{
			if (arg.length % 2 != 0) 
			{
				throw Error("Animation / addFrameScript:參數數量錯誤")
			}
			for (var i:int = 0; i < arg.length; i+=2 ) 
			{
				if (arg[i] is uint && arg[i]<=_totalFrames) 
				{
					if (arg[i+1] is Function) 
					{
						_frameScriptDic[arg[i]] = arg[i + 1];
					}
					else if (arg[i+1] == null) 
					{
						if (_frameScriptDic.hasOwnProperty(arg[i])) 
						{
							_frameScriptDic[arg[i]] = null;
							delete _frameScriptDic[arg[i]];
						}
					}
					else
					{
						throw Error("Animation / addFrameScript:回调函数參數內容錯誤")
					}
					
				}
				else
				{
					throw Error("Animation / addFrameScript:帧数參數內容錯誤")
				}
				
			}
		}
	}

}