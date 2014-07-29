package cwin5.debug 
{
	//import nl.demonsters.debugger.MonsterDebugger;
	
	/**
	 * 调试,使用DeMonsterDebugger调试
	 * @author cwin5
	 */
	public class Debug
	{
		// 调试器
		//private static var _debugger:MonsterDebugger = null;
		
		/**
		 * Debug初始化,传入一个主程序
		 * @param	main
		 */
		public static function init(main:Object):void
		{
			//if (_debugger != null)
				//return;
			
			//_debugger = new MonsterDebugger(main);
		}
		
		/**
		 * 输出信息
		 * @param	target		调用debug的对象
		 * @param	object		要输出的信息
		 */
		public static function debug(target:Object, object:Object):void
		{
			//if (_debugger == null)
				//return;
			
			//MonsterDebugger.trace(target , object);
		}
		
		
		public static function TRACE(obj:Object):void
		{
			trace(obj);
		}
		
	}

}