package cwin5.control.btn
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 按钮控制
	 * 第一帧为 up
	 * 第二帧为 over
	 * 第三帧为 down
	 * 第四帧为 灰(可选是否有灰帧)
	 * @author cwin5
	 */
	public class C5Button extends C5BasicButton
	{
		////////////////////////////////////////////////////////////////////////////////
		private static const UP:int = 1;
		private static const OVER:int = 2;
		private static const DOWN:int = 3;
		private static const GRAY:int = 4;
		
		////////////////////////////////////////////////////////////////////////////////
		protected var _hasGray:Boolean = false;		// 是否有灰帧
		
		public function get hasGray():Boolean { return _hasGray; }
		public function set hasGray(value:Boolean):void 
		{
			_hasGray = value;
		}
		
		private var _isDown:Boolean = false;
		private var _isOver:Boolean = false;
		
		/**
		 * 构造
		 */
		public function C5Button(mc:MovieClip = null, hasGray:Boolean = false) 
		{
			if (mc == null)
				return;
			_hasGray = hasGray;
			setMC(mc);
		}
		
		/// 设置MC
		override protected function setMC(mc:MovieClip):void
		{
			super.setMC(mc);
			
			if (!mc)
				return;
			
			if (_hasGray)
			{
				_mc.gotoAndStop(GRAY);
			}
			else
			{
				_mc.gotoAndStop(UP);
			}
		}
		
		// 处理启用
		override protected function processEnable():void
		{
			_mc.gotoAndStop(UP);
		}
		
		// 处理非启用
		override protected function processDisable():void
		{
			_isDown = false;
			_isOver = false;
			if (_hasGray) _mc.gotoAndStop(GRAY);
			else _mc.gotoAndStop(UP);
		}
		
		// 移入
		override protected function rollOver(e:MouseEvent):void 
		{
			_isOver = true;
			_mc.gotoAndStop(OVER);
			super.rollOver(e);
		}
		
		// 移出
		override protected function rollOut(e:MouseEvent):void 
		{
			_isOver = false;
			if (!_isDown)
				_mc.gotoAndStop(UP);
			super.rollOut(e);
		}
		
		// 按下
		override protected function mouseDown(e:MouseEvent):void 
		{
			_mc.gotoAndStop(DOWN);
			_isDown = true;
			_mc.stage.addEventListener(MouseEvent.MOUSE_UP , onStageUp);
			super.mouseDown(e);
		}
		
		protected function onStageUp(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			_isDown = false;
			if (!_isOver)
			{
				if(_mc) _mc.gotoAndStop(UP);
			}
		}
		
		// 弹起
		override protected function mouseUp(e:MouseEvent):void 
		{
			_mc.gotoAndStop(OVER);
			super.mouseUp(e);
		}
	}
}