package cwin5.net.socket.parse 
{
	import flash.utils.ByteArray;
	
	/**
	 * 包体解析器
	 * @author cwin5
	 */
	public interface IBodyParser 
	{
		function parse(data:ByteArray):void;
	}
	
}