package cwin5.utils 
{
	
	/**
	 * 颜色
	 * @author cwin5
	 */
	public class C5Color 
	{
		////////////////////////////////////////////////////////////////////////////////
		/**
		 * 16进制转成COLOR对象,3通道24位
		 * @param	hex
		 * @return
		 */
		public static function hex2Color(hex:uint):C5Color
		{
			var r:uint;
			var g:uint;
			var b:uint;
			r = (0xFF0000 & hex) >> 16;
			g = (0x00FF00 & hex) >> 8;
			b = (0x0000FF & hex);
			return new C5Color(r, g, b);
		}
		
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 红色
		 */
		public var red:uint = 0;
		
		/**
		 * 绿色
		 */
		public var green:uint = 0;
		
		/**
		 * 蓝色
		 */
		public var blue:uint = 0;
		
		/**
		 * 透明通道
		 */
		public var alpha:Number = 1;
		
		/**
		 * 构造
		 */
		public function C5Color(red:uint = 0 , 
								green:uint = 0,
								blue:uint = 0,
								alpha:Number = 1) 
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;
		}
		
		/**
		 * 获取3通道16进制值
		 * @return
		 */
		public function getHex24():uint
		{
			return ((red << 16) | (green << 8) | blue);
		}
		
		/**
		 * 获取4通道16进制值
		 * @return
		 */
		public function getHex32():uint
		{
			var hex24:uint = getHex24();
			var c:Number = hex24 / 0x10000000;
			return (hex24 & 0xffffff) + Math.floor(alpha * c) * 0x10000000;
		}
		
		/**
		 * 应用一个alpha值 , 并返回一个32位通道值
		 * @param	a
		 * @return
		 */
		public function applyAlpha(alpha:Number):uint
		{
			this.alpha = alpha;
			return getHex32();
		}
		
		/**
		 * 克隆
		 * @return
		 */
		public function clone():C5Color
		{
			return new C5Color(red, green, blue, alpha);
		}
		
		/**
		 * 输出文本
		 * @return
		 */
		public function toString():String
		{
			return "red:" + red + "  " + 
					"green:" + green + "  " + 
					"blue:" + blue + "  " +
					"alpha:" + alpha;
		}
		
	}
	
}