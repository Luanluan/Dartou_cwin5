package cwin5.utils 
{
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	
	/**
	 * 滚轮过滤
	 * @author cwin5
	 */
	public class MouseWheelFilter 
	{
		/**
		 * 是否启用
		 */
		private static const ENABLE:Boolean = true;
		
		/**
		 * 设置过滤器
		 * @param	stage
		 */
		public static function setFilter():void
		{
			if (!ENABLE)
				return;
			
			if (ExternalInterface.available)
			{
				ExternalInterface.call("eval", "var _onFlashMousewheel = function(e){"
											+ "e = e || event;"
											+ "e.preventDefault && e.preventDefault();"
											 + "e.stopPropagation && e.stopPropagation();"	
											 + "return e.returnValue = false;"
											 + "};"
											 + "if(window.addEventListener){"
											 + "var type = (document.getBoxObjectFor)?'DOMMouseScroll':'mousewheel';"
											 + "window.addEventListener(type, _onFlashMousewheel, false);}"
											 + "else{document.onmousewheel = _onFlashMousewheel;}");
			}
		}
		
	}
	
}