package cwin5.control.text 
{
	import cwin5.control.StageProxy;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	/**
	 * 焦点管理
	 * @author cwin5
	 */
	public class C5FocusText
	{
		
		private var _enable:Boolean = false;
		
		public function get enable():Boolean { return _enable; }
		
		public function set enable(value:Boolean):void 
		{
			if (_enable == value)
				return;
			_enable = value;
			
			if (_enable)
			{	
				_textField.addEventListener(FocusEvent.FOCUS_IN , onFocusIn);
				_textField.addEventListener(FocusEvent.FOCUS_OUT , onFocusOut);
				_textField.addEventListener(TextEvent.TEXT_INPUT , onInput);
				if (_textField.text == "")
					_textField.text = _text;
			}
			else
			{
				_textField.removeEventListener(FocusEvent.FOCUS_IN , onFocusIn);
				_textField.removeEventListener(FocusEvent.FOCUS_OUT , onFocusOut);
				_textField.removeEventListener(TextEvent.TEXT_INPUT , onInput);
			}
		}
		
		private function onFocusIn(e:FocusEvent):void 
		{
			if (_textField.text == _text)
				_textField.text = "";
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			if (_textField.text == "")
				_textField.text = _text;
		}
		
		private var _textField:TextField;
		private var _text:String;
		
		public function get text():String { return _text; }
		public function set text(value:String):void 
		{
			_text = value;
			
			_textField.text = _text;
		}
		
		/**
		 * 构造
		 */
		public function C5FocusText(textField:TextField , text:String = "" , maxChar:int = 0) 
		{
			_textField = textField;
			_text = text;
			_maxChar = maxChar;
		}
		
		private var _maxChar:int;
		
		private function onInput(e:TextEvent):void 
		{
			if (_maxChar > 0)
			{
				if (_textField.length > _maxChar)
					e.preventDefault();
			}
		}
		
	}

}