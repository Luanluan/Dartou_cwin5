package cwin5.utils.loading 
{
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	/**
	 * 载入数据
	 * @author cwin5
	 */
	public class LoadData
	{
		
		/**
		 * 地址
		 */
		public var url:String = "";
		
		/**
		 * 文件大小,字节为单位
		 */
		public var size:int = 0;
		
		/**
		 * 载入完成后的二进制数据
		 */
		public var data:ByteArray = null;
		
		/**
		 * 附加参数
		 */
		public var param:Object = null;
		
		// 所属域
		public var domain:ApplicationDomain = ApplicationDomain.currentDomain;
		
		// 地址列表，如果加载不成功，则切换地址
		private var _urlList:Array;
		
		// 地址列表索引
		private var _index:int = 0;
		
		/**
		 * 构造
		 * @param	url		载入地址
		 * @param	size	文件大小
		 * @param	param	参数
		 */
		public function LoadData(url:Object , size:int = 0 , param:Object = null) 
		{
			if (url is Array)
			{
				this.url = url[0];
				this._urlList = url as Array;
			}
			else
			{
				this.url = url as String;
			}
			this.size = size;
			this.param = param;
		}
		
		/**
		 * 获取下一个地址，如果返回空值，
		 * @return
		 */
		public function getNextUrl():String
		{
			if (_urlList && _urlList.length > 1)
			{
				_index++;
				if (_index >= _urlList.length)
				{
					_index = 0;
				}
				
				if (_urlList[_index])
				{
					return this.url = _urlList[_index];
				}
			}
			return "";
		}
		
		/**
		 * 是否有下一个地址
		 * @return
		 */
		public function get hasNextUrl():Boolean
		{
			if (_urlList && _urlList.length > 1)
			{
				var i:int = _index + 1;
				if (i >= _urlList.length)
				{
					i = 0;
				}
				if (_urlList[i])
				{
					return true;
				}
			}
			return false;
		}
		
	}

}