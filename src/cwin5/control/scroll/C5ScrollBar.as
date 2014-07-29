package cwin5.control.scroll 
{
	import com.greensock.TweenLite;
	import cwin5.control.btn.C5Button;
	import cwin5.control.StageProxy;
	import cwin5.utils.C5EnterFrame;
	import cwin5.utils.C5Timer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 滑块位置改变
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")] 
	
	/**
	 * 滚动条位置
	 * @author cwin5
	 */
	public class C5ScrollBar extends EventDispatcher
	{
		/// 最大数
		private var _maxCount:Number = 0;
		public function get maxCount():Number { return _maxCount; }
		
		/// 当前最大数
		private var _curCount:Number = 0;
		
		/// 百分比 0-1
		private var _percent:Number = 0;
		public function get percent():Number { return _percent; }
		
		/// 当前数位置
		private var _curPos:Number = 0;
		
		/// 滑块位置最大高
		private var _maxHei:Number = 0;
		private var _minHei:Number = 0;
		
		private var _view:Sprite = null;
		public function get view():Sprite { return _view; }
		
		private var _bar:Sprite = null;
		private var _subBar:Sprite;
		private var _flagSp:Sprite;
		
		private var _enable:Boolean = false;
		
		private var _barCon:C5Button = null;
		private var _topBtn:C5Button = null;
		private var _bottomBtn:C5Button = null;
		
		/**
		 * 构造
		 * @param	view
		 * @param	maxCount		可显示数
		 * @param	curCount		当前总数
		 */
		public function C5ScrollBar(view:Sprite , maxCount:Number ,curCount:Number = 0 , minHei:Number = 0) 
		{
			_view = view;
			_bar = view["bar"];
			_subBar = _bar["bar"];
			_flagSp = _bar["flag"];
			
			_minHei = minHei;
			
			_barCon = new C5Button(_bar as MovieClip , false);
			_barCon.downFunc = onBarMouseDown;
			_barCon.overFunc = onBarOver;
			_barCon.outFunc = onBarOut;
			_barCon.clickFunc = onConClick;
			
			if (_subBar is MovieClip)
				_subBar["gotoAndStop"](1);
			
			if (view.hasOwnProperty("top"))
			{
				_topBtn = new C5Button(view["top"] , false);
				_bottomBtn = new C5Button(view["bottom"], false);
				
				_topBtn.downFunc = _bottomBtn.downFunc = onBtnDown;
				_topBtn.outFunc = _bottomBtn.outFunc = onBtnOut;
				
				_topBtn.clickFunc = _bottomBtn.clickFunc = onConClick;
			}
			
			_maxHei = _bar.height;
			_maxCount = maxCount;
			_curCount = curCount;
			
			if (curCount > maxCount)
				updateBarSize();
			else
				_bar.visible = false;
		}
		
		private function onConClick(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		private function onBarOver(e:MouseEvent):void
		{
			if (_subBar is MovieClip && !_isdown)
				_subBar["gotoAndStop"](2);
		}
		
		private function onBarOut(e:MouseEvent):void
		{
			if (_subBar is MovieClip && !_isdown)
				_subBar["gotoAndStop"](1);
		}
		
		/// 更新滑块大小
		private function updateBarSize():void
		{
			var tp:Number = _maxCount / curCount - .1;
			if (tp < .1)
				tp = .1;
			changeBarSize(tp * _maxHei);
			if (_minHei != 0 && _bar.height < _minHei)
				changeBarSize(_minHei);
		}
		
		private function changeBarSize(size:Number):void
		{
			if (_flagSp)
			{
				_flagSp.y = size / 2;
			}
			if (_subBar)
			{
				_subBar.height = size;
			}
			else
			{
				_bar.height = size;
			}
		}
		
		/// 更新滑块位置
		private function updateBarPos(force:Boolean = false):void
		{
			TweenLite.killTweensOf(_bar);
			var p:Number = _percent;
			if (_percent < 0)
				p = 0;
			else if (_percent > 1)
				p = 1;
			if (force)
				_bar.y = (_maxHei - _bar.height) * p;
			else
				TweenLite.to(_bar , .2 , { y:(_maxHei - _bar.height) * p } );
		}
		
		/**
		 * 添加事件
		 */
		private function addEvent():void
		{
			if (_bottomBtn)
				_bottomBtn.enable = _topBtn.enable = true;
			_barCon.enable = true;
			_view.addEventListener(MouseEvent.CLICK , onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_view.mouseY > _bar.y)
			{
				setCurPos(_curPos + _maxCount, true);
			}
			else
			{
				setCurPos(_curPos - _maxCount, true);
			}
		}
		
		/**
		 * 移除事件
		 */
		private function removeEvent():void
		{
			if (_bottomBtn)
				_bottomBtn.enable = _topBtn.enable = false;
			_barCon.enable = false;
			_isdown = false;
			_view.removeEventListener(MouseEvent.CLICK , onClick);
		}
		
		private var _isdown:Boolean = false;
		
		/// 鼠标按下
		private function onBarMouseDown(e:MouseEvent):void 
		{
			e.currentTarget.stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			e.currentTarget.stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
			_oldPos = _view.mouseY;
			_downPos = _bar.y;
			_isdown = true;
			if (_subBar is MovieClip)
				_subBar["gotoAndStop"](3);
		}
		
		/// 鼠标弹起
		private function onMouseUp(e:MouseEvent):void 
		{
			e.currentTarget.stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			e.currentTarget.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
			_isdown = false;
			if (_subBar is MovieClip)
				_subBar["gotoAndStop"](1);
		}
		
		private var _oldPos:Number = 0;
		private var _downPos:Number = 0;
		
		/// 鼠标移动
		private function onMouseMove(e:MouseEvent):void 
		{
			var ty:Number = _view.mouseY - _oldPos;
			//_oldPos = _view.mouseY;
			var y:Number = _downPos + ty;
			if (y < 0)
				y = 0;
			else if (y > _maxHei - _bar.height)
				y = _maxHei - _bar.height;
			
			var tp:Number = y / (_maxHei - _bar.height);
			_bar.y = y;
			setPercent(tp);
 		}
		
		/// 设置百分比
		public function setPercent(percent:Number):void
		{
			if (_percent == percent)
				return;
			_percent = percent;
			_curPos = _percent * (_curCount - _maxCount);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 添加当前位置
		 * @param	per
		 */
		public function addCurPos(per:Number):void
		{
			setCurPos(_curPos + (_maxCount * .1) , true);
		}
		
		public function minCurPos(per:Number):void
		{
			setCurPos(_curPos - (_maxCount * .1) , true);
		}
		
		/**
		 * 设置当前位置
		 * @param	p
		 * @return 	是否需要中断
		 */
		public function setCurPos(p:Number , sendEvent:Boolean = false, force:Boolean = false , md:Number = 0):Boolean
		{
			if (_curCount <= _maxCount)
				return true;
			
			_curPos = p;
			//trace("_curPos" , _curPos, "updatePos" , updatePos, "p" , p);
			
			var flag:Boolean = false;
			
			if (_curPos > _curCount - _maxCount + md)
			{
				_curPos = _curCount - _maxCount + md;
				flag = true;
			}
			else if (_curPos < -md)
			{
				flag = true;
				_curPos = -md;
			}
			
			_percent = _curPos / (_curCount - _maxCount);
			updateBarPos(force);
			
			if (sendEvent)
				dispatchEvent(new Event(Event.CHANGE));
			return flag;
		}
		
		public function killCheckPos():void
		{
			if (_updatePosTween)
			{
				_updatePosTween.kill();
				_updatePosTween = null;
			}
		}
		
		public function checkPos(md:Number = 50):void
		{
			if (_curCount <= _maxCount)
				return;
			var t:Number;
			if (_curPos > _curCount - _maxCount)
			{
				t = _curCount - _maxCount;
			}
			else if (_curPos < 0)
			{
				t = 0;
			}
			if (!isNaN(t))
			{
				updatePos = _curPos;
				killCheckPos();
				_updatePosTween = TweenLite.to(this, .5 , { updatePos:t, onUpdate:updatePosFun, onUpdateParams:[md],onComplete:onUpdatePosComplete } );
			}
		}
		
		private function onUpdatePosComplete():void 
		{
			_updatePosTween = null;
		}
		
		public var updatePos:Number;
		private var _updatePosTween:TweenLite;
		private function updatePosFun(md:Number):void
		{
			setCurPos(updatePos, true, false, md);
		}
		
		
		/**
		 * 当前数
		 */
		public function get curCount():Number { return _curCount; }
		public function set curCount(value:Number):void 
		{
			if (_curCount == value)
				return;
			
			_curCount = value;
			
			if (curCount > _maxCount)
			{
				updateBarSize();
				updateBarPos();
				_bar.visible = true;
			}
			else
			{
				_bar.visible = false;
				setPercent(0);
			}
		}
		
		/**
		 * 当前位置
		 */
		public function get curPos():Number { return _curPos; }
		
		/**
		 * 是否启用
		 */
		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void 
		{
			if (_enable == value)
				return;
			
			_enable = value;
			
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		/**
		 * 最大高
		 */
		public function get maxHei():Number { return _maxHei; }
		public function set maxHei(value:Number):void 
		{
			_maxHei = value;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private var _isClick:Boolean = true;
		private var _clickBtn:Object;
		
		/// 按钮按下
		private function onBtnDown(e:MouseEvent):void
		{
			if (!_bar.visible)
				return;
			
			_clickBtn = e.currentTarget;
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , onBtnMouseUp);
			_isClick = true;
			C5Timer.add(.1, onTimer, e.currentTarget);
		}
		
		/// 按钮移除
		private function onBtnOut(e:MouseEvent = null):void
		{
			if (!_bar.visible)
				return;
			
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_UP , onBtnMouseUp);
			C5Timer.remove(onTimer);
			C5EnterFrame.removeFunction(changeCurPos);
			_clickBtn = null;
		}
		
		/// 弹起
		private function onBtnMouseUp(e:MouseEvent):void 
		{
			if (_isClick)
			{
				switch (_clickBtn) 
				{
					case _topBtn.mc:
						setCurPos(_curPos - (_maxCount * .2) , true);
						break;
						
					case _bottomBtn.mc:
						setCurPos(_curPos + (_maxCount * .2) , true);
						break;
				}
			}
			
			onBtnOut();
			
		}
		
		/// 计时器到了
		private function onTimer(obj:Object):void
		{
			_isClick = false;
			C5EnterFrame.addFunction(changeCurPos , 0, [obj]);
		}
		
		/// 改变当前位置
		private function changeCurPos(obj:Object):void
		{
			switch (obj) 
			{
				case _topBtn.mc:
					setCurPos(_curPos - (_maxCount * .05) , true);
					break;
					
				case _bottomBtn.mc:
					setCurPos(_curPos + (_maxCount * .05) , true);
					break;
			}
		}
		
		
	}

}