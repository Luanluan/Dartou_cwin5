package cwin5.control.btn
{
	
	/**
	 * 鼠标处理接口
	 * @author cwin5
	 */
	public interface IC5MouseHandler 
	{
		/**
		 * 普通鼠标
		 */
		function arrow():void;
		
		/**
		 * 点
		 */
		function point():void;
		
		/**
		 * 播放声音
		 */
		function sound():void;
		
		/**
		 * 音效开关
		 * @return
		 */
		function get soundSwitch():Boolean;
	}
	
}