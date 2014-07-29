package cwin5.basic
{
	import cwin5.debug.Debug;
	import flash.display.Sprite;
	
	/**
	 * 精灵基类
	 */
	public class C5Sprite extends Sprite
	{
		
		public function C5Sprite()
		{
			super();
		}
		
		/**
		 * 调试
		 * @param	obj		要输出的信息
		 */
		protected function debug(obj:Object):void
		{
			Debug.debug(this , obj);
		}
		
	}
}