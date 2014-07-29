package cwin5.net.socket 
{
	import cwin5.utils.C5Utils;
	import flash.utils.Dictionary;
	
	/**
	 * socket管理器
	 * @author cwin5
	 */
	public class SocketManager
	{
		/// 处理器字典
		private var _handlerDict:Dictionary = new Dictionary();
		
		/**
		 * 处理
		 * @param	result		分析结果
		 * @param	groupID			所属组
		 * @return	是否处理成功
		 */
		public function process(result:SocketResult , groupID:String = "default"):Boolean
		{
			var group:Array = getHandlerGroup(groupID);
			for (var i:int = 0; i < group.length; i++) 
			{
				var handler:IHandler = group[i];
				if (handler.process(result))
					return true;
			}
			return false;
		}
		
		/**
		 * 添加处理器
		 * @param	handler			处理器
		 * @param	groupID			所属组
		 */
		public function addHandler(handler:IHandler , groupID:String = "default"):void
		{
			var group:Array = getHandlerGroup(groupID);
			C5Utils.addElement(group, handler);
		}
		
		/// 获取处理器组
		private function getHandlerGroup(groupID:String):Array
		{
			if (_handlerDict[groupID] == null)
				_handlerDict[groupID] = [];
			return _handlerDict[groupID];
		}
		
		/// 服务器列表
		private var _serverList:Dictionary = new Dictionary();
		
		/**
		 * 添加服务器
		 * @param	serverInfo
		 * @param	type
		 */
		public function addServer(serverInfo:ServerInfo , type:String):void
		{
			C5Utils.addElement(getServerList(type) , serverInfo);
		}
		
		/**
		 * 删除该类型的所有服务器
		 * @param	type
		 */
		public function delServerByType(type:String):void
		{
			delete _serverList[type];
		}
		
		/**
		 * 获得服务器
		 * @param	type
		 */
		public function getServerList(type:String):Array
		{
			if (!_serverList[type])
				_serverList[type] = [];
			return _serverList[type];
		}
		
		
		
		/**
		 * 构造
		 */
		public function SocketManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():SocketManager
		{
			if(_instance == null)
			{
				_instance = new SocketManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:SocketManager = null;
	}
	
}
class Single{}