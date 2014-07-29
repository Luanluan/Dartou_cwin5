package cwin5.control.btn
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	
	/**
	 * 按钮基类
	 * @author cwin5
	 */
	public class C5BasicButton
	{
		////////////////////////////////////////////////////////////////////////////////
		/**
		 * 设置
		 */
		public static function setMouseHandler(handler:IC5MouseHandler):void
		{
			_handler = handler;
		}
		
		// 鼠标处理器
		private static var _handler:IC5MouseHandler = null;
		private static const NULL_HANDLER:C5MouseHandler = new C5MouseHandler();
		
		protected function get handler():IC5MouseHandler 
		{
			// 如果自己有处理器,则取自身的
			if (_selfHandler != null)
				return _selfHandler;
			
			if (_handler == null)
			{
				_handler = new C5MouseHandler();
			}
			return _handler; 
		}
		
		////////////////////////////////////////////////////////////////////////////////
		protected var _mc:MovieClip = null;			// 按钮对象
		protected var _enable:Boolean = false;		// 是否启用
		protected var _selfHandler:IC5MouseHandler = null;	// 自身的处理器
		
		/**
		 * 构造
		 */
		public function C5BasicButton() 
		{
			
		}
		
		/**
		 * 设置自身处理器
		 */
		public function setSelfHandler(value:IC5MouseHandler):void 
		{
			_selfHandler = value;
		}
		
		/**
		 * 设置空侦听器
		 */
		public function setNullHandler():void
		{
			_selfHandler = NULL_HANDLER;
		}
		
		public function changeMC(mc:MovieClip):void
		{
			var flag:Boolean = enable;
			if (enable)
				enable = false;
			setMC(mc);
			if (flag && mc)
				enable = flag;
		}
		
		// 设置MC
		protected function setMC(mc:MovieClip):void
		{
			_mc = mc;
			if (_mc)
			{
				_mc.buttonMode = true;
				_mc.cacheAsBitmap = true;
				_mc.mouseEnabled = _mc.mouseChildren = false;
			}
		}
		
		/**
		 * 显示
		 */
		public function show():void
		{
			_mc.visible = true;
		}
		
		/**
		 * 隐藏
		 */
		public function hide():void
		{
			_mc.visible = false;
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
			
			if ( _enable )
			{
				addEvent();
				_mc.mouseEnabled = true;
				processEnable();
			}
			else
			{
				removeEvent();
				_mc.mouseEnabled = false;
				processDisable();
			}
		}
		
		/**
		 * 处理启动事件
		 */
		protected function processEnable():void
		{
			
		}
		
		/**
		 * 处理关闭事件
		 */
		protected function processDisable():void
		{
			
		}
		
		/// 事件处理器
		public var clickFunc:Function = null;
		public var overFunc:Function = null;
		public var outFunc:Function = null;
		public var downFunc:Function = null;
		public var upFunc:Function = null;
		
		/**
		 * 清除所有事件处理器
		 */
		public function clearFunc():void
		{
			clickFunc = overFunc = outFunc = downFunc = upFunc = null;
		}
		
		// 添加事件
		protected function addEvent():void
		{
			_mc.addEventListener(MouseEvent.CLICK , onClick);
			_mc.addEventListener(MouseEvent.ROLL_OVER , rollOver);
			_mc.addEventListener(MouseEvent.ROLL_OUT , rollOut);
			_mc.addEventListener(MouseEvent.MOUSE_DOWN , mouseDown);
			_mc.addEventListener(MouseEvent.MOUSE_UP , mouseUp);
		}
		
		// 移除事件
		protected function removeEvent():void
		{
			_mc.removeEventListener(MouseEvent.CLICK , onClick);
			_mc.removeEventListener(MouseEvent.ROLL_OVER , rollOver);
			_mc.removeEventListener(MouseEvent.ROLL_OUT , rollOut);
			_mc.removeEventListener(MouseEvent.MOUSE_DOWN , mouseDown);
			_mc.removeEventListener(MouseEvent.MOUSE_UP , mouseUp);
		}
		
		public static var noClick:Boolean = false;
		
		// 单击
		protected function onClick(e:MouseEvent):void 
		{
			if (handler.soundSwitch)
				handler.sound();
			if (noClick)
			{
				//trace("跳過");
				noClick = false;
				return;
			}
			if (clickFunc != null)
				clickFunc(e);
		}
		
		// 移入
		protected function rollOver(e:MouseEvent):void 
		{
			handler.point();
			if (overFunc != null)
				overFunc(e);
		}
		
		// 移出
		protected function rollOut(e:MouseEvent):void 
		{
			handler.arrow();
			if (outFunc != null)
				outFunc(e);
		}
		
		// 按下
		protected function mouseDown(e:MouseEvent):void 
		{
			if (downFunc != null)
				downFunc(e);
		}
		
		// 弹起
		protected function mouseUp(e:MouseEvent):void 
		{
			if (upFunc != null)
				upFunc(e);
		}
		
		/**
		 *  显示对象
		 */
		public function get mc():MovieClip { return _mc; }
		
	}
	
}