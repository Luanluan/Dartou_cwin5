package cwin5.events 
{
	import cwin5.framework.face.IScene;
	import flash.events.Event;
	
	/**
	 * 场景事件
	 * @author cwin5
	 */
	public class SceneEvent extends Event 
	{
		/**
		 * 进入场景完成
		 */
		public static const ENTER_SCENE_COMPLETE:String = "cwin5.events.EnterSceneComplete";
		
		/**
		 * 移除场景完成
		 */
		public static const REMOVE_SCENE_COMPLETE:String = "cwin5.events.RemoveSceneComplete";
		
		
		// 参数
		private var _scene:IScene = null;
		
		/**
		 * 构造
		 * @param	type
		 * @param	param
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function SceneEvent(type:String, scene:IScene = null , bubbles:Boolean=false, cancelable:Boolean=false) 
		
		{
			_scene = scene;
			super(type, bubbles, cancelable);
		} 
		
		/**
		 * 克隆
		 * @return
		 */
		public override function clone():Event 
		{ 
			return new SceneEvent(type, scene , bubbles, cancelable);
		} 
		
		/**
		 * 转为文本
		 * @return
		 */
		public override function toString():String 
		{ 
			return formatToString("SceneEvent", "scene" , "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * 参数
		 */
		public function get scene():IScene { return _scene; }
		
	}
	
}