package cwin5.utils.swf.abc.multinames
{
	import cwin5.utils.bytes.readEncodedU32;
	import cwin5.utils.swf.abc.MultinameInfo;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class RTQName extends AbstractMultiname
	{
		protected var _nameIndex:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get name():String { return _info.constantPool.getStringAt( _nameIndex); }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function RTQName( info:MultinameInfo) 
		{
			super( info);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function readFrom(bytes:ByteArray):void 
		{
			_nameIndex = readEncodedU32( bytes);
		}
		
		override public function toString():String 
		{
			return super.toString() + "\nname:" + name + "\n";
		}
	}
	
}