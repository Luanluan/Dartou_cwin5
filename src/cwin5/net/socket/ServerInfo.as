package cwin5.net.socket
{
	/**
	 * 服务器信息
	 * @author cwin5
	 */
	public class ServerInfo
	{
		/**
		 * IP
		 */
		public var ip:String = "";
		
		/**
		 * 端口
		 */
		public var port:int = 0;
		
		
		/**
		 * 构造
		 * @param	ip
		 * @param	port
		 */
		public function ServerInfo(ip:String , port:int) 
		{
			this.ip = ip;
			this.port = port;
		}
		
	}

}