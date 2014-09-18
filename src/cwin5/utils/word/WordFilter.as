package cwin5.utils.word 
{
	import com.adobe.utils.StringUtil;
	


	/**
	 * 关键字过滤
	 * @author cwin5
	 */
	public class WordFilter
	{
		[Embed(source = "WordLibrary.inc", mimeType = "application/octet-stream")]
		private static const WORDS_LIB:Class;
		
		
		/**
		 * 过滤
		 * @param	str
		 * @return
		 */
		public function filter(str:String):String
		{
			str = trim(str);
			return str.replace(_reg , "**");
		}
		
		public function search(str:String):int
		{
			str = trim(str);
			return str.search(_reg);
		}
		
		private function trim(str:String):String
		{
			var chars:Array = str.split("");
			var result:Array = chars.filter ( function (element:Object, index:int, arr:Array):Boolean { return (String(element).charCodeAt(0) > 32); } );
			return result.join("");
		}
		
		private var _reg:RegExp;
		
		private function init():void
		{
			var str:String = String(new WORDS_LIB());
			str = str.replace(/\r/g, "");
			str = str.replace(/\n/g, "");
			var arr:Array = str.split(",");
			
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
				var word:String = trim(arr[i]);
				if (i > 0)
					regStr += "|" + word;
				else
					regStr += word;
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