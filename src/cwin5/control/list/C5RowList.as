package cwin5.control.list 
{
	import cwin5.control.list.IC5ListItem;
	import cwin5.control.scroll.C5ScrollBar;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author cwin5
	 */
	public class C5RowList extends C5List
	{
		private var _row:int;
		private var _space:Number;
		
		/**
		 * 构造
		 */
		public function C5RowList(scroll:C5ScrollBar , container:Sprite , itemClass:Class , wheelRect:Sprite, row:int , space:Number) 
		{
			super(scroll, container , itemClass , wheelRect);
			_row = row;
			_space = space;
		}
		
		override protected function updateViewY(view:DisplayObject, obj:IC5ListItem):void 
		{
			view.y = _maxHei;
			var i:int = _itemList.length % _row;
			if (i)
			{
				view.x = i * _space;
			}
			else
			{
				view.x = 0;
			}
			if (i == _row - 1)
			{
				_maxHei += obj.height;
			}
			//trace(_maxHei , _itemList.length , _row , view.x , view.y , i);
		}
		
		override protected function updateScrollCount():void 
		{
			if (_itemList.length % _row)
				_scroll.curCount = _maxHei + _itemList[_itemList.length - 1].height;
			else
				super.updateScrollCount();
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function set row(value:int):void 
		{
			_row = value;
		}
		
	}

}