package cwin5.control 
{
	import cwin5.utils.C5EnterFrame;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.Dictionary
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * 文本框滚动
	 */
	public class C5RollText extends EventDispatcher
	{
		private static var textFieldList:Dictionary = new Dictionary(true);
		private static var tex:TextField = new TextField();
		private static var _count:int = 0;
		
		// 是否需要滚动
		private static function needScroll(textItem:TextField):Boolean
		{
			var t_width:Number = textItem.width;
			textItem.autoSize = "left";
			
			if (t_width < textItem.width)
			{
				textItem.width = t_width;
				textItem.autoSize = "none";
				return true; 
			}
			else if (t_width == textItem.width)
			{
				textItem.width = t_width;
				textItem.autoSize = textFieldList[textItem];
				return false;
			}
			else 
			{   
				textItem.width = t_width;
				textItem.autoSize = textFieldList[textItem];
				return false;
			}
		}
		
		// 格式化文本区
		private static function formatText(textItem:TextField):void
		{
			var strText:String = textItem.htmlText;
			var nWidth:int = textItem.width;
			textItem.autoSize = "left";
			
			var nNewWidth:int = textItem.width;
			
			var blank:String = "　";
			var newBlank:String = "";
			for (var i:int = 0; textItem.width < nNewWidth + nWidth; ++i )
			{
				textItem.appendText(blank);
				newBlank += blank;
			}
			
			tex.autoSize = "left";
			tex.text = "";
			for (i = 0; tex.width < nWidth; ++i )
			{
				tex.appendText(blank);
			}			
			
			textItem.autoSize = "none";
			textItem.htmlText = tex.text + textItem.htmlText;
			textItem.width = nWidth;
		}
		
		// 更新
		private static function update():void
		{
			for ( var obj:Object in textFieldList)
			{
				var textItem:TextField = obj as TextField;
				textItem.scrollH = textItem.scrollH + 1;
				if (textItem.scrollH >= textItem.maxScrollH - 1)
				{  
					textItem.scrollH = 1;
				}
			}
		}
		
		/**
		 * 添加
		 * @param	textItem
		 */
		public static function addTextField(textItem:TextField):void
		{
			if (textFieldList[textItem] != null)
			{   
				removeTextField(textItem);
			}
			
			textFieldList[textItem] = textItem.autoSize;
			
			if (needScroll(textItem))
			{
				_count++;
				if (_count == 1)
				{
					C5EnterFrame.addFunction(update);
				}
				formatText(textItem);
			}
			else
			{
				delete textFieldList[textItem];
			}
		}
		
		/**
		 * 移除
		 * @param	value
		 */
		public static function removeTextField(value:TextField):void
		{
			if (textFieldList[value] != null)
			{	
				_count--;
				value.autoSize = textFieldList[value];
				delete textFieldList[value];
				
				if (_count <= 0)
				{
					C5EnterFrame.removeFunction(update);
				}
			}			
		}
	}
	
}