package cwin5.net.socket.parse 
{
	import flash.events.IEventDispatcher;
	import flash.net.Socket;
	
	/**
	 * 分析数据
	 * @author cwin5
	 */
	public interface IParseSocketData extends IEventDispatcher
	{
		function parse(socket:Socket):void;
		
		/**
		 * 清空buffer
		 */
		function clearBuffer():void;
	}
	
}