package cwin5.framework.face 
{
	
	/**
	 * 拥有事件接口
	 * @author cwin5
	 */
	public interface IHasEvent 
	{
		/**
		 * 添加事件
		 */
		function addEvent():void;
		
		/**
		 * 移除事件
		 */
		function removeEvent():void;
	}
	
}