package cwin5.net.socket.parse 
{
	import flash.utils.ByteArray;
	
	/**
	 * 包尾解析器
	 * @author cwin5
	 */
	public interface IEndParser 
	{
		function get endSize():int;
		function verification(bytes:ByteArray, headParser:IHeadParser):void;
	}
	
}