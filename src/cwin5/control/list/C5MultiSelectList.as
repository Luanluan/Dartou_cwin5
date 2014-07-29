package cwin5.control.list 
{
	import cwin5.control.scroll.C5ScrollBar;
	import cwin5.control.select.C5MultiSelectGroup;
	import cwin5.control.select.C5SelectGroup;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 选择改变
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")] 
	
	/**
	 * 
	 * @author cwin5
	 */
	public class C5MultiSelectList extends C5List implements IEventDispatcher
	{
		private var _group:C5MultiSelectGroup;
		
		
		
		public function get maxSelect():int { return _group.maxSelect; }
		
		public function set maxSelect(value:int):void 
		{
			_group.maxSelect = value;
		}
		
		/**
		 * 构造
		 */
		public function C5MultiSelectList(scroll:C5ScrollBar , container:Sprite , itemClass:Class , wheelRect:Sprite, maxSelect:int = -1) 
		{
			super(scroll , container , itemClass, wheelRect);
			_group = new C5MultiSelectGroup(maxSelect);
		}
		
		public function get selectList():Array
		{
			return _group.selectList;
		}
		
		public function setSelectByData(data:*):void
		{
			_group.setSelect(_dataDict[data]);
		}
		
		/**
		 * 复写
		 * @param	data
		 * @param	updateScroll
		 */
		override public function addData(data:Object , updateScroll:Boolean = true):*
		{
			var item:* = super.addData(data , updateScroll);
			_group.addItem(item);
			return item;
		}
		
		/// 清除item
		override public function clearItem():void
		{
			super.clearItem();
			_group.clear();
		}
		
		override protected function addEvent():void 
		{
			super.addEvent();
			_group.addEventListener(Event.CHANGE , onChange);
			_group.enable = true;
		}
		
		override protected function removeEvent():void 
		{
			super.removeEvent();
			_group.removeEventListener(Event.CHANGE , onChange);
			_group.enable = false;
		}
		
		private function onChange(e:Event):void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		////////////////////////////////////////////////////////////////////////////////
		/// 组合实现
		private var _event:EventDispatcher = new EventDispatcher();
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _event.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _event.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _event.willTrigger(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_event.removeEventListener(type, listener, useCapture);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_event.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
	}

}