package cwin5.control 
{
	import com.greensock.TweenLite;
	import cwin5.utils.C5EnterFrame;
	import cwin5.utils.C5Utils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 滚屏选择
	 * @author cwin5
	 */
	public class ScrollSelect
	{
		
		private var _container:Sprite;
		private var _rect:Sprite;
		
		private var _enable:Boolean = false;
		private var _itemList:Array;
		
		/**
		 * 设置select id
		 */
		private var _selectID:int = 0;
		public function get selectID():int { return _selectID; }
		public function set selectID(value:int):void 
		{
			if (_selectID == value)
				return;
			
			_selectID = value;
			_targetPos = -_itemList[_selectID].view.y;
			roll();
		}
		
		/**
		 * 获取选中item
		 */
		public function get selectItem():IScrollSelectItem
		{
			return _itemList[_selectID];
		}
		
		/**
		 * 数量
		 */
		public function get itemCount():int
		{
			if (_itemList)
				return _itemList.length;
			return 0;
		}
		
		/**
		 * 构造
		 */
		public function ScrollSelect(container:Sprite, rect:Sprite) 
		{
			_container = container;
			_rect = rect;
			_itemList = [];
		}
		
		/**
		 * 是否启用
		 */
		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			
			if (_enable)
			{
				addEvent();
			}
			else
			{
				removeEvent();
			}
		}
		
		/**
		 * 感应区
		 */
		public function get rect():Sprite { return _rect; }
		
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		/**
		 * 添加Item
		 * @param	item
		 */
		public function addItem(item:IScrollSelectItem):void
		{
			_itemList.push(item);
			
			var ty:Number = 0;
			
			if (_itemList.length > 1)			// 计算位置
			{
				var prevItem:IScrollSelectItem = _itemList[_itemList.length - 2];
				ty = prevItem.view.y + (prevItem.height + item.height) / 2;
			}
			
			item.view.y = ty;
			
			_container.addChild(item.view);
		}
		
		/**
		 * 清除
		 */
		public function clear():void
		{
			_container.y = 0;
			_selectID = 0;
			while (_itemList.length)
			{
				_itemList[0].cache();
				C5Utils.removeFromStage(_itemList[0].view);
				_itemList.shift();
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		/// 添加事件
		private function addEvent():void
		{
			_rect.addEventListener(MouseEvent.MOUSE_DOWN , onRectDown);
			_rect.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheel);
		}
		
		/// 移除事件
		private function removeEvent():void
		{
			_rect.removeEventListener(MouseEvent.MOUSE_DOWN , onRectDown);
			_rect.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onRectMove);
			_rect.stage.removeEventListener(MouseEvent.MOUSE_UP , onRectMouseUp);
			_rect.removeEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheel);
			C5EnterFrame.removeFunction(updatePos);
		}
		
		/// wheel
		private function onMouseWheel(e:MouseEvent):void 
		{
			var index:int = _selectID;
			
			if (e.delta > 0)
			{
				index--;
				if (index < 0)
					return;
			}
			else
			{
				index++;
				if (index >= _itemList.length)
					return;
			}
			
			selectID = index;
		}
		
		/// rect down
		private function onRectDown(e:MouseEvent):void 
		{
			_rect.stage.addEventListener(MouseEvent.MOUSE_MOVE , onRectMove);
			_rect.stage.addEventListener(MouseEvent.MOUSE_UP , onRectMouseUp);
			
			removeRollTween();
			_startRollPos = _rect.mouseY;
			_containerPos = _container.y;
			updatePos();
			C5EnterFrame.addFunction(updatePos);
		}
		
		/// mouse up
		private function onRectMouseUp(e:MouseEvent):void 
		{
			_rect.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onRectMove);
			_rect.stage.removeEventListener(MouseEvent.MOUSE_UP , onRectMouseUp);
			C5EnterFrame.removeFunction(updatePos);
			checkRoll();
		}
		
		/// rect mouse move
		private function onRectMove(e:MouseEvent):void 
		{
			var pos:Number = (_rect.mouseY - _startRollPos) * 2;
			
			_container.y = _containerPos - pos;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private var _startRollPos:Number = 0;		// 开始坐标
		private var _containerPos:Number = 0;		// 容易开始坐标
		
		private var _prevPos:Number = 0;	/// 上一次记录坐标
		
		
		private function updatePos():void
		{
			_prevPos = _rect.mouseY;
		}
		
		private function checkRoll():void
		{
			var ny:Number = _rect.mouseY - _prevPos;
			
			ny *= 10;	
			_targetPos = _container.y - ny;
				// 乘以一个系数
			
			var item:IScrollSelectItem = _itemList[_itemList.length - 1];
			if (_targetPos < -item.view.y)				// 小于0
			{
				_targetPos = -item.view.y;
				_selectID = _itemList.length - 1;
			}
			else
			{
				item = _itemList[0];
				if (_targetPos > 0)			// 大于最大值
				{
					_targetPos = 0;
					_selectID = 0;
				}
				else
				{
					for (var i:int = 0; i < _itemList.length; i++) 
					{
						item = _itemList[i];
						if (Math.abs(-_targetPos - item.view.y) <= item.height / 2)
						{
							_targetPos = -item.view.y;
							_selectID = i;
							break;
						}
					}
				}
			}
			
			roll();
		}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		private var _targetPos:Number;
		private var _rollTween:TweenLite;
		
		private function roll():void
		{
			_rollTween = TweenLite.to(_container, .3 , { y:_targetPos , onComplete:removeRollTween } );
		}
		
		private function removeRollTween():void
		{
			if (_rollTween)
			{
				_rollTween.kill();
				_rollTween = null;
			}
		}
		
	}

}