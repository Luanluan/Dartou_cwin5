package cwin5.net.socket 
{
	
	/**
	 * socket处理器
	 * @author cwin5
	 */
	public interface ISocketHandler 
	{
		/**
		 * 连接事件
		 */
		function onConnect():void;
		
		/**
		 * 关闭事件
		 */
		function onClose():void;
		
		/**
		 * 错误事件
		 */
		function onError(error:Object = null):void;
	}
	
}