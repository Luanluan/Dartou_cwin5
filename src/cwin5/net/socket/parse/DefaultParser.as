package cwin5.net.socket.parse 
{
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * 默认解析器
	 * @author cwin5
	 */
	public class DefaultParser extends EventDispatcher implements IParseSocketData
	{
		
		protected var _headParser:IHeadParser;		// 包头处理器
		protected var _bodyParser:IBodyParser;		// 包体处理器
		protected var _endParser:IEndParser;		// 包尾处理器
		
		protected var _recvBuff:ByteArray;			// 数据缓冲
		
		protected var _endian:String;
		
		
		
		/**
		 * 构造
		 */
		public function DefaultParser(endian:String , head:IHeadParser , body:IBodyParser , end:IEndParser) 
		{
			_endian = endian;
			//_recvBuff = getNewBytes();
			_headParser = head;
			_bodyParser = body;
			_endParser = end;
		}
		
		private function getNewBytes():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = _endian;
			return bytes;
		}
		
		/**
		 * 解析
		 * @param	socket
		 */
		public function parse(socket:Socket):void
		{
			//trace("收到數據:" , _recvBuff.length , socket.bytesAvailable);
			//var bytes:ByteArray = getNewBytes();;
			//socket.readBytes(bytes);
			//_recvBuff.writeBytes(bytes);
			socket.readBytes(_recvBuff , _recvBuff.length);
			
			if (ExternalInterface.available)
			{
				try
				{
					parseData();
				}
				catch (e:*)
				{
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR , false , false , "解包出错"));
				}
			}
			else
			{
				parseData();
			}
		}
		
		/// 解析数据
		private function parseData():void
		{
			_recvBuff.position = 0;
			if (_recvBuff.length < _headParser.headSize)		// 包头长度不足
			{
				//trace("包頭長度不足");
				return;
			}
			
			//trace(_recvBuff.position , _recvBuff.length);
			_headParser.parse(_recvBuff);
			
			/// 包体长度不足
			if (_headParser.bodySize > _recvBuff.length - _headParser.headSize - _endParser.endSize)
			{
				//trace("包體長度不足" ,_recvBuff.length , _headParser.bodySize + _headParser.headSize);
				//_recvBuff.position = 0;
				return;
			}
			//trace("包體長度:" + _headParser.bodySize , _recvBuff.length , _headParser.toString()  , "pos:" + _recvBuff.position);
			//trace("實際解包:" , _headParser["cmd"]);
			
			// 取出包体
			var body:ByteArray = getNewBytes();
			body.writeBytes(_recvBuff, _headParser.headSize , _headParser.bodySize);
			_bodyParser.parse(body);
			body.position = 0;
			
			_recvBuff.position += _headParser.bodySize;
			_endParser.verification(_recvBuff, _headParser);
			
			// 处理
			//try
			//{
				process(body);
			//}
			//catch (e:*)
			//{
				//echoError(e , body);
				//dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				//return;
			//}
			
			/// 更新缓存数据
			var bytes:ByteArray = getNewBytes();
			bytes.writeBytes(_recvBuff , _headParser.headSize + _headParser.bodySize + _endParser.endSize);
			//bytes.position = 0;
			_recvBuff = bytes;
			
			//trace("剩下緩沖大小:" + _recvBuff.length);
			
			parseData();
		}
		
		protected function echoError(e:Error , body:ByteArray):void
		{
			trace("解包出錯" , _headParser.toString() + "\n" , e.getStackTrace());
		}
		
		/// 处理
		protected function process(body:ByteArray):void
		{
			
		}
		
		/**
		 * 清除buffer
		 */
		public function clearBuffer():void
		{
			_recvBuff = getNewBytes();
		}
		
	}

}