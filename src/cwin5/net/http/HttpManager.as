package cwin5.net.http 
{
	import flash.utils.Dictionary;
	
	/**
	 * Http(web)请求管理器
	 * @author cwin5
	 */
	public class HttpManager
	{
		
		private static var _dict:Dictionary = new Dictionary();
		
		/**
		 * 注册请求
		 * @param	request
		 */
		public static function regRequest(request:IHttpRequest):void
		{
			if (!_dict[request.type])
				_dict[request.type] = request;
		}
		
		/**
		 * 重置所有连接
		 */
		public function resetAllConnect():void
		{
			for each(var request:PHPRequest in _dict)
			{
				if(request.gwUrl != "")
					request.createNewConnect(request.gwUrl);
			}
		}
		
		/**
		 * 获取请求器
		 * @param	type
		 * @return
		 */
		public static function getRequest(type:String):IHttpRequest
		{
			if (_dict[type] == null)
				throw new Error("This Type hasn't PHPRequest!");
			return _dict[type];
		}
		
	}
	
}