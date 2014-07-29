package cwin5.debug 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/**
	 * 调试基类
	 * @author cwin5
	 */
	public class BasicDebug 
	{
		/**
		 * 构造
		 */
		public function BasicDebug() 
		{
			
		}
		
		/**
		 * 写入调试信息 , 子类复写
		 * @param	mid			用户ID
		 */
		protected function writeDebugInfo(mid:int):void
		{
			
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////////
		private var _sprite:Sprite = null;					// 显示背景
		private var _callBack:Function = null;				// 回调
		
		///	初始化
		public function init(callBack:Function , stage:Stage , width:Number , height:Number):void
		{
			_callBack = callBack;
			
			
			var text:TextField = new TextField();
			text.restrict = "0-9";
			text.autoSize = TextFieldAutoSize.CENTER;
			text.type = TextFieldType.INPUT;
			text.border = true;
			text.x = width / 2;
			text.y = height / 2;
			
			// 添加背景层
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0xbbbbbb);
			_sprite.graphics.drawRect(0 , 0 , width , height);
			_sprite.addChild(text);
			
			// 加至舞台
			stage.addChild(_sprite);
			stage.focus = text;
			text.addEventListener(FocusEvent.FOCUS_OUT , onFocusOut);
			text.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		// 焦点丢失
		private function onFocusOut(e:FocusEvent):void 
		{
			var stage:Stage = e.currentTarget.stage;
			stage.focus = e.currentTarget as TextField;
		}
		
		// 鼠标事件
		private function onKeyUp(e:KeyboardEvent):void 
		{
			var text:TextField = e.currentTarget as TextField;
			
			if (e.keyCode != Keyboard.ENTER && e.keyCode != Keyboard.NUMPAD_ENTER || text.text == "")
			{
				return;
			}
			
			e.currentTarget.removeEventListener(KeyboardEvent.KEY_UP , onKeyUp);
			
			/// 写入debug信息
			writeDebugInfo(Number(text.text));
			
			// 移除
			text.removeEventListener(FocusEvent.FOCUS_OUT , onFocusOut);
			(_sprite.parent as Stage).focus = (_sprite.parent as Stage);
			_sprite.parent.removeChild(_sprite);
			_sprite = null;
			
			// 回调
			if (_callBack != null)
			{
				_callBack();
				_callBack = null;
			}
		}
		
	}
	
}