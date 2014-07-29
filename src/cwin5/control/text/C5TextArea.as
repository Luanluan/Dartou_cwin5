package cwin5.control.text 
{
	import cwin5.control.scroll.C5ScrollBar;
	import cwin5.control.StageProxy;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * 文本区
	 * @author cwin5
	 */
	public class C5TextArea
	{
		
		private var _scroll:C5ScrollBar;
		private var _textField:TextField;
		private var _enable:Boolean = false;
		private var _lineCount:int = 0;
		private var _maxLine:int = 0;
		
		
		/**
		 * 构造
		 */
		public function C5TextArea(scroll:C5ScrollBar , textField:TextField , lineCount:int, maxLine:int = 0) 
		{
			_scroll = scroll;
			_textField = textField;
			_lineCount = lineCount;
			_maxLine = maxLine;
		}
		
		public function get text():String	{ return _textField.htmlText; }
		public function set text(value:String):void
		{
			_textField.htmlText = value;
			
			update(value);
		}
		
		private function update(value:String = ""):void
		{
			if (_maxLine > 0)
			{
				if (_textField.numLines > _maxLine)
				{
					value = "";
					for (var i:int = 0; i < _maxLine ; i++) 
					{
						var lines:Number = _textField.numLines - i - 1;
						value = _textField.getLineText(lines) + value;
					}
					_textField.text = value;
				}
			}
			_scroll.setPercent(1);
			_scroll.curCount = _textField.maxScrollV > 1 ? _lineCount + _textField.maxScrollV - 1: 1;
			_textField.scrollV  = _textField.maxScrollV;
		}
		
		/**
		 * 是否启用
		 */
		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void 
		{
			if (_enable == value)
				return;
				
			_enable = value;
			_scroll.enable = value;
			
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		/// 添加事件
		protected function addEvent():void
		{
			_scroll.addEventListener(Event.CHANGE, onScrollChange);
			_textField.addEventListener(Event.SCROLL , onTextScroll);
			_scroll.view.addEventListener(MouseEvent.MOUSE_DOWN , onScrollDown);
			if (_textField.type == TextFieldType.INPUT)
				_textField.addEventListener(Event.CHANGE , onTextChange);
		}
		
		/// 移除事件
		protected function removeEvent():void
		{
			_scroll.removeEventListener(Event.CHANGE, onScrollChange);
			_textField.removeEventListener(Event.SCROLL , onTextScroll);
			_scroll.view.removeEventListener(MouseEvent.MOUSE_DOWN , onScrollDown);
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			_textField.removeEventListener(Event.CHANGE , onTextChange);
		}
		
		private function onTextChange(e:Event):void 
		{
			update();
		}
		
		/// 滚动条位置改变
		private function onScrollChange(e:Event):void 
		{
			_textField.scrollV = _scroll.percent * (_textField.maxScrollV - 1) + 1;
		}
		
		/// 文本滚动
		private function onTextScroll(e:Event):void 
		{
			if (_down)
				return;
			_scroll.setCurPos(_textField.scrollV - 1);
		}
		
		private var _down:Boolean = false;	/// 是否按下
		
		/// 鼠标挥刀 下
		private function onScrollDown(e:MouseEvent):void 
		{
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			_down = true;
		}
		
		/// 鼠标释放
		private function onMouseUp(e:MouseEvent):void 
		{
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			_down = false;
		}
		
	}

}