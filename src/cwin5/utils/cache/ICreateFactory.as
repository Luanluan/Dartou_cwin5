package cwin5.utils.cache 
{
	
	/**
	 * 创建工厂接口
	 * @author cwin5
	 */
	public interface ICreateFactory 
	{
		/**
		 * 创建
		 * @return
		 */
		function create(...params):*;
	}
	
}