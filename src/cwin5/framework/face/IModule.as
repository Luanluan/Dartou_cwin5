package cwin5.framework.face 
{
	
	/**
	 * 模块接口 , 为预留接口,
	 * 任何模块接口都继承此接口
	 * @author cwin5
	 */
	public interface IModule
	{
		/**
		 * 移除模块
		 * 传入一个场景类型,模块自身判定是否移除
		 * @param	sceneType
		 * @return	如果移除则返回true
		 */
		function remove(sceneType:String):Boolean;
		
		/**
		 * 注册到场景
		 */
		function regToScene():void;
		
		/**
		 * 从场景移除
		 */
		function delFromScene():void;
	}
	
}