package cwin5.framework 
{
	import cwin5.events.SceneEvent;
	import flash.display.Scene;
	import flash.events.EventDispatcher;
	import cwin5.framework.face.IScene;
	
	/**
	 * 场景基类
	 * @author cwin5
	 */
	public class AbstractScene extends EventDispatcher implements IScene
	{
		
		/**
		 * 构造
		 */
		public function AbstractScene() 
		{
			
		}
		
		/**
		 * 进入场景 , 子类复写
		 * 必须发出完成事件
		 * @param	arg		为自定义参数
		 */
		public function enterScene(...arg):void
		{
			throw new Error("This hasn'st override");
		}
		
		/**
		 * 进入场景完成
		 */
		protected function enterSceneComplete():void
		{
			dispatchEvent(new SceneEvent(SceneEvent.ENTER_SCENE_COMPLETE , this));
		}
		
		/**
		 * 移除场景 , 子类复写
		 * 必须发出完成事件
		 */
		public function removeScene():void
		{
			throw new Error("This hasn'st override");
		}
		
		/**
		 * 移除场景完成
		 */
		protected function removeSceneComplete():void
		{
			dispatchEvent(new SceneEvent(SceneEvent.REMOVE_SCENE_COMPLETE , this));
		}
		
		/**
		 * 场景类型,需指定唯一字符串,
		 * 建议写法: 
		 * 	ROOM_SCENE_TYPE:String  = 	"com.boyaa.pet.module.room.RoomManager";
		 * 并用静态常量存储 , 如:
		 * 			retutn ROOM_SCENE_TYPE;
		 */
		public function get sceneType():String
		{
			throw new Error("This hasn'st override");
			return "";
		}
		
	}
	
}