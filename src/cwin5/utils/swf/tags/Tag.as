package cwin5.utils.swf.tags
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class Tag 
	{
		protected var _bytes:ByteArray;
		protected var _tagCode:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get tagCode():uint { return _tagCode; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function Tag() 
		{
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		protected function _parseBytes( bytes:ByteArray):void
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray, header:TagHeader):void
		{
			_tagCode = header.tagCode;
			_bytes = new ByteArray();
			_bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.readBytes( _bytes, 0, header.tagLength);
			_parseBytes( _bytes);
		}
		
		public function toString():String
		{
			return "[" + _tagCode + "] - " + TagCodes.tagCodeToString( _tagCode);
		}
	}
	
}