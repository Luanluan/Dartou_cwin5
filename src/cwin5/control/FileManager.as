package cwin5.control 
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	/**
	 * 文件管理器
	 * @author cwin5
	 */
	public class FileManager
	{
		private var _fileDict:Dictionary = new Dictionary();
		
		
		/**
		 * 添加文件 , 可复盖
		 * @param	fileName			文件名字
		 * @param	file				文件数据,可为任意数据
		 * @param	directoryName  		目录,默认为根目录
		 */
		public function addFile(fileName:String , file:Object, directoryName:String = "root"):void
		{
			var directory:Dictionary = getDirectory(directoryName);
			if (directory[fileName])
				throw new Error("This has File!" + "," +  fileName + "," + directoryName);
			directory[fileName] = file;
		}
		
		/**
		 * 删除文件
		 * @param	fileName			文件名字
		 * @param	directoryName  		目录,默认为根目录
		 */
		public function delFile(fileName:String ,directoryName:String = "root"):void
		{
			var directory:Dictionary = getDirectory(directoryName);
			delete directory[fileName];
		}
		
		/**
		 * 获取文件
		 * @param	fileName			文件名字
		 * @param	directoryName  		目录,默认为根目录
		 * @return
		 */
		public function getFile(fileName:String , directoryName:String = "root"):Object
		{
			var directory:Dictionary = getDirectory(directoryName);
			var file:Object = directory[fileName];
			return file;
		}
		
		/// 获取目录
		private function getDirectory(directoryName:String):Dictionary
		{
			if (_fileDict[directoryName] == null)
				_fileDict[directoryName] = new Dictionary();
			return _fileDict[directoryName];
		}
		
		
		/**
		 * 构造
		 */
		public function FileManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():FileManager
		{
			if(_instance == null)
			{
				_instance = new FileManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:FileManager = null;
	}
	
}
class Single{}