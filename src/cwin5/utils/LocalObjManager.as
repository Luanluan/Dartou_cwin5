package cwin5.utils 
{
	import flash.net.SharedObject;
	
	/**
	 * 本地对象管理器
	 * 建议名称: 
	 * 		com + cwin5 + bomber[项目] + module[模块名] + param[参数名]
	 * 如:
	 * 		com.cwin5.bomber.logon.SelectServer
	 * @author cwin5
	 */
	public class LocalObjManager
	{
		
		/**
		 * 获取参数
		 * @param	valueName
		 * @return
		 */
		public function getValue(valueName:String):Object
		{
			return SharedObject.getLocal(valueName, "/").data;
		}
		
		/**
		 * 更新
		 * @param	valueName
		 * @param	obj
		 */
		public function updateValue(valueName:String , obj:Object):void
		{
			try 
			{
				var so:SharedObject = SharedObject.getLocal(valueName, "/");
				for ( var type:String in obj)
				{
					so.data[type] = obj[type];
				}
				so.flush();
			}
			catch (err:Error)
			{
				
			}
		}
		
		/**
		 * 构造
		 */
		public function LocalObjManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():LocalObjManager
		{
			if(_instance == null)
			{
				_instance = new LocalObjManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:LocalObjManager = null;
	}
	
}
class Single{}