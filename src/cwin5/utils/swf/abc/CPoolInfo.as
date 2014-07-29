package cwin5.utils.swf.abc
{
	import cwin5.utils.bytes.readEncodedS32;
	import cwin5.utils.bytes.readEncodedU32;
	import cwin5.utils.swf.abc.multinames.AbstractMultiname;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class CPoolInfo 
	{
		protected var _ints:Array;
		protected var _uints:Array;
		protected var _doubles:Array;
		protected var _strings:Array;
		protected var _namespaces:Array;
		protected var _namespaceSets:Array;
		protected var _multinames:Array;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get numberOfInts():uint { return _ints.length; }
		
		public function get numberOfUints():uint { return _uints.length; }
		
		public function get numberOfDoubles():uint { return _doubles.length; }
		
		public function get numberOfStrings():uint { return _strings.length; }
		
		public function get numberOfNamespaces():uint { return _namespaces.length; }
		
		public function get numberOfNamespaceSets():uint { return _namespaceSets.length; }
		
		public function get numberOfMultinames():uint { return _multinames.length; }
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function CPoolInfo() 
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			_ints = new Array();
			_uints = new Array();
			_doubles = new Array();
			_strings = new Array();
			_namespaces = new Array();
			_namespaceSets = new Array();
			_multinames = new Array();
			
			var intCount:uint = readEncodedU32( bytes);
			_ints.push( 0);
			for ( var i:uint = 1; i < intCount; i++)
			{
				_ints.push( readEncodedS32( bytes));
			}
			
			var uintCount:uint = readEncodedU32( bytes);
			_uints.push( 0);
			for ( i = 1; i < uintCount; i++)
			{
				_uints.push( readEncodedU32( bytes));
			}
			
			var doubleCount:uint = readEncodedU32( bytes);
			_doubles.push( 0);
			for ( i = 1; i < doubleCount; i++)
			{
				_doubles.push( bytes.readDouble());
			}
			
			var stringCount:uint = readEncodedU32( bytes);
			_strings.push( "");
			var stringLength:uint;
			for ( i = 1; i < stringCount; i++)
			{
				stringLength = readEncodedU32( bytes);
				_strings.push( bytes.readUTFBytes( stringLength));
			}
			
			var namespaceCount:uint = readEncodedU32( bytes);
			var ns:NamespaceInfo = new NamespaceInfo( this);
			_namespaces.push( ns);
			for ( i = 1; i < namespaceCount; i++)
			{
				ns = new NamespaceInfo( this);
				ns.readFrom( bytes);
				_namespaces.push( ns);
			}
			
			var namespaceSetCount:uint = readEncodedU32( bytes);
			var nsSet:NamespaceSet = new NamespaceSet( this);
			_namespaceSets.push( nsSet);
			for ( i = 1; i < namespaceSetCount; i++)
			{
				nsSet = new NamespaceSet( this);
				nsSet.readFrom( bytes);
				_namespaceSets.push( nsSet);
			}
			
			var multinameCount:uint = readEncodedU32( bytes);
			var multinameInfo:MultinameInfo = new MultinameInfo( this);
			_multinames.push( multinameInfo.data);
			for ( i = 1; i < multinameCount; i++)
			{
				multinameInfo = new MultinameInfo( this);
				multinameInfo.readFrom( bytes);
				_multinames.push( multinameInfo.data);
			}
		}
		
		public function getIntAt( index:uint):int
		{
			return _ints[ index];
		}
		
		public function getUintAt( index:uint):uint
		{
			return _uints[ index];
		}
		
		public function getDoubleAt( index:uint):Number
		{
			return _doubles[ index];
		}
		
		public function getStringAt( index:uint):String
		{
			return _strings[ index];
		}
		
		public function getNamespaceAt( index:uint):NamespaceInfo
		{
			return _namespaces[ index];
		}
		
		public function getNamespaceSetAt( index:uint):NamespaceSet
		{
			return _namespaceSets[ index];
		}
		
		public function getMultinameAt( index:uint):AbstractMultiname
		{
			return _multinames[ index];
		}
		
		public function toString():String
		{
			var i:int
			var string:String = "ints:\n\t";
			//for ( var i:uint = 0; i < _ints.length; i++)
			//{
				//string += _ints[i] + "\n\t";
			//}
			//
			//string += "\nuints:\n\t";
			//for ( i = 0; i < _uints.length; i++)
			//{
				//string += _uints[i] + "\n\t";
			//}
			//
			//string += "\ndoubles:\n\t";
			//for ( i = 0; i < _doubles.length; i++)
			//{
				//string += _doubles[i] + "\n\t";
			//}
			
			string += "\nstrings:\n\t";
			for ( i = 0; i < _strings.length; i++)
			{
				string += _strings[i] + "\n\t";
			}
			
			//string += "\nnamespaces:\n\t";
			//for ( i = 0; i < _namespaces.length; i++)
			//{
				//string += _namespaces[i] + "\n\t";
			//}
			//
			//string += "\nnamespace sets:\n\t";
			//for ( i = 0; i < _namespaceSets.length; i++)
			//{
				//string += _namespaceSets[i] + "\n\t";
			//}
			//
			//string += "\nmultinames:\n\t";
			//for ( i = 0; i < _multinames.length; i++)
			//{
				//string += _multinames[i] + "\n\t";
			//}
			
			return string;
		}
	}
	
}