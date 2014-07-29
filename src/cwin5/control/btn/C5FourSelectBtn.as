package cwin5.control.btn 
{
	import cwin5.control.select.ISelect;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 四帧选中
	 * @author cwin5
	 */
	public class C5FourSelectBtn extends C5Button implements ISelect
	{
		
		private var _select:Boolean = false;			// 是否选择

		
		
		public function get select():Boolean { return _select; }
		public function set select(value:Boolean):void
		{
			_select = value;
			
			if (_select)
				mc.gotoAndStop(4);
			else
				mc.gotoAndStop(1);
		}
		
		private var _autoChange:Boolean = false;		//  是否自动转换选择, 如果有groupcallback对象时，此属性失效
		
		/**
		 * 构造
		 */
		public function C5FourSelectBtn(mc:MovieClip , autoChange:Boolean = true) 
		{
			super(mc , false);
			_autoChange = autoChange;
		}
		
		/**
		 * 点击
		 * @param	e
		 */
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (_groupCallBack != null)
			{
				_groupCallBack(this);
			}
			
			else
			{
				if (_autoChange)
					select = !_select;
				
				if (_select)
					mc.gotoAndStop(4);
				else
					mc.gotoAndStop(2);
				
				if (_callBack != null)
					_callBack.apply(null , _callBackParams);
			}
		}
		
		/**
		 * 处理启用
		 */
		override protected function processEnable():void
		{
			super.processEnable();
			
			if (select)
				mc.gotoAndStop(4);
		}
		
		/**
		 * 移入
		 * @param	e
		 */
		override protected function rollOver(e:MouseEvent):void 
		{
			
			super.rollOver(e);
			
			if (select)
				mc.gotoAndStop(4);
		
		}
		
		/**
		 * 移出
		 * @param	e
		 */
		override protected function rollOut(e:MouseEvent):void 
		{
			if(_enable)
				super.rollOut(e);
			
			if (select)
				mc.gotoAndStop(4);	
		}
		
		/**
		 * 按下
		 * @param	e
		 */
		override protected function mouseDown(e:MouseEvent):void 
		{
			super.mouseDown(e);
			
			if (select)
				mc.gotoAndStop(4);
		}
		
		/**
		 * 弹起
		 * @param	e
		 */
		override protected function mouseUp(e:MouseEvent):void 
		{
			super.mouseUp(e);
			
			if (select)
				mc.gotoAndStop(4);
		}
		
		
		private var _callBack:Function = null;				// 回调
		private var _callBackParams:Array;
		/**
		 * 设置回调
		 */
		public function setCallBack(value:Function , ...params):void
		{
			_callBack = value;
			_callBackParams = params;
		}
		
		private var _groupCallBack:Function = null;
		
		/**
		 * 设置回调
		 */
		public function set groupCallBack(value:Function):void
		{
			_groupCallBack = value;
		}
		
		
		override protected function onStageUp(e:MouseEvent):void 
		{
			super.onStageUp(e);
			if (select)
				mc.gotoAndStop(4);
		}
		
		

		
		
		

		
	}

}