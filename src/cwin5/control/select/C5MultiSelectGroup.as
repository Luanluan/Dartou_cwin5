package cwin5.control.select 
{
	import cwin5.control.select.ISelect;
	import cwin5.utils.C5Utils;
	import flash.events.Event;
	
	/**
	 * 
	 * @author cwin5
	 */
	public class C5MultiSelectGroup extends C5SelectGroup
	{
		
		private var _selectList:Array = [];
		
		public function get selectList():Array { return _selectList; }
		
		private var _maxSelect:int = 0;
		
		public function get maxSelect():int { return _maxSelect; }
		
		public function set maxSelect(value:int):void 
		{
			_maxSelect = value;
		}
		
		/**
		 * 构造
		 */
		public function C5MultiSelectGroup(maxSelect:int = -1) 
		{
			_maxSelect = maxSelect;
			super();
		}
		
		override public function clear():void 
		{
			super.clear();
			_selectList = [];
		}
		
		public function setSelect(item:ISelect):void
		{
			if (item && !item.select)
			{
				item.select = true;
				C5Utils.addElement(_selectList, item);
			}
		}
		
		override public function removeItem(item:ISelect):void 
		{
			if (item.select)
			{
				C5Utils.removeElement(_selectList , item);
			}
			super.removeItem(item);
		}
		
		override protected function processSelect(item:ISelect, sendEvent:Boolean = true):void
		{
			if (item.select)
			{
				item.select = false;
				C5Utils.removeElement(_selectList, item);
			}
			else
			{
				if (_maxSelect >= 0 && _selectList.length >= _maxSelect)
				return;
				item.select = true;
				C5Utils.addElement(_selectList, item);
			}
			if (sendEvent)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
	}

}