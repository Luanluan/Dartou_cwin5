package cwin5.framework 
{
	import cwin5.events.SceneEvent;
	import cwin5.framework.face.IModule;
	import cwin5.utils.C5Utils;
	import flash.utils.Dictionary;
	import cwin5.framework.face.IScene;
	
	/**
	 * 场景管理器
	 * @author cwin5
	 */
	public class SceneManager
	{
		
		// 当前场景
		private var _currentScene:IScene = null;
		
		// 下一个场景
		private var _nextScene:IScene = null;
		
		// 场景字典
		private var _dict:Dictionary = new Dictionary();
		
		/// 模块列表
		private var _moduleList:Array = [];
		
		/**
		 * 注册模块
		 * @param	module
		 */
		public function regModule(module:IModule):void
		{
			C5Utils.addElement(_moduleList , module);
		}
		
		/**
		 * 移除模块
		 * @param	module
		 */
		public function delModule(module:IModule):void
		{
			C5Utils.removeElement(_moduleList , module);
		}
		
		/**
		 * 销毁模块
		 * @param	sceneType	场景类型
		 */
		private function destroyModule(sceneType:String):void
		{
			for (var i:int = 0; i < _moduleList.length; i++) 
			{
				var module:IModule = _moduleList[i];
				if (module.remove(sceneType))
				{
					_moduleList.splice(i , 1);
					i--;
				}
			}
		}
		
		/**
		 * 注册场景
		 * @param	scene
		 */
		public function regScene(scene:IScene):void
		{
			if (_dict[scene.sceneType] != null)
				throw new Error("This Type has Scene!");
			_dict[scene.sceneType] = scene;
		}
		
		/**
		 * 删除场景
		 * @param	scene
		 */
		public function delScene(scene:IScene):void
		{
			delete _dict[scene.sceneType];
		}
		
		/**
		 * 进入场景
		 * @param	scene
		 * @param	arg		场景参数
		 */
		public function enterScene(sceneType:String , ...arg):void
		{
			// 取得下一个场景
			_nextScene = _dict[sceneType];
			if (_nextScene == null)
				throw new Error("Can't find this type's Scene!");
			_dict[_nextScene] = arg;
			
			if ( !removeCurrentScene() )	// 如果没有当前场景.直接进入
			{
				enterNextScene();
			}
		}
		
		/**
		 * 移除当前场景
		 */
		public function removeCurrentScene():Boolean
		{
			if (_currentScene)
			{
				_currentScene.addEventListener(SceneEvent.REMOVE_SCENE_COMPLETE , removeSceneComplete);
				_currentScene.removeScene();
				return true;
			}
			return false;
		}
		
		/**
		 * 移除场景完成
		 * @param	e
		 */
		private function removeSceneComplete(e:SceneEvent):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee);
			enterNextScene();
		}
		
		/**
		 * 进入下一个场景
		 */
		private function enterNextScene():void
		{
			if (_nextScene)
			{
				destroyModule(_nextScene.sceneType);
				_currentScene = _nextScene;
				_currentScene.enterScene.apply(null , _dict[_currentScene]);
				delete _dict[_nextScene];
				_nextScene = null;
				
			}
			else
			{
				_currentScene = null;
			}
		}
		
		/**
		 * 是否为当前场景
		 * @param	scene
		 * @return
		 */
		public function isCurrentScene(scene:IScene):Boolean
		{
			return scene == _currentScene;
		}
		
		/**
		 * 当前场景类型
		 */
		public function get curSceneType():String
		{
			if (_currentScene)
				return _currentScene.sceneType;
			return "";
		}
		
		/**
		 * 构造
		 */
		public function SceneManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():SceneManager
		{
			if(_instance == null)
			{
				_instance = new SceneManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:SceneManager = null;
	}
	
}
class Single{}