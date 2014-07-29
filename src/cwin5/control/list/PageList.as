package cwin5.control.list 
{
	import com.adobe.net.URIEncodingBitmap;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import cwin5.control.EventCenter;
	import cwin5.utils.C5Utils;
	import cwin5.utils.cache.CacheManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Jayden
	 */
	public class PageList extends EventDispatcher
	{
		
		/**
		 * 构造
		 */
		protected static const OFFSET:Number = 10;
		
		protected var viewWid:Number;
		
		protected var _container:Sprite = null;
		private var _itemContainer:Sprite = null;
		
		protected var _itemList:Array = [];
		public function get itemList():Array { return _itemList; }
		private var _showList:Array = [];
		
		protected var maxHei:Number = 0;
		protected var curWid:Number = 0;
		protected var curHei:Number = 0;
		

		protected var _containerPosX:Number;
		protected var _containerPosY:Number;
		
		private var _itemClass:Class;
		
		protected var _maxPage:int = 1;
		protected var _curPage:int = 1;
		
		protected var itemGap:Number = 0;
		
		private var _dataDict:Dictionary = new Dictionary();
		
		
		 /**
		  * @param	maxHei			最长高度
		  * @param	wid				每页宽度
		  * @param  gap			item间隔
		  */
		public function PageList(container:Sprite, itemClass:Class, maxHei:Number, wid:Number, gap:Number = 0)
		{
			_container = container;
			_itemClass = itemClass;
			_itemContainer = new Sprite();
			_container.addChild(_itemContainer);
			
			_containerPosX = _container.x;
			_containerPosY = _container.y;
			this.maxHei = maxHei;
			viewWid = wid;
			itemGap = gap;
			
		}
		
		
		/**
		 * 添加数据
		 * @param	data
		 * @return
		 */
		public function addData(data:Object):*
		{
			var obj:IPageListItem = CacheManager.instance.getObject(_itemClass);
			obj.setData(data);
			obj.addItemEvent();
			_itemView = obj.getView();
			updateViewPos(_itemView, obj);
			_itemView.cacheAsBitmap = true;
			_itemList.push(obj); 
			_dataDict[data] = obj;
			
			if (isNeedShow(_itemView))
			{
				_itemContainer.addChild(_itemView);
				_showList.push(obj);
			}
			dispatchEvent(new Event(Event.CHANGE));
			return obj;
		}
		
		/**
		 * 设置数据
		 * @param	dataList
		 */
		
		public function setDataList(dataList:*):void
		{
			clearItem();
			if (dataList != null && dataList.length > 0)
			{
				for (var i:int = 0; i < dataList.length; i++) 
				{
					addData(dataList[i]);
				}
			}
		}
		
		public function clearItem():void
		{
			if (_itemList.length == 0)
				return;
				
			for (var i:int = 0; i < _itemList.length; i++) 
			{
				_itemList[i].removeItemEvent();
				_itemList[i].removeData();
				CacheManager.instance.delObject(_itemList[i]);
			}
		
			_dataDict = new Dictionary();
			C5Utils.removeAllChild(_itemContainer);
			_container.y = _containerPosY;
			_container.x = _containerPosX;
			_itemList = [];
			_showList = [];
			curHei = curWid = 0;
			_maxPage = _curPage = 1;
		}
		
		private var _item:IPageListItem;
		private var _itemView:DisplayObject;
		private var _needShow:Boolean;
		
		public function onUpdate():void
		{
			for (var i:int = 0; i < _itemList.length; i++) 
			{
				_item = _itemList[i];
				_itemView = _item.getView();
				_needShow = isNeedShow(_item.getView());
				if (_showList.indexOf(_item) != 1)
				{
					if (!_needShow)
					{
						C5Utils.removeFromStage(_itemView);
						C5Utils.removeElement(_showList, _item);
					}
					if (_needShow) 
					{
						_itemContainer.addChild(_itemView);
						_showList.push(_item);
					}
				}
				else 
				{
					if (_needShow) 
					{
						_itemContainer.addChild(_itemView);
						_showList.push(_item);
					}
				}
			}
			//trace(_showList.length);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function isNeedShow(item:DisplayObject):Boolean
		{
			var c:Number = (_containerPosX - _container.x);
			//var flag:Boolean = view.x > c - view.width - OFFSET && view.x < c + maxHei + OFFSET;
			//trace(view.x > c - view.width - OFFSET && view.x < c + maxHei + OFFSET);
			//return flag;
			
			var flag:Boolean = item.x < viewWid + c && item.x > c - OFFSET;
			return flag;
		
		}
		
		private var _isNextPage:Boolean = false;
		
		private var temp:Number;
		protected function updateViewPos(view:DisplayObject,obj:IPageListItem):void
		{
			view.y = curHei;
			view.x = curWid;
			curHei += obj.height
			
			//if (_isNextPage)
			//{
				//_isNextPage = false;
				//_maxPage ++;
			//}
			
			if (curHei > maxHei - OFFSET)
			{
				curWid += obj.width + itemGap;
				curHei = 0;
			}
			//修正满一页新建一空白的情况
			if (curWid / viewWid == temp)
				_maxPage = int(curWid / viewWid) + 1;
			else
				_maxPage = int(curWid / viewWid);
			//trace(curWid / viewWid, curWid % viewWid, curWid, viewWid);
			temp = curWid / viewWid;
			
			if (_maxPage < 1)
				_maxPage = 1;
		}
	
		public function get maxPage():int { return _maxPage; }
		
		public function get curPage():int { return _curPage; }
		
		public function set curPage(value:int):void 
		{
			_curPage = value;
			
			if (_curPage > _maxPage)
				_curPage = _maxPage;
			if (_curPage < 1)
				_curPage = 1;
			pageChange(_curPage);
			
		}
		
		protected function pageChange(page:int):void
		{
			var pos:Number;
			if (_maxPage <= 1)
				pos = _containerPosX;
			else
				pos = _containerPosX - ((page-1) * (viewWid + itemGap));
			if (!(pos is Number))
				pos = _containerPosX;
			TweenLite.to(_container, .3, { x:pos, onUpdate:onUpdate, ease:Linear.easeNone} );
			dispatchEvent(new Event(Event.CHANGE));
		}
	}

}