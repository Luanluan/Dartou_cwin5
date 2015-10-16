package cwin5.control.text 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	/**
	 * 数字文本管理
	 * 限制输入大小
	 * @author cwin5
	 */
	public class C5NumTxt extends EventDispatcher
	{
		
		private var _textField:TextField;
		private var _max:Number;
		private var _min:Number;
		
		private var _enable:Boolean = false;
		
		private var _isSelection:Boolean;
		
		public function get enable():Boolean { return _enable; }
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			
			if (_enable)
			{
				_textField.addEventListener(Event.CHANGE , onTextChange);
				_textField.addEventListener(FocusEvent.FOCUS_OUT , onTextChange);
			}
			else
			{
				_textField.removeEventListener(Event.CHANGE , onTextChange);
				_textField.removeEventListener(FocusEvent.FOCUS_OUT, onTextChange);
			}
		}
		
		public function get textField():TextField { return _textField; }
		
		private function onTextChange(e:Event):void 
		{
			checkTxt();
		}
		
		private function checkTxt():void
		{
			if (_needCheckTxt)
			{
				var num:Number = Number(_textField.text);
				if (num < _min)
					num = _min;
				else if (num > _max)
					num = _max;
					
				if(num)
					_textField.text = "" + num;
				else
					_textField.text = "";
				 
				if (_isSelection)
					_textField.setSelection(0, 0);
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private var _needCheckTxt:Boolean = false;
		
		/**
		 * 构造
		 */
		public function C5NumTxt(textField:TextField, needCheckTxt:Boolean = true, isSelection:Boolean = true) 
		{
			_textField = textField;
			_textField.restrict = "0-9";
			_needCheckTxt = needCheckTxt;
			_isSelection = isSelection;
		}
		
		public function setValue(max:Number , min:Number):void
		{
			_max = max;
			_min = min;
			checkTxt();
		}
		
		public function selectAllText():void
		{
			_textField.setSelection(0 , _textField.text.length);
		}
		
	}

}