package cwin5.utils.word 
{
	
	/**
	 * 关键字过滤
	 * @author cwin5
	 */
	public class WordFilter
	{
		
		/**
		 * 过滤
		 * @param	str
		 * @return
		 */
		public function filter(str:String):String
		{
			return str.replace(_reg , "**");
		}
		
		public function search(str:String):int
		{
			return str.search(_reg);
		}
		
		
		private var _reg:RegExp;
		
		private function init():void
		{
			var str:String = String(xml);
			str = str.replace(/\r/g, "");
			var arr:Array = str.split("\n");
			
			var regStr:String = "";
			//for (var i:int = 0; i < arr.length; i++) 
			//{
				//if (i > 0)
					//regStr += "|" + "(" + arr[i] + ")";
				//else
					//regStr += "(" + arr[i] + ")";
			//}
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (i > 0)
					regStr += "|" + arr[i];
				else
					regStr += arr[i];
			}
			_reg = new RegExp(regStr , "g");
		}
		
		/**
		 * 构造
		 */
		public function WordFilter(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
			init();
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():WordFilter
		{
			if(_instance == null)
			{
				_instance = new WordFilter(new Single());
			}
			return _instance;
		}
		
		private static var _instance:WordFilter = null;
	}
	
}
class Single { }
include "WordLibrary.inc";