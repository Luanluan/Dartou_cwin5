package cwin5.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	
	/**
	 * 工具
	 * @author cwin5
	 */
	public class C5Utils 
	{
		/**
		 * 停止所有动画
		 * @param	displayObjContainer
		 */
		public static function stopAll(displayObjContainer:DisplayObjectContainer):void
		{
			if (!displayObjContainer)
				return;
			if (displayObjContainer is MovieClip)
				displayObjContainer["stop"]();
			for (var i:int = 0; i < displayObjContainer.numChildren; i++) 
			{
				var obj:DisplayObjectContainer = displayObjContainer.getChildAt(i) as DisplayObjectContainer;
				if (obj)
				{
					if (obj is MovieClip)
						obj["stop"]();
					stopAll(obj);
				}
			}
		}
		
		/**
		 * 播放所有动画
		 * @param	displayObjContainer
		 */
		public static function playAll(displayObjContainer:DisplayObjectContainer):void
		{
			if (!displayObjContainer)
				return;
			if (displayObjContainer is MovieClip)
				displayObjContainer["play"]();
			for (var i:int = 0; i < displayObjContainer.numChildren; i++) 
			{
				var obj:DisplayObjectContainer = displayObjContainer.getChildAt(i) as DisplayObjectContainer;
				if (obj)
				{
					if (obj is MovieClip)
						obj["play"]();
					playAll(obj);
				}
			}
		}
		
		/**
		 * 移除显示对象内的所有子级
		 * @param	displayObjContainer
		 */
		public static function removeAllChild(displayObjContainer:DisplayObjectContainer):void
		{
			while ( displayObjContainer.numChildren )
			{
				displayObjContainer.removeChildAt(0);
			}
		}
		
		/**
		 * 将显示对象从显示列表移除
		 * @param	displayObj
		 */
		public static function removeFromStage(displayObj:DisplayObject):void
		{
			if ( displayObj && displayObj.parent )
				displayObj.parent.removeChild(displayObj);
		}
		
		/**
		 * 添加元素到数组
		 * @param	array			数组
		 * @param	element			要添加的元素
		 * @return					如果已在此数组则返回false, 添加成功返回true
		 */
		public static function addElement(array:Array , element:Object):Boolean
		{
			if (element == null)
				throw new Error("element is null");
			if (array.indexOf(element) != -1)
				return false;
			array.push(element);
			return true;
		}
		
		/**
		 * 从数组中移除元素
		 * @param	array			数组
		 * @param	element			要移除的元数
		 * @return					如果不在此数组则返回false, 移除成功返回true
		 */
		public static function removeElement(array:Array , element:Object):Boolean
		{
			var index:int = array.indexOf(element);
			if (index == -1)
				return false;
			array.splice(index , 1);
			return true;
		}
		
		/**
		 * 获取一个无空数组
		 * @param	array			要获取的数组
		 * @return					返回一个无空数组
		 */
		public static function getNoNullArray(array:Array):Array
		{
			return array.filter ( function (element:Object, index:int, arr:Array):Boolean { return (element != null); } );
		}
		
		/**
		 * 将一个数字转成需要位数数字, 如5转两位为"05"
		 * @param	num				需要转换的数字
		 * @param	bit				转换的位数
		 */
		public static function getBitNumberString(num:int , bit:int):String
		{
			var str:String = num.toString();
			for ( var i :int = str.length ; i < bit; i++)
			{
				str = "0" + str;
			}
			return str;
		}
		
		/**
		 * 获取HTML的颜色文本
		 * @param	string			需要颜色的文本
		 * @param	color			颜色值
		 */
		public static function getHtmlColorString(string:String , color:uint):String
		{
			var colorStr:String = color.toString(16);
			return "<font color='#" + colorStr + "'>" + string + "</font>";
		}
		
		/**
		 * 获取文件类型
		 * @param	fileName
		 * @return
		 */
		public static function getFileType(fileName:String):String
		{
			var type:String = "";
			for (var i:int = fileName.length - 1; i >= 0; i--) 
			{
				var char:String = fileName.charAt(i);
				if (char == ".")
					break;
				type = char + type;
			}
			return type;
		}
		
		/**
		 * 获取文件名
		 * @param	url
		 * @return
		 */
		public static function getFileName(url:String):String
		{
			var fileName:String = "";
			var flag:Boolean = false;
			for (var i:int = url.length - 1; i >= 0; i--) 
			{
				var char:String = url.charAt(i);
				if (flag)
				{
					if (char == "/")
					{
						break;
					}
					fileName = char + fileName;
				}
				else if (char == ".")
				{
					flag = true;
				}
			}
			return fileName;
		}
		
		/**
		 * 随机打乱数组函数,用于sort
		 * @return
		 */
		public static function randSort(a:int , b:int):int
		{
			return Math.random() * 20 - 10;
		}
		
		
		/**
		 * 將文本的默认格式字體改為arial
		 * fuck flash cs5
		 * @param	...arg
		 */
		public static function formatArial(...arg):void
		{
			for (var i:int = 0; i < arg.length; i++) 
			{
				arg[i].defaultTextFormat = ARIAL_FORMAT;
			}
		}
		public static function formatBoldArial(...arg):void
		{
			for (var i:int = 0; i < arg.length; i++) 
			{
				arg[i].defaultTextFormat = ARIAL_BOLD_FORMAT;
			}
		}
		private static const ARIAL_FORMAT:TextFormat = new TextFormat("Arial");
		private static const ARIAL_BOLD_FORMAT:TextFormat = new TextFormat("Arial", null, null, true);
		
		/**
		 * 绕过IE拦截
		 * @param	url
		 * @param	window
		 * @param	featurse
		 */
		public static function openUrl(url:String , window:String = "_blank" , featurse:String = ""):void
		{
			var urlReq:URLRequest = new URLRequest(url);
			if (!ExternalInterface.available)
			{
				navigateToURL(urlReq , window);
				return;
			}
			var func:String = "window.open";
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			if (browserAgent != null && browserAgent.indexOf("Firefox") >= 0)
			{
				ExternalInterface.call(func , url , window, featurse);
			}
			else if (browserAgent != null && browserAgent.indexOf("Safari") >= 0)
			{
				navigateToURL(urlReq , window);
			}
			else if (browserAgent != null && browserAgent.indexOf("MSIE") >= 0)
			{
				ExternalInterface.call(func , url , window, featurse);
			}
			else if (browserAgent != null && browserAgent.indexOf("Opera") >= 0)
			{
				navigateToURL(urlReq , window);
			}
			else
			{
				navigateToURL(urlReq , window);
			}
		}
		
		public static function getBrowser():String
		{
			if (!ExternalInterface.available)
				return "";
			var browserAgent:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
			return browserAgent;
		}
		
		public static function getBrowserVersion():String
		{
			if (!ExternalInterface.available)
				return "";
			var browserAgent:String = getBrowser();
			
			if (browserAgent != null && browserAgent.indexOf("Firefox") >= 0)
			{
				return "Firefox";
			}
			else if (browserAgent != null && browserAgent.indexOf("Chrome") >= 0)
			{
				return "Chrome";
			}
			else if (browserAgent != null && browserAgent.indexOf("Safari") >= 0)
			{
				return "Safari";
			}
			else if (browserAgent != null && browserAgent.indexOf("MSIE") >= 0)
			{
				if (browserAgent.indexOf("MSIE 8.0") >= 0)
				{
					return "MSIE 8.0";
				}
				else if (browserAgent.indexOf("MSIE 6") >= 0)
				{
					return "MSIE 6.0";
				}
				else if (browserAgent.indexOf("MSIE 9") >= 0)
				{
					return "MSIE 9.0";
				}
				else if (browserAgent.indexOf("MSIE 7") >= 0)
				{
					return "MSIE 7.0";
				}
				else
				{
					return "MSIE";
				}
			}
			else if (browserAgent != null && browserAgent.indexOf("Opera") >= 0)
			{
				return "Opera";
			}
			else
			{
				return "Unknow Browser";
			}
			
			return browserAgent;
		}
		
		
		public static function cacheAsBitmap(displayObj:DisplayObject):void
		{
			if (displayObj is MovieClip && displayObj["totalFrames"] > 1)
			{
				//displayObj.cacheAsBitmap = true;
				return;
			}
			if (displayObj is DisplayObjectContainer)
			{
				if ((displayObj as DisplayObjectContainer).numChildren != 0)
				{
					for (var i:int = 0; i < (displayObj as DisplayObjectContainer).numChildren; i++) 
					{
						cacheAsBitmap((displayObj as DisplayObjectContainer).getChildAt(i));
					}
				}
			}
			else
			{
				displayObj.cacheAsBitmap = true;
			}
		}
		
		
		public static function getRandomElement(arr:Array):*
		{
			var index:int = int(Math.random() * arr.length);
			return arr[index];
		}
		
		public static function addClickFunc(event:IEventDispatcher, func:Function):void
		{
			event.addEventListener(MouseEvent.CLICK , func);
		}
		
		public static function removeClickFunc(event:IEventDispatcher, func:Function):void
		{
			event.removeEventListener(MouseEvent.CLICK, func);
		}
		
		
	}
	
}