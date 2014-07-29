package cwin5.control.comboBox 
{
	
	import com.greensock.TweenLite;
	import cwin5.control.list.IC5ListItem;
	import cwin5.control.scroll.C5ScrollBar;
	import cwin5.control.StageProxy;
	import cwin5.events.C5ListEvent;
	import cwin5.utils.C5Utils;
	import cwin5.utils.cache.CacheManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author luanluan
	 */
	public class ComboBoxList extends EventDispatcher
	{
		private var _container:DisplayObjectContainer;
		private var _itemClass:Class;
		private var _wheelRect:MovieClip;
		private var _scrollBar:C5ScrollBar;
		
		private var _itemList:Array = [];
		private var _dataDic:Dictionary = new Dictionary();
		
		private var _maxHeight:Number = 0;
		
		private var _isShow:Boolean = true;
		//private var _conInitPos:Number;
		
		public function ComboBoxList(container:DisplayObjectContainer,itemClass:Class) 
		{
			_container 	= container;
			_itemClass 	= itemClass;
			//_conInitPos 	= container.y;
			hide();
		}
		
		/**
		 * 添加数据
		 * @param	data
		 */
		public function addData(value:*):void
		{
			var arr:Array;
			if (value  is Array)	arr = value;
			else					arr = [value];
				
			for (var i:int = 0; i < value.length; i++) 
			{
				var data:* = value[i];
				var item:ComboBoxItem = CacheManager.instance.getObject(_itemClass);
				item.setData(data);
				item.addItemEvent();
				updateViewY(item.getView(), item.height);
				_container.addChild(item.getView());
				_itemList.push(item);
				_dataDic[data] = item;
			}
		}
		
		/**
		 * 清除
		 */
		public function clearItem():void
		{
			for each (var item:ComboBoxItem in _itemList ) 
			{
				item.removeData();
				item.removeItemEvent();
				CacheManager.instance.delObject(item);
				C5Utils.removeElement(_itemList, item);
			}
			_itemList = [];
			_dataDic = new Dictionary();
			C5Utils.removeAllChild(_container);
			_maxHeight = 0;
		}
		
		/**
		 * 显示
		 */
		public function show():void
		{
			if (_isShow) return;
			
			_container.visible = true;
			TweenLite.to(_container, .3, { alpha : 1 , onComplete:showComplete } );
			addEvent();
		}
		
		/**
		 * 隐藏
		 */
		public function hide():void
		{
			if (!_isShow)	return;
			
			removeEvent();
			TweenLite.to(_container, .3, { alpha:0 , onComplete:hideComplete } );
		}
		
		private function showComplete():void
		{
			_isShow = true;
		}
		
		private function hideComplete():void
		{
			_container.visible = _isShow = false;
		}
		
		private function addEvent():void
		{
			for each (var item:ComboBoxItem in _itemList ) 
			{
				item.addEventListener(C5ListEvent.ITEM_SELECTED, onItemSelected);
			}
			
			StageProxy.stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function removeEvent():void
		{
			for each (var item:ComboBoxItem in _itemList ) 
			{
				item.removeEventListener(C5ListEvent.ITEM_SELECTED, onItemSelected);
			}
			
			StageProxy.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		
		private function onStageClick(e:MouseEvent):void 
		{
			if (StageProxy.stage.focus != _container)
				hide();
		}
		
		private function onItemSelected(e:C5ListEvent):void 
		{
			dispatchEvent(e);
			hide();
		}
		
		private function updateViewY(view:DisplayObject, height:Number):void
		{
			view.y = _maxHeight;
			_maxHeight += height;
		}
		
		public function get isShow():Boolean 
		{
			return _isShow;
		}
		
	}

}