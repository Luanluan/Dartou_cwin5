package cwin5.control.comboBox 
{
	
	import cwin5.control.btn.C5Button;
	import cwin5.events.C5ListEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 
	 * @author luanluan
	 */
	public class C5ComboBox extends EventDispatcher
	{
		
		private var _list:ComboBoxList;
		private var _showBtn:C5Button;
		private var _showTxt:TextField;
		private var _defaultText:String;
		
		private var _enable:Boolean = false;
		
		
		/**
		 * 构造
		 */
		public function C5ComboBox(showTxt:TextField, showBtn:MovieClip, list:ComboBoxList,defaultText:String = "请选择") 
		{
			_showBtn 					= new C5Button(showBtn);
			_showBtn.clickFunc 	= onShowBtnClick;
			
			_showTxt 					= showTxt;
			_showTxt.text 				= defaultText;
			
			_list								= list;
			
			_defaultText 				= defaultText;
		}
		
		/**
		 * 添加数据
		 * @param	value
		 */
		public function addData(value:*):void
		{
			_list.addData(value);
		}
		
		/**
		 * 清除数据
		 */
		public function clearData():void
		{
			_showTxt.text = _defaultText;
			_list.clearItem();
		}
		
		/**
		 * 隐藏选项
		 */
		public function hideList():void
		{
			_list.hide();
		}
		
		private function onShowBtnClick(e:MouseEvent):void
		{
			if (_list.isShow)
				_list.hide();
			else
				_list.show();
		}
		
		private function addEvent():void
		{
			_list.addEventListener(C5ListEvent.ITEM_SELECTED, onItemSlected);
			_showTxt.addEventListener(MouseEvent.CLICK , onShowBtnClick);
		}
		
		private function removeEvent():void
		{
			_list.removeEventListener(C5ListEvent.ITEM_SELECTED, onItemSlected);
			_showTxt.removeEventListener(MouseEvent.CLICK , onShowBtnClick);
		}
		
		private function onItemSlected(e:C5ListEvent):void 
		{
			_showTxt.text = String(e.param);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			if (value == _enable)
				return;
			_enable = value;
			
			_showBtn.enable = _enable;
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		public function get value():String
		{
			var result:String = _showTxt.text;
			if (result == _defaultText || !result.length )
				result = null;
			return result;
		}
		
		public function set value(str:String):void
		{
			_showTxt.text = str;
		}
		
		public function get defaultText():String 
		{
			return _defaultText;
		}
		
		public function set defaultText(value:String):void 
		{
			_defaultText = value;
		}
		
	}

}