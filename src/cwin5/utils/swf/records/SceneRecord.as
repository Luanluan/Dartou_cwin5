package cwin5.utils.swf.records
{
	import cwin5.utils.bytes.readEncodedU32;
	import cwin5.utils.bytes.readStringFromBytes;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class SceneRecord 
	{
		protected var _frameOffset:uint;
		protected var _name:String;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get name():String { return _name; }
		
		public function get frameOffset():uint { return _frameOffset; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function SceneRecord() 
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			_frameOffset = readEncodedU32( bytes);
			_name = readStringFromBytes( bytes);
		}
	}
	
}