package cwin5.utils.swf.abc
{
	import cwin5.utils.bytes.readEncodedU32;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class NamespaceSet 
	{
		protected var _namespaceIndices:Array;
		protected var _constantPool:CPoolInfo;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get numberOfNamespaces():uint { return _namespaceIndices.length; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function NamespaceSet( constantPool:CPoolInfo) 
		{
			_namespaceIndices = new Array();
			_constantPool = constantPool;
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			var count:uint = readEncodedU32( bytes);
			var namespaceIndex:uint;
			
			_namespaceIndices = new Array();
			for ( var i:uint = 0; i < count; i++)
			{
				namespaceIndex = readEncodedU32( bytes);
				_namespaceIndices.push( namespaceIndex);
			}
		}
		
		public function getNamespaceAt( index:uint):NamespaceInfo
		{
			return _constantPool.getNamespaceAt( _namespaceIndices[ index]);
		}
		
		public function toString():String
		{
			var string:String = "";
			
			for ( var i:uint = 0; i < _namespaceIndices.length; i++)
			{
				string += getNamespaceAt( i) + "\n";
			}
			
			return string;
		}
	}
	
}