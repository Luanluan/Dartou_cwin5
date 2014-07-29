package cwin5.control.list 
{
	import com.greensock.TweenLite;
	import cwin5.control.btn.C5BasicButton;
	import cwin5.control.scroll.C5ScrollBar;
	import cwin5.control.StageProxy;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author cwin5
	 */
	public class C5ScrollArea
	{
		
		private var _enable:Boolean = false;
		
		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			_scroll.enable = value;
			if (_enable)
				addEvent();
			else
				removeEvent();
		}
		
		
		private var _scroll:C5ScrollBar = null;
		private var _area:Sprite;
		private var _wheelRect:Sprite;
		private var _areaPos:Number;
		private var _glide:GlideControl;
		
		/**
		 * 构造
		 */
		public function C5ScrollArea(scroll:C5ScrollBar , area:Sprite,  wheelRect:Sprite) 
		{
			_scroll = scroll;
			_area = area;
			_areaPos = _area.y;
			_wheelRect = wheelRect;
			_area.cacheAsBitmap = true;
			_glide = new GlideControl([_wheelRect, _area], _scroll);
		}
		
		/// 添加事件
		protected function addEvent():void
		{
			_scroll.curCount = _area.height;
			_scroll.addEventListener(Event.CHANGE, onScrollChange);
			_wheelRect.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			_area.addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			
			//_wheelRect.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			//_area.addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			_glide.addEvent();
		}
		
		/// 移除事件
		protected function removeEvent():void
		{
			_scroll.removeEventListener(Event.CHANGE, onScrollChange);
			_wheelRect.removeEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			_area.removeEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			
			_glide.removeEvent();
			
			//_wheelRect.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			//_area.removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
		}
		
		private function onScrollChange(e:Event):void 
		{
			setRect(_scroll.curPos);
		}
		
		private function setRect(y:Number):void
		{
			_area.y = _areaPos - y;
			//TweenLite.to(_area , .4 , { y : _areaPos - y } );
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
			//if (!C5BasicButton.noClick && Math.abs(n) > 5)
				//C5BasicButton.noClick = true;
		//}
		
	}

}