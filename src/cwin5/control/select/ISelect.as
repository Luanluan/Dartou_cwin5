package cwin5.control.select 
{
	
	/**
	 * 选择接口
	 * @author cwin5
	 */
	public interface ISelect
	{
		/**
		 * 是否启用
		 */
		function get enable():Boolean;
		function set enable(value:Boolean):void;
		
		/**
		 * 选择
		 */
		function get select():Boolean;
		function set select(value:Boolean):void;
		
		/**
		 * 设置回调
		 */
		function setCallBack(value:Function, ...params):void;
		
		/**
		 * 组回调
		 */
		function set groupCallBack(value:Function):void;
	}

}