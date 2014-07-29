package cwin5.utils.swf.tags
{
	import cwin5.utils.bytes.BitReader;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class FileAttributesTag extends Tag
	{
		protected var _hasMetaData:Boolean;
		protected var _usesAS3:Boolean;
		protected var _usesNetwork:Boolean;
		protected var _suppressCrossDomainCaching:Boolean;
		protected var _swfRelativeUrls:Boolean;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get hasMetaData():Boolean { return _hasMetaData; }
		
		public function get usesAS3():Boolean { return _usesAS3; }
		
		public function get usesNetwork():Boolean { return _usesNetwork; }
		
		public function get suppressCrossDomainCaching():Boolean { return _suppressCrossDomainCaching; }
		
		public function get swfRelativeURLs():Boolean { return _swfRelativeUrls; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function FileAttributesTag() 
		{
			_tagCode = TagCodes.FILE_ATTRIBUTES;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================

		override protected function _parseBytes(bytes:ByteArray):void 
		{	
			var bit:BitReader = new BitReader( bytes);
			bit.readUnsigned( 3);
			
			_hasMetaData = bit.readUnsigned( 1) == 1;
			_usesAS3 = bit.readUnsigned( 1) == 1;
			_suppressCrossDomainCaching = bit.readUnsigned( 1) == 1;
			_swfRelativeUrls = bit.readUnsigned( 1) == 1;
			_usesNetwork = bit.readUnsigned( 1) == 1;
			
			bytes.readUnsignedByte();
			bytes.readUnsignedByte();
			bytes.readUnsignedByte();
		}
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			
			string += "has metadata: " + hasMetaData + "\n\t";
			string += "uses AS3: " + usesAS3 + "\n\t";
			string += "suppress cross domain caching: " + suppressCrossDomainCaching + "\n\t";
			string += "swf relative URLs: " + swfRelativeURLs + "\n\t";
			string += "uses network: " + usesNetwork + "\n";
			
			return string;
		}
	}
}