package cwin5.utils.swf.abc.multinames
{
	import cwin5.utils.bytes.readEncodedU32;
	import cwin5.utils.swf.abc.MultinameInfo;
	import cwin5.utils.swf.abc.NamespaceSet;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class MultinameL extends AbstractMultiname
	{
		protected var _namespaceSetIndex:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get namespaceSet():NamespaceSet { return _info.constantPool.getNamespaceSetAt( _namespaceSetIndex); }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function MultinameL( info:MultinameInfo) 
		{
			super( info);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function readFrom(bytes:ByteArray):void 
		{
			_namespaceSetIndex = readEncodedU32( bytes);
		}
		
		override public function toString():String 
		{
			return super.toString() + "\nnamespace set:" + namespaceSet + "\n";
		}
	}
	
}