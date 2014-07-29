package cwin5.control.text 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import cwin5.utils.C5Math;
	import cwin5.utils.TextUtils;
	
	/**
	 * 滚动文本
	 * @author cwin5
	 */
	public class NumRollText
	{
		private var _dotString:Boolean = false;
		private var _callBackFunc:Function = null;
		protected var _textObj:Object;		// 文本域对象
		protected var _rollTime:Number = 1;
		
		/**
		 * 目标数
		 */
		protected var _num:Number = 0;		
		public function get num():Number { return _num; }		
		public function set num(value:Number):void 
		{
			if (_num == value)
				return;
			_num = value;
			TweenLite.to(this , _rollTime , { curNum:_num , ease:Linear.easeNone} );
		}
		
		/**
		 * 当前数字
		 */
		protected var _curNum:Number;
		public function get curNum():Number { return _curNum; }
		public function set curNum(value:Number):void 
		{
			value = C5Math.precision(value , 0);
			_curNum = value;
			if (_dotString)
			{
				_textObj.text = TextUtils.getDotTxt(curNum);
			}
			else
			{
				_textObj.text = "" + curNum;
			}
		}
		
		public function get textObj():Object 
		{
			return _textObj;
		}
		
		public function set textObj(value:Object):void 
		{
			_textObj = value;
		}

		/**
		 * 构造
		 */
		public function NumRollText(textObj:Object , curNum:Number = 0 , dotString:Boolean = false , callBack:Function = null) 
		{
			_textObj = textObj;
			_dotString = dotString;
			_num = this.curNum = curNum;
			_callBackFunc = callBack;
		}
		
		private function complateCallBack():void 
		{
			TweenLite.killTweensOf(this);
			if (_callBackFunc != null)
				_callBackFunc();
		}
		
	}

}