package cwin5.utils.swf.tags
{
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class ScriptLimitsTag extends Tag
	{
		protected var _maxRecursionDepth:uint;
		protected var _scriptTimeout:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get scriptTimeout():uint { return _scriptTimeout; }
		
		public function get maxRecursionDepth():uint { return _maxRecursionDepth; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function ScriptLimitsTag() 
		{
			_tagCode = TagCodes.SCRIPT_LIMITS;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			_maxRecursionDepth = bytes.readUnsignedShort();
			_scriptTimeout = bytes.readUnsignedShort();
		}
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			
			string += "max recursion depth: " + maxRecursionDepth + "\n\t";
			string += "script timeout: " + scriptTimeout + "\n\t";
			
			return string;
		}
	}
	
}