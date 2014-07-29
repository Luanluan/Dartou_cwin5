package cwin5.control.select 
{
	import cwin5.utils.C5Utils;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 选择改变
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")] 
	
	/**
	 * 选择组
	 * @author cwin5
	 */
	public class C5SelectGroup extends EventDispatcher
	{
		/// 选中item
		private var _selectedItem:ISelect = null;
		
		/// item列表
		private var _itemList:Array = [];
		
		/// 是否启用
		private var _enable:Boolean = false;
		
		/**
		 * 是否启用
		 */
		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void 
		{
			if (_enable == value)
				return;
			
			_enable = value;
			
			for (var i:int = 0; i < _itemList.length; i++) 
			{
				var item:ISelect = _itemList[i];
				if (item) 
				{
					item.enable = value;
				}
			}
		}
		
		private var _unselect:Boolean = false;
		
		/**
		 * 构造
		 */
		public function C5SelectGroup(unselect:Boolean = false) 
		{
			_unselect = unselect;
		}
		
		/**
		 * 添加Item
		 * @param	item
		 */
		public function addItem(item:ISelect , isSelect:Boolean = false):void
		{
			C5Utils.addElement(_itemList , item);
			item.groupCallBack = processSelect;
			
			if (isSelect)
			{
				changeItem(item , true);
			}
			item.enable = enable;
		}
		
		/**
		 * 移除item
		 * @param	item
		 */
		public function removeItem(item:ISelect):void
		{
			item.enable = false;
			C5Utils.removeElement(_itemList , item);
			item.groupCallBack = null;
			
			
			if (_selectedItem == item)
			{
				_selectedItem = null;
			}
			if (item.select)
			{
				item.select = false;
			}
			
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			if (_selectedItem)
				_selectedItem.select = false;
			_selectedItem = null;
			while (_itemList.length) 
			{
				removeItem(_itemList[0]);
				//_itemList.shift();
			}
		}
		
		/**
		 * 切换item
		 * @param	item
		 */
		public function changeItem(item:ISelect , sendEvent:Boolean = false):void
		{
			processSelect(item , sendEvent);
		}
		
		/**
		 * 根据ID切换item
		 * @param	id
		 */
		public function changeItemById(id:int , sendEvent:Boolean = false):void
		{
			processSelect(_itemList[id] , sendEvent);
		}
		
		/**
		 * 处理选择
		 * 这方法传入iselect做为call back对象
		 */
		protected function processSelect(item:ISelect, sendEvent:Boolean = true):void
		{
			if (item == _selectedItem)
			{
				if (!_unselect)
				{
					return;
				}
				item = null;
			}
			
			if (_selectedItem)
				_selectedItem.select = false;
			_selectedItem = item;
			if (item)
			{
				_selectedItem.select = true;
			}
			
			if (sendEvent)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get itemList():Array { return _itemList; }
		
		public function get selectedItem():ISelect { return _selectedItem; }
		
	}

}