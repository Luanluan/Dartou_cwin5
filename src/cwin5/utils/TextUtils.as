package cwin5.utils 
{
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	/**
	 * 文本工具
	 * @author cwin5
	 */
	public class TextUtils
	{
		/**
		 * 插入文本
		 * @param	textFiled
		 * @param	str
		 */
		public static function insertText(textFiled:Object , str:String):void
		{
			var head:String = textFiled.text.substring(0 , textFiled.selectionBeginIndex);
			var tail:String = textFiled.text.substring(textFiled.selectionEndIndex , textFiled.text.length);
			textFiled.text = head + str + tail;
			var careIndex:int = textFiled.selectionBeginIndex + str.length;
			textFiled.setSelection(careIndex, careIndex);
		}
		
		/**
		 * 退格点击
		 * @param	textFiled
		 */
		public static function backspace(textFiled:Object):void
		{
			var head:String;
			var tail:String;
			var careIndex:int;
			if (textFiled.selectionEndIndex - textFiled.selectionBeginIndex > 0)		/// 有选择文本
			{
				head = textFiled.text.substring(0 , textFiled.selectionBeginIndex);
				tail = textFiled.text.substring(textFiled.selectionEndIndex , textFiled.text.length);
				careIndex = textFiled.selectionBeginIndex;
			}
			else
			{
				if (textFiled.selectionBeginIndex == 0)
					return;
				head = textFiled.text.substring(0 , textFiled.selectionBeginIndex - 1);
				tail = textFiled.text.substring(textFiled.selectionEndIndex , textFiled.text.length);
				careIndex = textFiled.selectionBeginIndex - 1;
			}
			
			textFiled.text = head + tail;
			textFiled.setSelection(careIndex, careIndex);	
		}
		
		/**
		 * 检查长度
		 * 中文等于两个字符
		 * @param	text
		 * @param	maxLen
		 * @return
		 */
		public static function checkTextLen(str:String , maxLen:Number):Boolean
		{
			var pattern:RegExp = /[a-z0-9]/ig;
			
			var wordLen:Number = str.match(pattern).length;
			var totalLen:Number = str.length * 2 - wordLen;
			
			return totalLen <= maxLen;
		}
		
		public static function getDotTxt(num:Number):String
		{
			var flag:Boolean = num < 0;
			num = Math.abs(num);
			var str:String = num.toString();
			
			var dotStr:String = "";
			for (var i:int = str.length - 1; i >= 0; i--) 
			{
				dotStr = str.charAt(i) + dotStr;
				if ((str.length - i) % 3 == 0 && i > 0)
					dotStr = "," + dotStr;
			}
			if (flag)
				dotStr = "-" + dotStr;
			return dotStr;
		}
		
		//把轉成有位數符號的字符串的數字轉成number
		public static function parseDotTxt(str:String):Number
		{
			var arr:Array = str.split(",");
			
			var num:Number = 0;
			for (var i:int = 0; i < arr.length; i++) 
			{
				num = int(arr[i]) + num * 1000;
			}
			return num;
		}
		
		public static function replaceAngle(str:String):String
		{
			str = str.replace(/</g, "&lt;");
			str = str.replace(/>/g, "&gt;");
			return str;
		}
		
		/**
		 * 比较str1是否拼音在str2之前
		 * 一样返回false
		 * @param	str1
		 * @param	str2
		 * @return
		 */
		public static function compareString(str1:String , str2:String):Boolean
		{
			var len:int = str1.length > str2.length ? str2.length : str1.length;
			
			for (var i:int = 0; i < len; i++) 
			{
				var byte1:ByteArray = new ByteArray();
				var byte2:ByteArray = new ByteArray();
				byte1.writeMultiByte(str1.charAt(i), "gb2312");
				byte2.writeMultiByte(str2.charAt(i), "gb2312");
				
				if (byte1[0] < byte2[0])
					return true;

				if (byte1[0] == byte2[0])
				{
					if(byte1[1] < byte2[1])
						return true;
					if (byte1[1] == byte2[1])
						continue;
				}
				return false;
			}
			
			// 相等
			return str1.length < str2.length;
		}
		
		/**
		 * 限制文本输入长度
		 * @param	tf	文本框
		 * @param	maxLength 最大字符长度(中文字符长度为2)
		 */
		public static function  setMaxChar(tf:TextField, maxLength:int):void
		{
			while (!checkTextLen(tf.text, maxLength))
			{
				tf.text = tf.text.substr(0, tf.text.length - 2);
			}
		}
		
	}

}