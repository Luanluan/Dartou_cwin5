package cwin5.control.list 
{
	import com.greensock.TweenLite;
	import cwin5.control.btn.C5BasicButton;
	import cwin5.control.scroll.C5ScrollBar;
	import cwin5.control.StageProxy;
	import cwin5.utils.C5Utils;
	import cwin5.utils.cache.CacheManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 列表
	 * @author cwin5
	 */
	public class C5List
	{
		private static const OFFSET:Number = 10;
		
		protected var _scroll:C5ScrollBar = null;
		public function get scroll():C5ScrollBar { return _scroll; }
		
		private var _enable:Boolean = false;
		
		private var _container:Sprite = null;
		private var _itemContainer:Sprite = null;
		
		protected var _itemList:Array = [];
		public function get itemList():Array { return _itemList; }
		
		private var _itemClass:Class = null;
		
		public function get itemClass():Class 
		{
			return _itemClass;
		}
		
		public function set itemClass(value:Class):void 
		{
			_itemClass = value;
		}
		
		
		protected var _maxHei:Number = 0;
		
		private var _containerPos:Number;
		private var _wheelRect:Sprite;
		private var _showList:Array = [];
		private var _glide:GlideControl;
		
		protected var _dataDict:Dictionary = new Dictionary();
		
		/**
		 * 构造
		 */
		public function C5List(scroll:C5ScrollBar , container:Sprite , itemClass:Class , wheelRect:Sprite) 
		{
			_scroll = scroll;
			_container = container;
			_containerPos = _container.y;
			_itemClass = itemClass;
			_wheelRect = wheelRect;
			_itemContainer = new Sprite();
			_container.addChild(_itemContainer);
			_glide = new GlideControl([_container, _wheelRect], scroll);
		}
		
		/**
		 * 添加数据
		 * @param	data
		 */
		public function addData(data:Object , updateScroll:Boolean = true):*
		{
			var obj:IC5ListItem = CacheManager.instance.getObject(_itemClass);
			obj.setData(data);
			obj.addItemEvent();
			var view:DisplayObject = obj.getView();
			updateViewY(view, obj);
			view.cacheAsBitmap = true;
			_itemList.push(obj);
			_dataDict[data] = obj;
			
			if (isNeedShow(view))
			{
				_itemContainer.addChild(view);
				_showList.push(obj);
			}
			
			if (updateScroll)
				updateScrollCount();
			
			return obj;
		}
		
		protected function updateScrollCount():void
		{
			_scroll.curCount = _maxHei;
		}
		
		protected function updateViewY(view:DisplayObject , obj:IC5ListItem):void
		{
			view.y = _maxHei;
			_maxHei += obj.height;
		}
		
		/**
		 * 设置数据
		 * @param	dataList
		 */
		public function setDataList(dataList:Array):void
		{
			clearItem();
			if (dataList != null && dataList.length > 0)
			{
				for (var i:int = 0; i < dataList.length; i++) 
				{
					addData(dataList[i] , false);
				}
			}
			updateScrollCount();
		}
		
		/// 清除item
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
			_container.y = _containerPos;
			_itemList = [];
			_showList = [];
			setRect(0);
			_scroll.setCurPos(0, false, true);
			_scroll.curCount = 0;
			_maxHei = 0;
			_glide.removeUpdate();
		}
		
		/**
		 * 是否启用
		 */
		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void 
		{
			if (_enable == value)
				return;
			
			_enable = value;
			_scroll.enable = value;
			
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		public function get glide():GlideControl 
		{
			return _glide;
		}
		
		public function get wheelRect():Sprite 
		{
			return _wheelRect;
		}
		
		/// 添加事件
		protected function addEvent():void
		{
			_scroll.addEventListener(Event.CHANGE, onScrollChange);
			_wheelRect.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			_container.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			
			//_wheelRect.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			//_container.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			_glide.addEvent();
		}
		
		/// 移除事件
		protected function removeEvent():void
		{
			_scroll.removeEventListener(Event.CHANGE, onScrollChange);
			_wheelRect.removeEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			_container.removeEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			
			//_wheelRect.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			//_container.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			_glide.removeEvent();
		}
		
		private function onScrollChange(e:Event):void 
		{
			setRect(_scroll.curPos);
		}
		
		private function setRect(y:Number):void
		{
			_container.y = _containerPos - y;
			onUpdate();
			//TweenLite.to(_container , .4 , { y: _containerPos - y , onUpdate:onUpdate } );
		}
		
		private function onUpdate():void
		{
			for (var i:int = 0; i < _itemList.length; i++) 
			{
				var item:IC5ListItem = _itemList[i];
				var view:DisplayObject = item.getView();
				var needShow:Boolean = isNeedShow(view);
				if (_showList.indexOf(item) != -1)
				{
					if (!needShow)
					{
						C5Utils.removeFromStage(view);
						C5Utils.removeElement(_showList, item);
					}
				}
				else
				{
					if (needShow)
					{
						_itemContainer.addChild(view);
						_showList.push(item);
					}
				}
			}
		}
		
		private function isNeedShow(view:DisplayObject):Boolean
		{
			var c:Number = (_containerPos - _container.y);
			//trace("containerPos:" + _containerPos , "_container.y" + _container.y , "viewHeight:" + view.height , "view.y:" + view.y);
			return view.y > c - view.height - OFFSET && view.y < c + _scroll.maxCount + view.height + OFFSET;
		}
		
		
		private function onWheel(e:MouseEvent):void 
		{
			if (e.delta < 0)
			{
				_scroll.addCurPos(.1);
			}
			else
			{
				_scroll.minCurPos(.1);
			}
		}
		
		//private var _p:Number;
		//private var _s:Number;
		//private var _isDown:Boolean;
		//
		//private function onDown(e:MouseEvent):void 
		//{
			//if (_isDown)
				//return;
			//_isDown = true;
			//StageProxy.stage.addEventListener(MouseEvent.MOUSE_MOVE , onMove);
			//StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , onUp);
			//StageProxy.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown , true);
			//_p = StageProxy.stage.mouseY;
			//_s = _scroll.curPos;
		//}
		//
		//private function onStageDown(e:MouseEvent):void 
		//{
			//e.currentTarget.removeEventListener(e.type , arguments.callee);
			//C5BasicButton.noClick = false;
		//}
		//
		//private function onUp(e:MouseEvent):void 
		//{
			//_isDown = false;
			//StageProxy.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMove);
			//StageProxy.stage.removeEventListener(MouseEvent.MOUSE_UP , onUp);
		//}
		//
		//private function onMove(e:MouseEvent):void 
		//{
			//var n:Number = StageProxy.stage.mouseY - _p;
			//_scroll.setCurPos(_s - n, true);
			//
			//if (!C5BasicButton.noClick && Math.abs(_s - _scroll.curPos) > 5)
				//C5BasicButton.noClick = true;
		//}
		
	}

}