package cwin5.utils.swf.abc
{
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class ABCFile 
	{
		protected var _minorVersion:uint;
		protected var _majorVersion:uint;
		protected var _cPoolInfo:CPoolInfo;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get minorVersion():uint { return _minorVersion; }
		
		public function get majorVersion():uint { return _majorVersion; }
		
		public function get cPoolInfo():CPoolInfo { return _cPoolInfo; }
		
		public function get cPoolInfoString():String { return _cPoolInfo.toString(); }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function ABCFile() 
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		public function readFrom( bytes:ByteArray):void
		{
			_minorVersion = bytes.readUnsignedShort();
			_majorVersion = bytes.readUnsignedShort();
			
			_cPoolInfo = new CPoolInfo();
			_cPoolInfo.readFrom( bytes);
			
		}
	}
	
}