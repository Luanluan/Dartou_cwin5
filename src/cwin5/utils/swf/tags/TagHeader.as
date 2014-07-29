package cwin5.utils.swf.tags
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class TagHeader 
	{
		protected var _tagCode:uint;
		protected var _tagLength:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get tagCode():uint { return _tagCode; }
		
		public function get tagLength():uint { return _tagLength; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function TagHeader() 
		{
			_tagCode = 0;
			_tagLength = 0;
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			var short:uint = bytes.readUnsignedShort();
			_tagCode = (short >> 6) & 0xffff;
			_tagLength = short & ~(0xffff << 6);
			
			if ( _tagLength == 0x3f)
			{
				_tagLength = bytes.readInt();
			}
		}
	}
	
}