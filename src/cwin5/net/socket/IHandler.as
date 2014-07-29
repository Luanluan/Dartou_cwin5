package cwin5.net.socket 
{
	
	/**
	 * socket处理器接口
	 * @author cwin5
	 */
	public interface IHandler 
	{
		/**
		 * 处理
		 * @param	reslut		分析结果
		 * @return
		 */
		function process(result:SocketResult):Boolean;
	}
	
}