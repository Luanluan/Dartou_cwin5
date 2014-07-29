package cwin5.utils.swf.records
{
	import cwin5.utils.bytes.BitReader;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class RectangleRecord extends Rectangle
	{
		public function get xTwips():int {return x * 20; }
		public function set xTwips( value:int):void { x = Number( value) / 20; }
		
		public function get yTwips():int {return y * 20; }
		public function set yTwips( value:int):void { y = Number( value) / 20; }
		
		public function get widthTwips():int {return width * 20; }
		public function set widthTwips( value:int):void { width = Number( value) / 20; }
		
		public function get heightTwips():int {return height * 20; }
		public function set heightTwips( value:int):void { height = Number( value) / 20; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function RectangleRecord( x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			super( x, y, width, height);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================

		public function readFrom( bits:BitReader):void
		{
			var numBits:uint = bits.readUnsigned( 5);
			var xMin:int = bits.readSigned( numBits);
			var xMax:int = bits.readSigned( numBits);
			var yMin:int = bits.readSigned( numBits);
			var yMax:int = bits.readSigned( numBits);
			
			xTwips = xMin;
			yTwips = yMin;
			widthTwips = xMax - xMin;
			heightTwips = yMax - yMin;
		}
		
		public function writeTo( bytes:ByteArray):void
		{
			
		}
	}
	
}