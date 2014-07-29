package cwin5.control.mission 
{
	import cwin5.basic.BasicComplete;
	import cwin5.utils.cache.CacheManager;
	
	/**
	 * 任务基类
	 * @author cwin5
	 */
	public class BasicMission extends BasicComplete
	{
		
		/**
		 * 构造
		 */
		public function BasicMission() 
		{
			
		}
		
		public function cache():void
		{
			CacheManager.instance.delObject(this);
		}
		
	}

}