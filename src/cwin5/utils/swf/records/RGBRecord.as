package cwin5.utils.swf.records
{
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class RGBRecord 
	{
		protected var _red:uint;
		protected var _green:uint;
		protected var _blue:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get red():Number { return _red; }
		
		public function get green():Number { return _green; }
		
		public function get blue():Number { return _blue; }
		
		public function get color():uint { return (_red << 16) | (_green << 8) | _blue; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function RGBRecord() 
		{
			_red = 0;
			_green = 0;
			_blue = 0;
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			_red = bytes.readUnsignedByte();
			_green = bytes.readUnsignedByte();
			_blue = bytes.readUnsignedByte();
		}
	}
	
}