package cwin5.control 
{
	import cwin5.control.btn.C5Button;
	import cwin5.utils.C5EnterFrame;
	import cwin5.utils.C5Timer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author cwin5
	 */
	public class C5Slider extends EventDispatcher
	{
		
		private var _maxBtn:C5Button;
		private var _minBtn:C5Button;
		private var _barBtn:C5Button;
		private var _rect:Sprite;
		
		private var _distance:Number;
		private var _percent:Number = 0;		// 百分比 0-1
		private var _startPos:Number;
		
		private var _enable:Boolean = false;
		
		public function get enable():Boolean { return _enable; }
		
		public function set enable(value:Boolean):void 
		{
			if (_enable == value)
				return
			_enable = value;
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		/**
		 * 构造
		 * @param	max
		 * @param	min
		 * @param	bar
		 * @param	distance
		 */
		public function C5Slider(max:C5Button , min:C5Button , bar:C5Button , rect:Sprite, distance:Number) 
		{
			_maxBtn = max;
			_minBtn = min;
			_barBtn = bar;
			_rect = rect;
			
			_distance = distance;
			_startPos = _barBtn.mc.x;
			
			_rect.buttonMode = true;
			
			_maxBtn.downFunc = _minBtn.downFunc = onBtnDown;
			_barBtn.downFunc = onBarDown;
		}
		
		public function setPercent(percent:Number , sendEvent:Boolean = false):void
		{
			if (percent < 0)
				percent = 0;
			else if (percent > 1)
				percent = 1;
				
			if (_percent == percent)
				return;
			
			_percent = percent;
			_barBtn.mc.x = _startPos + _percent * _distance;
			
			if (sendEvent)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function addEvent():void
		{
			_maxBtn.enable = _minBtn.enable = _barBtn.enable = true;
			_rect.addEventListener(MouseEvent.CLICK , onRectClick);
		}
		
		private function removeEvent():void
		{
			_maxBtn.enable = _minBtn.enable = _barBtn.enable = false;
			_rect.removeEventListener(MouseEvent.CLICK , onRectClick);
		}
		
		
		public function get percent():Number { return _percent; }
		
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private function onBarDown(e:MouseEvent):void
		{
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , onBarUp);
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_MOVE , onBarMove);
		}
		
		private function onBarUp(e:MouseEvent):void 
		{
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_UP , onBarUp);
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onBarMove);
		}
		
		private function onBarMove(e:MouseEvent):void 
		{
			var curPos:Number = _barBtn.mc.parent.mouseX - _startPos;
			setPercent(curPos / _distance , true);
		}
		
		////////////////////////////////////////////////////////////////////////////////
		private function onRectClick(e:MouseEvent):void 
		{
			onBarMove(e);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private var _isClick:Boolean = true;
		private var _clickBtn:Object;
		
		/// 按钮按下
		private function onBtnDown(e:MouseEvent):void
		{
			_clickBtn = e.currentTarget;
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , onBtnMouseUp);
			_isClick = true;
			C5Timer.add(.1, onTimer, e.currentTarget);
		}
		
		/// 按钮移除
		private function onBtnOut(e:MouseEvent = null):void
		{
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
					case _maxBtn.mc:
						setPercent(_percent + .2 , true);
						break;
						
					case _minBtn.mc:
						setPercent(_percent - .2  , true);
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
				case _maxBtn.mc:
					setPercent(_percent + .02 , true);
					break;
					
				case _minBtn.mc:
					setPercent(_percent - .02  , true);
					break;
			}
		}
		
		
	}

}