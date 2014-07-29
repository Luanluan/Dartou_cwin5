package cwin5.control.comboBox 
{
	
	import cwin5.control.btn.C5Button;
	import cwin5.control.list.IC5ListItem;
	import cwin5.events.C5ListEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author luanluan
	 */
	public class ComboBoxItem extends C5Button implements IC5ListItem
	{
		private var _event:EventDispatcher = new EventDispatcher();
		
		private var _data:*;
		
		protected	var _view:MovieClip;
		
		/**
		 * 构造
		 */
		public function ComboBoxItem() 
		{
			super(_view);
		}
		
		
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			_event.dispatchEvent(new C5ListEvent(C5ListEvent.ITEM_SELECTED, _data));
		}
		
		/* INTERFACE cwin5.control.list.IC5ListItem */
		
		public function setData(data:*):void 
		{
			_data = data;
			enable = true;
		}
		
		public function removeData():void 
		{
			_data = null;
			enable = false;
		}
		
		public function getView():DisplayObject 
		{
			return _view;
		}
		
		public function addItemEvent():void 
		{
			
		}
		
		public function removeItemEvent():void 
		{
			
		}
		
		public function get height():Number 
		{
			return _view.height;
		}
		
		public function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			_event.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void
		{
			_event.removeEventListener(type, listener, useCapture);
		}
		
	}

}