package cwin5.control 
{
	import cwin5.control.btn.C5Button;
	import cwin5.utils.C5EnterFrame;
	import cwin5.utils.C5Timer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	[Event(name = "change" , type = "flash.events.Event")]
	/**
	 * ...
	 * @author heyao
	 */
	public class NumberChooser extends EventDispatcher 
	{
		protected var _nextBtn:C5Button;
		protected var _prevBtn:C5Button;
		
		protected var _minNum:int;
		protected var _maxNum:int;
		
		protected var _incremental:int;
		
		protected var _countTxt:TextField;
		
		protected var _enable:Boolean;
		
		protected var _value:int;
		
		protected var _continuous:Boolean;
		
		/**
		 * 
		 * @param	nextBtn
		 * @param	prevBtn
		 * @param	countTxt
		 * @param	startNum
		 * @param	endNum
		 * @param	incremental
		 * @param	continuous
		 */
		public function NumberChooser(nextBtn:MovieClip , prevBtn:MovieClip , countTxt:TextField , startNum:int = 0 , endNum:int = 10 , incremental:int = 1 ,continuous:Boolean=false) 
		{
			_countTxt = countTxt;
			_countTxt.restrict = "0-9";
			_nextBtn = new C5Button(nextBtn);
			_nextBtn.downFunc = addEnterFrame;
			_nextBtn.upFunc = removeEnterFrame;
			_prevBtn = new C5Button(prevBtn);
			_prevBtn.downFunc = addEnterFrame;
			_prevBtn.upFunc = removeEnterFrame;
			_countTxt = countTxt;
			_countTxt.text = startNum + "";
			_incremental = incremental;
			_value = startNum;
			_minNum = startNum;
			_maxNum = endNum;
			_continuous = continuous;
		}
		
		public function get value():int
		{
			var txtNum:int = int(_countTxt.text);
			if (txtNum != _value)
			{
				if (txtNum > _maxNum)
				{
					_countTxt.text = _maxNum + "";
					value = _maxNum;
				}
				else
				{
					value = txtNum;
				}
			}
			return _value;
		}
		
		public function set value(num:int):void
		{
			_value = num;
			_countTxt.text = _value + "";
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get enable():Boolean { return _enable; }
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		public function set incremental(value:int):void 
		{
			_incremental = value;
		}
		
		public function get incremental():int { return _incremental; }
		
		protected function addEvent():void
		{
			_nextBtn.enable = true;
			_prevBtn.enable = true;
			
			_countTxt.addEventListener(Event.CHANGE, textChangeHandle);
			
			if (_continuous)
			{
				_nextBtn.mc.addEventListener(MouseEvent.MOUSE_OUT, removeEnterFrame);
				_nextBtn.mc.addEventListener(MouseEvent.MOUSE_UP, removeEnterFrame);
				StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , removeEnterFrame);
			}
			
		}
		
		private function textChangeHandle(e:Event):void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function addEnterFrame(e:MouseEvent):void 
		{
			switch(e.currentTarget )
			{
				case _prevBtn.mc:
					if (_continuous) 
					{
						minus();
						C5Timer.add(0.5 , startMinus);
					}
					else minus();
					break;
				case _nextBtn.mc:
					if (_continuous) 
					{
						add();
						C5Timer.add(0.5 , startAdd);
					}
					else add();
					break;
				default:
					break;
			}
		}
		
		protected function removeEvent():void
		{
			_nextBtn.enable = false;
			_prevBtn.enable = false;
			
			if (_continuous)
			{
				C5Timer.remove(startAdd);
				C5Timer.remove(startMinus);
				_nextBtn.mc.removeEventListener(MouseEvent.MOUSE_OUT, removeEnterFrame);
				_prevBtn.mc.removeEventListener(MouseEvent.MOUSE_OUT, removeEnterFrame);
			}
			
		}
		
		private function removeEnterFrame(e:MouseEvent=null):void 
		{
			C5Timer.remove(startAdd);
			C5Timer.remove(startMinus);
			C5EnterFrame.removeFunction(add);
			C5EnterFrame.removeFunction(minus);
		}
		
		private function startAdd():void
		{
			C5EnterFrame.addFunction(add);
		}
		
		private function startMinus():void
		{
			C5EnterFrame.addFunction(minus);
		}
		
		private function add(e:Event=null):void
		{
			if (value + _incremental <= _maxNum)
			{
				value += _incremental;
			}
			else
				value = _maxNum;
		}
		
		private function minus(e:Event=null):void
		{
			if (value - _incremental >= _minNum)
			{
				value -= _incremental;
			}
			else
				value = _minNum;
		}
	}

}