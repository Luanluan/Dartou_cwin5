package cwin5.control.btn 
{
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	/**
	 * 文本按钮
	 * 类似html超文本链接
	 * @author ｌｕａｎｌｕａｎ
	 */
	public class TxtButton
	{
		private var _tf:TextField;
		
		private var _enable:Boolean = false;
		
		public var txtLinkFunc:Function;
		
		private var _underLine:Boolean;
		private var _text:String;
		
		/**
		 * 
		 * @param	tf	文本框
		 * @param	text	文字内容
		 * @param	underLine	是否需要下划线
		 * @param	normalColor	正常状态的RBG颜色
		 * @param	hoverColor	鼠标经过的RBG颜色
		 * @param	activeColor	激活状态的RBG颜色
		 */
		public function TxtButton(tf:TextField , text:String = "" , underLine:Boolean = false, normalColor:String = "#00C3FF" , hoverColor:String = "#cc6600" , activeColor:String = "#cc6666")
		{
			_tf = tf;
			var css:String = "a { 	color:" + normalColor + "} a:hover { color:" + hoverColor + "} a:active  { color:" + activeColor + "}";
			var style:StyleSheet = new StyleSheet();
			style.parseCSS(css);
			
			_underLine = underLine;
			this.text = text;
			_tf.styleSheet = style;
		}
		
		public function get enable():Boolean 	{		return _enable;	}
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (_enable)
				_tf.addEventListener(TextEvent.LINK , textLinkHanlder);
			else
				_tf.removeEventListener(TextEvent.LINK , textLinkHanlder);
		}
		
		private function textLinkHanlder(e:TextEvent):void 
		{
			if (txtLinkFunc != null)
				txtLinkFunc();
		}
		
		public function get text():String 	{	return _text;	}
		public function set text(value:String):void 
		{
			_text = value;
			if(_underLine)
				_tf.htmlText = "<u><a href='event:_tf'>" + _text + "</a></u>";
			else
				_tf.htmlText = "<a href='event:_tf'>" + _text + "</a>";
		}
		
		public function get underLine():Boolean 	{	return _underLine;	}
		public function set underLine(value:Boolean):void 
		{
			_underLine = value;
			this.text = _text;
		}
		
	}

}