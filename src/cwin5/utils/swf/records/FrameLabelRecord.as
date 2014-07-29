package cwin5.utils.swf.records
{
	import cwin5.utils.bytes.readEncodedU32;
	import cwin5.utils.bytes.readStringFromBytes;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class FrameLabelRecord 
	{
		protected var _frame:uint;
		protected var _label:String;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get label():String { return _label; }
		
		public function get frame():uint { return _frame; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function FrameLabelRecord() 
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void 
		{
			_frame = readEncodedU32( bytes);
			_label = readStringFromBytes( bytes);
		}
	}
	
}