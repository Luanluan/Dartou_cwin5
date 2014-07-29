package cwin5.net.socket 
{
	import flash.utils.ByteArray;
	/**
	 * 分析结果
	 * @author cwin5
	 */
	public class SocketResult
	{
		/**
		 * 主命令号
		 */
		public var mainCmd:int = 0;
		
		/**
		 * 子命令号
		 */
		public var subCmd:int = 0;
		
		/**
		 * 包体
		 */
		public var body:ByteArray = null;
		
		public function SocketResult() 
		{
			
		}
		
	}

}