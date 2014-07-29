package cwin5.framework.face 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 进入场景完成
	 * @eventType cwin5.events.SceneEvent.ENTER_SCENE_COMPLETE
	 */
	[Event(name = "EnterSceneComplete", type = "cwin5.events.SceneEvent")] 
	
	/**
	 * 移除场景完成
	 * @eventType cwin5.events.SceneEvent.REMOVE_SCENE_COMPLETE
	 */
	[Event(name="RemoveSceneComplete", type="cwin5.events.SceneEvent")] 
	
	/**
	 * 场景接口
	 * 用于场景切换
	 * 创建后需要场景管理器注册
	 * @author cwin5
	 */
	public interface IScene extends IEventDispatcher
	{
		/**
		 * 进入场景
		 * @param	arg		为自定义参数
		 */
		function enterScene(...arg):void;
		
		/**
		 * 移除场景
		 */
		function removeScene():void;
		
		/**
		 * 场景类型,需指定唯一字符串,
		 * 建议写法: 
		 * 	ROOM_SCENE_TYPE:String  = 	"com.boyaa.pet.module.room.RoomManager";
		 * 并用静态常量存储 , 如:
		 * public static ROOM_SCENE_TYPE:String  = 	"com.boyaa.pet.module.room.RoomManager";
		 * 			retutn ROOM_SCENE_TYPE;
		 */
		function get sceneType():String;
		
	}
	
}