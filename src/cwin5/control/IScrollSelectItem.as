package cwin5.control 
{
	import flash.display.DisplayObject;
	
	/**
	 * scroll select item
	 * 中心点需居中
	 * @author cwin5
	 */
	public interface IScrollSelectItem 
	{
		/**
		 * 视图
		 */
		function get view():DisplayObject;
		
		/**
		 * 缓存
		 */
		function cache():void;
		
		/**
		 * 高
		 */
		function get height():Number;
	}
	
}