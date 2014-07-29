package cwin5.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 位图工具
	 * @author cwin5
	 */
	public class C5BmpUtils
	{
		
		/**
		 * 根据参数获取位图
		 * @param	value
		 * @return
		 */
		public static function getBmp(value:*):Bitmap
		{
			var bmp:Bitmap;
			
			if (value is String)
			{
				var bmpClass:Class = C5System.getClass(value);
				bmp = getBmp(bmpClass);
			}
			else if(value is Class)
			{
				try
				{
					bmp = new value() as Bitmap;
				}
				catch (e:Error)
				{
					bmp = new Bitmap(new value(0, 0) as BitmapData);
				}
			}			
			else if (value is BitmapData)
			{
				bmp = new Bitmap(value);
			}
			else if (value is Bitmap)
			{
				bmp = value;
			}
			
			return bmp;
		}
		
	}

}