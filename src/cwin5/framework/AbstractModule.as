package cwin5.framework 
{
	import cwin5.framework.face.IModule;
	
	/**
	 * 模块基类
	 * @author cwin5
	 */
	public class AbstractModule implements IModule
	{
		
		/**
		 * 构造
		 */
		public function AbstractModule() 
		{
			
		}
		
		/**
		 * 移除模块
		 * 传入一个场景类型,模块自身判定是否移除
		 * @param	sceneType
		 * @return	如果移除则返回true
		 */
		public function remove(sceneType:String):Boolean
		{
			throw new Error("Hasn't override!");
			return true;
		}
		
		/**
		 * 注册到场景
		 */
		public function regToScene():void
		{
			SceneManager.instance.regModule(this);
		}
		
		/**
		 * 从场景移除
		 */
		public function delFromScene():void
		{
			SceneManager.instance.delModule(this);
		}
		
	}

}