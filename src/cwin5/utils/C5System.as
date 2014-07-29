package cwin5.utils 
{
	import cwin5.control.StageProxy;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.net.LocalConnection;
	import flash.system.ApplicationDomain;
	
	/**
	 * 系统工具
	 * @author cwin5
	 */
	public class C5System 
	{
		/**
		 * 强制GC
		 */
		public static function gc():void
		{
			try 
			{
				new LocalConnection().connect("cwin5");
				new LocalConnection().connect("cwin5");
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * 获取类
		 * @param	className			类名字
		 * @param	appDomain			所在程序域,默认为系统当前域
		 * @return
		 */
		public static function getClass(className:String , appDomain:ApplicationDomain = null):Class
		{
			if (appDomain == null)
				appDomain = ApplicationDomain.currentDomain;
			return appDomain.getDefinition(className) as Class;
		}
		
		/**
		 * 获取对象的类
		 * @param	obj
		 * @return
		 */
		public static function getObjClass(obj:*):Class
		{
			if (obj is Class)
				return obj;
			var objClass:Class = obj.constructor as Class;
			return objClass;
		}
		
		
		public static function draw(disObj:DisplayObject):BitmapData
		{
			hideLoader(disObj as DisplayObjectContainer);
			var bmd:BitmapData = new BitmapData(disObj.width / disObj.scaleX, disObj.height / disObj.scaleY);
			bmd.draw(disObj);
			showLoader();
			return bmd;
		}
		
		public static function drawWithSize(disObj:DisplayObject, width:Number , height:Number):BitmapData
		{
			hideLoader(disObj as DisplayObjectContainer);
			var bmd:BitmapData = new BitmapData(width, height);
			bmd.draw(disObj);
			showLoader();
			return bmd;
		}
		
		/**
		 * 隐藏所有loader , 用来调用Draw方法
		 * @param	container
		 */
		public static function hideLoader(container:DisplayObjectContainer):void
		{
			if (container == null)
				return;
			showLoader();
			_hideLoader = new HideLoader(container);
		}
		
		/**
		 * 显示loader
		 */
		public static function showLoader():void
		{
			if (_hideLoader)
			{
				_hideLoader.revert();
				_hideLoader = null;
			}
		}
		private static var _hideLoader:HideLoader = null;
		
		
		
	}
	
}
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Stage;
import flash.utils.Dictionary;
import cwin5.utils.C5Utils;
class HideLoader
{
	
	private var _list:Array = [];
	private var _indexDict:Dictionary = new Dictionary();
	
	/**
	 * 隐藏loader对象
	 * @param	stage
	 */
	public function HideLoader(container:DisplayObjectContainer)
	{
		findLoader(container);
	}
	
	/**
	 * 查找loader
	 * @param	container
	 */
	private function findLoader(container:DisplayObjectContainer):void
	{
		for ( var i :int = 0 ; i < container.numChildren ; i++)
		{
			var obj:DisplayObject = container.getChildAt(i);
			if (obj is Loader)	// 为loader
			{
				try
				{
					(obj as Loader).content;
				}
				catch (e:*)
				{
					_list.push(obj);
					_indexDict[obj] = [obj.parent , obj.parent.getChildIndex(obj)];
					C5Utils.removeFromStage(obj);
				}
			}
			else if (obj is DisplayObjectContainer)	// 为容器
			{
				findLoader(obj as DisplayObjectContainer);
			}
		}
	}
	
	/**
	 * 还原
	 */
	public function revert():void
	{
		for ( var i :int = 0 ; i < _list.length; i++)
		{
			var obj:Loader = _list[i];
			var arr:Array = _indexDict[obj];
			arr[0].addChildAt(obj, arr[1]);
		}
	}
}