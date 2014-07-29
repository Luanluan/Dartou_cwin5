package cwin5.control.list 
{
	import cwin5.control.btn.C5BasicButton;
	import cwin5.control.scroll.C5ScrollBar;
	import cwin5.control.StageProxy;
	import cwin5.utils.C5EnterFrame;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author cwin5
	 */
	public class GlideControl 
	{
		private var _objList:Array;
		private var _scroll:C5ScrollBar = null;
		private var _p:Number;
		private var _s:Number;
		
		private var _speed:Number = 0;
		
		public function GlideControl(objList:Array, scroll:C5ScrollBar) 
		{
			_objList = objList;
			_scroll = scroll;
		}
		
		
		public function addEvent():void
		{
			for (var i:int = 0; i < _objList.length; i++) 
			{
				_objList[i].addEventListener(MouseEvent.MOUSE_DOWN , onDown);
			}
		}
		
		public function removeEvent():void
		{
			removeUpdate();
			for (var i:int = 0; i < _objList.length; i++) 
			{
				_objList[i].removeEventListener(MouseEvent.MOUSE_DOWN , onDown);
			}
		}
		
		private function onDown(e:MouseEvent):void 
		{
			removeUpdate();
			_scroll.killCheckPos();
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_MOVE , onMove);
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_UP , onUp);
			StageProxy.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown , true);
			_s = _p = StageProxy.stage.mouseY;
		}
		
		private function onStageDown(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			C5BasicButton.noClick = false;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMove);
			StageProxy.stage.removeEventListener(MouseEvent.MOUSE_UP , onUp);
			_scroll.checkPos(MAX_DISTANCE);
			if (Math.abs(_speed) > 5)
			{
				C5EnterFrame.addFunction(update);
			}
		}
		
		private function onMove(e:MouseEvent):void 
		{
			var n:Number = _p - StageProxy.stage.mouseY;
			_speed = n;
			_scroll.setCurPos(_scroll.curPos + _speed, true, false , MAX_DISTANCE);
			//trace(_speed);
			//if (_speed > MAX_SPEED)
				//_speed = MAX_SPEED;
			
			
			_p = StageProxy.stage.mouseY;
			
			
			if (!C5BasicButton.noClick && Math.abs(_s - StageProxy.stage.mouseY) > 5)
			{
				C5BasicButton.noClick = true;
			}
		}
		
		//private static const MAX_SPEED:Number = 50;
		
		private function update():void 
		{
			//trace(_speed);
			var flag:Boolean = _scroll.setCurPos(_scroll.curPos + _speed, true, false , MAX_DISTANCE);
			//_speed -= _speed * .05;
			_speed += (_speed > 0? -1:1)*.2;
			if (flag || Math.abs(_speed) <= 2)
			{
				removeUpdate();
			}
		}
		
		public function removeUpdate():void 
		{
			_speed = 0;
			_scroll.checkPos(MAX_DISTANCE);
			C5EnterFrame.removeFunction(update);
		}
		
		private static const MAX_DISTANCE:Number = 30;
		
	}

}