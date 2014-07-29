package cwin5.net.socket.parse 
{
	import flash.utils.ByteArray;
	
	/**
	 * 包头解析器
	 * @author cwin5
	 */
	public interface IHeadParser 
	{
		/**
		 * 包头长度
		 */
		function get headSize():int;
		
		/**
		 * 包体长度
		 */
		function get bodySize():int;
		
		/**
		 * 解析
		 * @param	data
		 */
		function parse(data:ByteArray):void;
		
		/**
		 * 輸出文本
		 * @return
		 */
		function toString():String;
	}
	
}