package cwin5.control.list 
{
	import flash.display.DisplayObject;
	
	/**
	 * list item 接口
	 * @author cwin5
	 */
	public interface IC5ListItem 
	{
		function setData(data:*):void;
		
		function removeData():void;
		
		function getView():DisplayObject;
		
		function addItemEvent():void;
		
		function removeItemEvent():void;
		
		function get height():Number;
	}
	
}