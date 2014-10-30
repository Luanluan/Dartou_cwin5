package cwin5.control.bitmapMovie 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 
	 * @author luanluan
	 */
	public class BmpFrame
	{
		
		private var _index:int;
		private var _bmpData:BitmapData;
		
		public var x:Number;
		public var y:Number;
		
		/**
		 * BmpMovie的一帧
		 * @param	idx			帧标签
		 * @param	bmpData	
		 */
		public function BmpFrame(idx:int,bmpData:BitmapData) 
		{
			_index = idx;
			if (_index < 1)
				_index = 1;
				
			_bmpData = bmpData;
			
		}
		
		/**
		 * 克隆帧，会克隆位图数据，增加内存开销
		 * @return
		 */
		public function clone():BmpFrame
		{
			var frame:BmpFrame;
			var bmpdata:BitmapData = _bmpData?_bmpData.clone():null;
			frame = new BmpFrame(_index, bmpdata);
			frame.x = x;
			frame.y = y;
			
			return frame;
		}
		
		/**
		 * 释放
		 * @param	gcBmpData 是否释放位图数据
		 */
		public function dispose(gcBmpData:Boolean = false):void
		{
			if (gcBmpData && _bmpData)
			{
				_bmpData.dispose();
			}
			_bmpData = null;
			_index = 0;
		}
		
		/**
		 * 复制帧，只传递位图数据的引用
		 * @return
		 */
		public function copy():BmpFrame
		{
			var frame:BmpFrame = new BmpFrame(_index, _bmpData);
			frame.x = x;
			frame.y = y;
			
			return frame;
		}
		
		/**
		 * 位图数据
		 */
		public function get bitmapData():BitmapData 
		{
			return _bmpData;
		}
		
		/**
		 * 帧索引
		 */
		public function get index():int 
		{
			return _index;
		}
		
	}

}