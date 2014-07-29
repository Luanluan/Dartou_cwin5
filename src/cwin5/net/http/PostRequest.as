package cwin5.net.http 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * http post请求器
	 * @author cwin5
	 */
	public class PostRequest implements IHttpRequest
	{
		
		protected var _postUrl:String = "";
		protected var _queue:Array = [];
		protected var _requesting:Boolean = false;
		protected var _urlRequest:URLRequest = new URLRequest();
		
		protected var _curParams:Array = null;
		
		/**
		 * 构造
		 * @param	postUrl		post地址
		 */
		public function PostRequest(postUrl:String) 
		{
			_postUrl = postUrl;
			_urlRequest.url = _postUrl;
			_urlRequest.method = URLRequestMethod.POST;
		}
		
		/**
		 * 请求
		 * @param	...params
		 */
		public function request(...params):void
		{
			_queue.push(params);
			if (!_requesting)
			{
				_requesting = true;
				nextRequest();
			}
		}
		
		/**
		 * 下一个请求
		 */ 
		private function nextRequest():void
		{
			if (_queue.length == 0)
			{
				_requesting = false;
				return;
			}
			
			_curParams = _queue[0];
			goRequest(_curParams);
			
			_queue.shift();
		}
		
		/// 开始请求
		private function goRequest(params:Array):void
		{
			
			var urlVar:URLVariables = getVar(params);
			_urlRequest.data = urlVar;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onResult);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.load(_urlRequest);
		}
		
		/// 请求失败
		protected function onError(e:Event):void 
		{
			removeEvent(e.currentTarget);
			goRequest(_curParams);		// 重新请求
		}
		
		/// 返回数据
		private function onResult(e:Event):void 
		{
			removeEvent(e.currentTarget);
			
			processResult(e.currentTarget.data);
			_curParams = null;
			nextRequest();
		}
		
		private function removeEvent(target:Object):void
		{
			target.removeEventListener(Event.COMPLETE, onResult);
			target.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		/// 处理数据.子类复写
		protected function processResult(data:String):void
		{
			throw new Error("This hasn't override");
		}
		
		// 获取参数, 子类复写
		protected function getVar(params:Array):URLVariables
		{
			throw new Error("This hasn't override");
			return null;
		}
		
		/**
		 * 类型
		 */
		public function get type():String
		{
			throw new Error("This hasn't override");
			return "";
		}
		
		
	}

}