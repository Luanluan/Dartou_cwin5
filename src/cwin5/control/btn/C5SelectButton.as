package cwin5.control.btn
{
	import cwin5.control.select.ISelect;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 选择按钮
	 * 第一帧为 非选择up
	 * 第二帧为 非选择over
	 * 第三帧为 非选择down
	 * 第四帧为 选择up
	 * 第五帧为 选择over
	 * 第六帧为 选择down
	 * @author cwin5
	 */
	public class C5SelectButton extends C5BasicButton implements ISelect
	{
		////////////////////////////////////////////////////////////////////////////////
		/**
		 * 非选择偏移
		 */
		private static const NO_SELECT_OFFSET:int = 0;
		
		/**
		 * 选择偏移
		 */
		private static const SELECT_OFFSET:int = 3;
		
		private static const UP:int = 1;
		private static const OVER:int = 2;
		private static const DOWN:int = 3;
		
		////////////////////////////////////////////////////////////////////////////////
		
		private var _select:Boolean = false;			// 是否选择
		private var _offset:Number = 0;					// 偏移
		private var _callBack:Function = null;				// 回调
		
		public function set callBack(value:Function):void
		{
			if (_callBack != null)
			{
				throw new Error("CallBack isn't Null!");
			}
			_callBack = value;
		}
		
		/**
		 * 构造
		 */
		public function C5SelectButton(mc:MovieClip) 
		{
			setMC(mc);
			mc.gotoAndStop(1);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		// 处理启用
		override protected function processEnable():void
		{
			_mc.gotoAndStop(UP + _offset);
		}
		
		// 处理非启用
		override protected function processDisable():void
		{
			_mc.gotoAndStop(UP + _offset);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		// 单击
		override protected function onClick(e:MouseEvent):void 
		{
			if (_callBack != null)
				_callBack(this);
			else
			{
				_select = !_select;
				processSelect(OVER);
			}
			super.onClick(e);
		}
		
		// 处理选择改变
		private function processSelect(type:int):void
		{
			if (_select)
				_offset = SELECT_OFFSET;
			else
				_offset = NO_SELECT_OFFSET;
			
			_mc.gotoAndStop(type + _offset);
		}
		
		// 移入
		override protected function rollOver(e:MouseEvent):void 
		{
			_mc.gotoAndStop(OVER + _offset);
			super.rollOver(e);
		}
		
		// 移出
		override protected function rollOut(e:MouseEvent):void 
		{
			_mc.gotoAndStop(UP + _offset);
			super.rollOut(e);
		}
		
		// 按下
		override protected function mouseDown(e:MouseEvent):void 
		{
			_mc.gotoAndStop(DOWN + _offset);
			super.mouseDown(e);
		}
		
		// 弹起
		override protected function mouseUp(e:MouseEvent):void 
		{
			_mc.gotoAndStop(OVER + _offset);
			super.mouseUp(e);
		}
		
		/* INTERFACE cwin5.control.select.ISelect */
		
		public function set groupCallBack(value:Function):void
		{
			
		}
		
		public function setCallBack(value:Function, ...params):void
		{
			
		}
		
		
		/**
		 * 是否选择
		 */
		public function get select():Boolean { return _select; }
		public function set select(value:Boolean):void 
		{
			if (_select == value)
				return;
			_select = value;
			processSelect(_mc.currentFrame % 3);
		}
		
	}
	
}