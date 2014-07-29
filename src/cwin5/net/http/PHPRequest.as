package cwin5.net.http 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	/**
	 * PHP请求
	 * 所有PHP请求类都继承此类
	 * @author cwin5
	 */
	public class PHPRequest extends EventDispatcher implements IHttpRequest
	{
		
		public static const ERROR:String = "error";
		
		protected var _connect:NetConnection = null;		// 连接 
		
		protected var _command:String = "";					// 通信命令
		private var _objectEncoding:uint;
		
		/**
		 * 构造
		 * @param gatewayUrl		服务器地址
		 * @param command			通信命令
		 * @param objectEncoding	AMF协议版本,默认为3
		 */
		public function PHPRequest(gatewayUrl:String , command:String, objectEncoding:uint = 3) 
		{
			_command = command;
			_objectEncoding = objectEncoding;
			
			// 创建连接
			_connect = new NetConnection();
			_connect.objectEncoding = _objectEncoding;		// 传输协议
			_connect.connect(gatewayUrl);
			_connect.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectError);
			_connect.addEventListener(IOErrorEvent.IO_ERROR, onConnectError);
			_connect.addEventListener(NetStatusEvent.NET_STATUS, onConnectError);
		}
		
		public function createNewConnect(newUrl:String):void
		{
			if(_connect.connected) _connect.close();
			_connect.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectError);
			_connect.removeEventListener(IOErrorEvent.IO_ERROR, onConnectError);
			_connect.removeEventListener(NetStatusEvent.NET_STATUS, onConnectError);
			
			_connect = new NetConnection();
			_connect.objectEncoding = _objectEncoding;		// 传输协议
			_connect.connect(newUrl);
			_connect.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectError);
			_connect.addEventListener(IOErrorEvent.IO_ERROR, onConnectError);
			_connect.addEventListener(NetStatusEvent.NET_STATUS, onConnectError);
		}
		
		public function get gwUrl():String
		{
			//throw new Error("This hasn't override");
			return "";
		}
		
		/// 连接错误
		protected function onConnectError(e:Event):void 
		{
			//throw new Error(e.toString());
			dispatchEvent(new Event(ERROR));
		}
		
		/**
		 * 请求 , 子类复写
		 * 例:
		 * var id:String = params[0];
		 * call("Service_User.login", id);
		 * @param	...params
		 */
		public function request(...params):void
		{
			call(_command , params);
		}
		
		/// 调用
		protected function call(command:String, params:Array):void
		{
			params.unshift(new Responder(function (resulut:Object):void { onBack(resulut , params); } , onError)); 
			params.unshift(command);
			_connect.call.apply(null, params);
			//_connect.call(command, new Responder(onResult , onError));
		}
		
		// 服务器返回原始数据
		protected function onBack(result:Object , params:Array):void
		{
			onResult(result, params);
		}
		
		/// 返回成功,子类复写
		protected function onResult(result:Object , params:Array):void
		{
			throw new Error("This hasn't override");
		}
		
		/// 错误
		protected function onError(errorInfo:Object):void
		{
			var errorStr:String = "";
			for (var key:Object in errorInfo)
			{
				errorStr += key + ":" + errorInfo[key] + "  ";
			}
			trace(errorStr);
		}
		
		/**
		 *  获取类型
		 */
		public function get type():String
		{
			throw new Error("This hasn't override");
			return "";
		}
		
	}

}