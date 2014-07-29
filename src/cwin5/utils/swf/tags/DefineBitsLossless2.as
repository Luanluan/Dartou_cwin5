package cwin5.utils.swf.tags
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class DefineBitsLossless2 extends Tag
	{
		protected var _charId:uint;
		protected var _bitmapFormat:uint;
		/* TODO: colormap */
		protected var _bitmapData:BitmapData;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function DefineBitsLossless2() 
		{
			_tagCode = TagCodes.DEFINE_BITS_LOSSLESS2;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		protected function _readARGBImageFrom( bytes:ByteArray, width:uint, height:uint):BitmapData
		{
			bytes.uncompress()
			
			var bitmapData:BitmapData = new BitmapData( width, height);
			bitmapData.setPixels( bitmapData.rect, bytes);
			
			return bitmapData;
		}
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			_charId = bytes.readUnsignedShort();
			_bitmapFormat = bytes.readUnsignedByte();
			var width:uint = bytes.readUnsignedShort();
			var height:uint = bytes.readUnsignedShort();
			
			if ( _bitmapFormat == 5)
			{
				var data:ByteArray = new ByteArray();
				bytes.readBytes( data);
				_bitmapData = _readARGBImageFrom( data, width, height);
			}
			else
				throw new Error( "Unsupported format: " + _bitmapFormat);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			var formatString:String = "";
			
			if ( _bitmapFormat == 3) string = "colormap";
			else if ( _bitmapFormat == 5) string = "ARGB";
			
			string += "character ID: " + _charId + "\n\t";
			string += "bitmap format: " + formatString + "\n\t";
			string += "width: " + _bitmapData.width + "\n\t";
			string += "height: " + _bitmapData.height + "\n";
			
			return string;
		}
	}
	
}