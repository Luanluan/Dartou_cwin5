package cwin5.net.socket 
{
	import cwin5.net.socket.parse.IParseSocketData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * socket 
	 * @author cwin5
	 */
	public class C5Socket
	{
		private var _socket:Socket = null;			// socket对象
		private var _handler:ISocketHandler;		// 处理器
		private var _parser:IParseSocketData;		// 解析器
		private var _endian:String;					// 字节序
		
		public function get isConnected():Boolean	{	return _socket && _socket.connected; }
		
		public function set parser(value:IParseSocketData):void 
		{
			_parser = value;
		}
		
		/**
		 * 构造
		 */
		public function C5Socket(endian:String, handler:ISocketHandler , parser:IParseSocketData) 
		{
			_endian = endian;
			_handler = handler;
			_parser = parser;
		}
		
		/**
		 * 连接socket
		 * @param	ip
		 * @param	port
		 */
		public function connect(ip:String , port:int):void
		{
			if (_socket && _socket.connected) 
			{
				_socket.close();
			}			
			_socket = new Socket();
			_socket.endian = _endian;
			_socket.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			_socket.addEventListener(Event.CONNECT , onConnect);
			_socket.addEventListener(Event.CLOSE , onSocketClose);
			_parser.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_parser.clearBuffer();
			_socket.connect(ip , port);
		}
		
		/**
		 * 关闭
		 */
		public function close():void
		{
			removeEvent();
			if (_socket)
			{
				if(_socket.connected)
					_socket.close();
				_socket = null;
			}
		}
		
		/**
		 * 发送数据
		 * @param	bytes
		 */
		public function sendData(bytes:ByteArray):void
		{
			if ( _socket == null || !_socket.connected)
				return;
			_socket.writeBytes(bytes);
			_socket.flush();
		}
		
		
		/// 添加事件
		private function addEvent():void
		{
			_socket.addEventListener(Event.CLOSE , onSocketClose);
			_socket.addEventListener(Event.CONNECT , onConnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA , onSocketData);
			_parser.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		/// 移除事件
		private function removeEvent():void
		{
			if(_socket){
				if(_socket.hasEventListener(IOErrorEvent.IO_ERROR)) _socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				if(_socket.hasEventListener(Event.CONNECT)) _socket.removeEventListener(Event.CONNECT, onConnect);
				if(_socket.hasEventListener(ProgressEvent.SOCKET_DATA)) _socket.removeEventListener(ProgressEvent.SOCKET_DATA,onSocketData);
				if(_socket.hasEventListener(Event.CLOSE)) _socket.removeEventListener(Event.CLOSE,onSocketClose);
				if (_socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				if(_parser.hasEventListener(IOErrorEvent.IO_ERROR)) _parser.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
		}
		
		/// 服务器关闭
		private function onSocketClose(e:Event):void 
		{
			close();
			_handler.onClose();
		}
		
		/// 连接
		private function onConnect(e:Event):void 
		{
			removeEvent();
			_socket.addEventListener(ProgressEvent.SOCKET_DATA , onSocketData);
			_socket.addEventListener(Event.CLOSE , onSocketClose);
			_handler.onConnect();
		}
		
		/// IO 错误
		private function onIOError(e:IOErrorEvent):void 
		{
			onError(e);
		}
		
		/// 安全域错误
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			onError(e);
		}
		
		/// 收到数据
		private function onSocketData(e:ProgressEvent):void 
		{
			//trace("长度：" + e.currentTarget.bytesAvailable);
			_parser.parse(_socket);
		}
		
		private function onError(e:ErrorEvent):void
		{
			close();
			_handler.onError(e);
		}
		
	}

}