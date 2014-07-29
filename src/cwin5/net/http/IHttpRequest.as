package cwin5.net.http 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * http 请求 接口
	 * @author cwin5
	 */
	public interface IHttpRequest extends IEventDispatcher
	{
		/**
		 * 请求
		 * @param	...params
		 */
		function request(...params):void;
		
		/**
		 * 类型
		 */
		function get type():String;
	}
	
}