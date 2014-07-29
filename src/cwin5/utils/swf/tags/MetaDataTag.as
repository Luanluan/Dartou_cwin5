package cwin5.utils.swf.tags
{
	import cwin5.utils.bytes.readStringFromBytes;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class MetaDataTag extends Tag
	{
		protected var _metaData:XML;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get metaData():XML { return _metaData; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function MetaDataTag() 
		{
			_tagCode = TagCodes.METADATA;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			_metaData = new XML( readStringFromBytes( bytes));
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			
			string += _metaData.toXMLString() + "\n\t";
			
			return string;
		}
	}
	
}