package cwin5.utils.swf.tags
{
	import cwin5.utils.swf.records.RGBRecord;	
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class SetBackgroundColorTag extends Tag
	{
		protected var _color:RGBRecord;
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function SetBackgroundColorTag() 
		{
			_tagCode = TagCodes.SET_BACKGROUND_COLOR;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			_color = new RGBRecord();
			_color.readFrom( bytes);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			
			string += "color: " + _color.color.toString( 16) + "\n\t";
			
			return string;
		}
	}
	
}