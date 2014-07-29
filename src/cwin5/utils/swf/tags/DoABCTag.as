package cwin5.utils.swf.tags
{
	import cwin5.utils.bytes.readStringFromBytes;
	import cwin5.utils.swf.abc.ABCFile;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class DoABCTag extends Tag
	{
		protected var _flags:uint;
		protected var _name:String;
		protected var _abcBytes:ByteArray;
		protected var _abcFile:ABCFile;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get name():String { return _name; }
		
		public function get abcFile():ABCFile { return _abcFile; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function DoABCTag() 
		{
			_tagCode = TagCodes.DO_ABC;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			_flags = bytes.readUnsignedInt();
			_name = readStringFromBytes( bytes);
			_abcBytes = new ByteArray();
			_abcBytes.endian = Endian.LITTLE_ENDIAN;
			bytes.readBytes( _abcBytes);
			
			_abcFile = new ABCFile();
			_abcFile.readFrom( _abcBytes);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			
			string += "name: " + name + "\n\t";
			string += "size of abc data: " + _abcBytes.length + "\n\t";
			
			string += "ABC:\n\t\t";
			string += "version: " + _abcFile.majorVersion + "." + _abcFile.minorVersion + "\n\t\t";
			string += _abcFile.cPoolInfoString;
			return string;
		}
	}
	
}