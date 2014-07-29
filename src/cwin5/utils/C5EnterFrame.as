package cwin5.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * 刷新事件,
	 * 保证所有处理都在同一帧,
	 * 避免异步问题,
	 * 并可增加运行效率
	 * @author cwin5
	 */
	public class C5EnterFrame 
	{
		private static const UPDATE_SPRITE:Sprite = new Sprite();
		private static const FUNCTION_LIST:Array = [];
		private static const DICT:Dictionary = new Dictionary();
		
		// 开始
		private static function start():void
		{
			UPDATE_SPRITE.addEventListener(Event.ENTER_FRAME , update);
		}
		
		// 停止
		private static function stop():void
		{
			UPDATE_SPRITE.removeEventListener(Event.ENTER_FRAME , update);
		}
		
		// 刷新
		private static function update(e:Event):void 
		{
			for ( var i :int = 0 ; i < FUNCTION_LIST.length; i++)
			{
				var func:Function = FUNCTION_LIST[i];
				func.apply(null , DICT[func][0]);
			}
		}
		
		// 对数组进行排序
		private static function sortFunction(func1:Function , func2:Function):Number
		{
			if ( DICT[func1][1] < DICT[func2][1])
				return 1;
			return -1;
		}
		
		/**
		 * 添加函数
		 * @param	func
		 * @param	priority	优先级别,值越高,优先越高
		 * @param	params	参数
		 */
		public static function addFunction(func:Function , priority:int = 0 , params:Array = null):void
		{
			if (C5Utils.addElement(FUNCTION_LIST , func))
			{
				if (FUNCTION_LIST.length == 1)
				{
					start();
				}
			}
			DICT[func] = [params , priority];
			FUNCTION_LIST.sort(sortFunction);
		}
		
		/**
		 * 移除函数
		 * @param	func
		 */
		public static function removeFunction(func:Function):void
		{
			if (C5Utils.removeElement(FUNCTION_LIST , func))
			{
				if (FUNCTION_LIST.length <= 0)
				{
					stop();
				}
			}
			delete DICT[func];
		}
		
	}
	
}