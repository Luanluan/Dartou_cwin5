package cwin5.control.list 
{
	import cwin5.control.btn.C5Button;
	import cwin5.events.C5ListEvent;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 列表选项目卡
	 * 用于排序
	 * @author cwin5
	 */
	public class C5ListOption extends EventDispatcher
	{
		
		
		private var _selectView:MovieClip;
		
		private var _btnList:Array = [];
		private var _btnDict:Dictionary = new Dictionary();
		
		private var _view:MovieClip;
		
		
		/**
		 * 构造
		 */
		public function C5ListOption(view:MovieClip , optionCount:int , slectClass:Class) 
		{
			_view = view;
			_view.visible = false;
			
			_selectView = new slectClass() as MovieClip;
			_selectView.stop();
			view.addChild(_selectView);
			_selectView.visible = false;
			
			for (var i:int = 1; i <= optionCount; i++) 
			{
				var btn:C5Button = new C5Button(view["btn" + i], false);
				btn.clickFunc = onOptionClick;
				_btnList.push(btn);
			}
		}
		
		public function hideSelectView():void
		{
			_selectView.visible = false;
		}
		
		/**
		 * 添加事件
		 */
		public function addEvent():void
		{
			for (var i:int = 0; i < _btnList.length; i++) 
			{
				var btn:C5Button = _btnList[i];
				btn.enable = true;
			}
			_view.visible = true;
		}
		
		/**
		 * 移除事件
		 */
		public function removeEvent():void
		{
			for (var i:int = 0; i < _btnList.length; i++) 
			{
				var btn:C5Button = _btnList[i];
				btn.enable = false;
			}
			_view.visible = false;
		}
		
		/// 选项卡点击
		private function onOptionClick(e:MouseEvent):void
		{
			var bool:Boolean = _btnDict[e.currentTarget] = !_btnDict[e.currentTarget];
			
			var str:String = e.currentTarget.name;
			var id:int = int(str.substr(3));
			
			_selectView.visible = true;
			
			_selectView.x = e.currentTarget.x + e.currentTarget.width - _selectView.width / 2 - 1;
			
			if (bool)
				_selectView.gotoAndStop(1);
			else
				_selectView.gotoAndStop(2);
			
			dispatchEvent(new C5ListEvent(C5ListEvent.OPTION_CHANGE, { bool:bool , id:id }) );
		}
		
	}

}