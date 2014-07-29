package cwin5.utils.swf.tags
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class DefineBitsLossless extends Tag
	{
		protected var _charID:uint;
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
		
		public function DefineBitsLossless() 
		{
			_tagCode = TagCodes.DEFINE_BITS_LOSSLESS;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		protected function _readRGB24ImageFrom( bytes:ByteArray, width:uint, height:uint):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData( width, height, false);
			bitmapData.setPixels( bitmapData.rect, bytes);
			
			return bitmapData;
		}
		
		protected function _rgb15ToRGB24( rgb15:uint):uint
		{
			var r:Number = (rgb15 >> 10) & 31;
			var g:Number = (rgb15 >> 5) & 31;
			var b:Number = rgb15 & 31;
			
			r = uint((r / 31) * 256);
			g = uint((g / 31) * 256);
			b = uint((b / 31) * 256);
			
			return (r << 16) | (g << 8) | b;
		}
		
		protected function _readRGB15ImageFrom( bytes:ByteArray, width:uint, height:uint):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData( width, height, false);
			
			for ( var y:uint = 0; y < height; y++)
			{
				for ( var x:uint = 0; x < width; x++)
				{
					bitmapData.setPixel( x, y, _rgb15ToRGB24( bytes.readUnsignedShort()));
				}
			}
			return bitmapData;
		}
		
		protected function _readPaletteFrom( bytes:ByteArray, size:uint):Array
		{
			var palette:Array = new Array();
			var r:uint;
			var g:uint;
			var b:uint;
			
			for ( var i:uint = 0; i < size; i++)
			{
				r = bytes.readUnsignedByte();
				g = bytes.readUnsignedByte();
				b = bytes.readUnsignedByte();
				palette.push( (r<<16) | (g<<8) | b);
			}
			
			return palette;
		}
		
		protected function _readColorMapImageFrom( bytes:ByteArray, palette:Array, width:uint, height:uint):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData( width, height, false);
			
			for ( var y:uint = 0; y < height; y++)
			{
				for ( var x:uint = 0; x < width; x++)
				{
					bitmapData.setPixel( x, y, palette[ bytes.readUnsignedByte()]);
				}
			}
			return bitmapData;
		}
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			_charID = bytes.readUnsignedShort();
			_bitmapFormat = bytes.readUnsignedByte();
			var width:uint = bytes.readUnsignedShort();
			var height:uint = bytes.readUnsignedShort();
			var data:ByteArray = new ByteArray();
			
			if ( _bitmapFormat == 5)
			{
				bytes.readBytes( data);
				data.uncompress();
				_bitmapData = _readRGB24ImageFrom( data, width, height);
			}
			else if ( _bitmapFormat == 4)
			{
				bytes.readBytes( data);
				data.uncompress();
				_bitmapData = _readRGB15ImageFrom( data, width, height);
			}
			else if (_bitmapFormat == 3)
			{
				var colorMapSize:uint = bytes.readUnsignedByte() + 1;
				bytes.readBytes( data);
				data.uncompress();
				_bitmapData = _readColorMapImageFrom( data, _readPaletteFrom( data, colorMapSize), width, height);
			}
			else
				throw new Error( "Unsupported bitmap format: " + _bitmapFormat);
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
			
			string += "character ID: " + _charID + "\n\t";
			string += "bitmap format: " + formatString + "\n\t";
			string += "width: " + _bitmapData.width + "\n\t";
			string += "height: " + _bitmapData.height + "\n";
			
			return string;
		}
	}
	
}