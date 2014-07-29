package cwin5.basic 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 预加载基类
	 * @author cwin5
	 */
	public class BasicPreLoader extends MovieClip
	{
		/**
		 * 主程序类名
		 */
		protected var _mainClassName:String = "";
		
		/**
		 * 构造
		 */
		public function BasicPreLoader(mainClassName:String) 
		{
			_mainClassName = mainClassName;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/// 初始化
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);;
			loaderInfo.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		/**
		 * 接收数据事件
		 * @param	e
		 */
		protected function progress(e:ProgressEvent):void 
		{
			
		}
		
		// 载入完成
		protected function onLoaded(e:Event):void 
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			
			loadComplete();
		}
		
		/// 载入完成处理
		protected function loadComplete():void
		{
			gotoAndStop(2);
			var tempTtage:Stage = stage;
			var mainClass:Class = getDefinitionByName(_mainClassName) as Class;
			parent.removeChild(this);
			tempTtage.addChildAt(new mainClass() as DisplayObject, 0);
		}
		
	}

}