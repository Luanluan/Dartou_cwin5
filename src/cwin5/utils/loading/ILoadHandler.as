package cwin5.utils.loading 
{
	
	/**
	 * 外部接口,调用界面显示
	 * 外部界面实现此接口
	 * @author cwin5
	 */
	public interface ILoadHandler
	{
		/**
		 * 设置百分比
		 * 1-100
		 * @param	percent
		 */
		function setPercent(percent:int):void;
	}
	
}