package cwin5.utils.swf.abc
{
	import cwin5.utils.bytes.readEncodedU32;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class NamespaceInfo 
	{
		protected var _kind:uint;
		protected var _nameIndex:uint;
		protected var _constantPool:CPoolInfo;
		
		public function get kind():String { return NamespaceKinds.namespaceKindToString( _kind); }
		
		public function get name():String { return _constantPool.getStringAt( _nameIndex); }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function NamespaceInfo( constantPool:CPoolInfo) 
		{
			_constantPool = constantPool;
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			_kind = bytes.readUnsignedByte();
			_nameIndex = readEncodedU32( bytes);
		}
		
		public function toString():String
		{
			return "name: " + name + ", kind:" + kind;
		}
	}
	
}