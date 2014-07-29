package cwin5.basic 
{
	import cwin5.debug.Debug;
	/**
	 * 调试对象
	 * @author cwin5
	 */
	public class C5Object
	{
		
		public function C5Object() 
		{
			
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