package cwin5.framework.face 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 销毁接口
	 * @author cwin5
	 */
	public interface IDestroy extends IEventDispatcher
	{
		/**
		 * 当确定一个对象不再使用时才可调用
		 */
		function destroy():void;
		
		/**
		 * 输出文本
		 * @return
		 */
		function toString():String;
	}
	
}