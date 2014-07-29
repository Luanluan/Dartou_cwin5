package cwin5.utils.swf.abc.multinames
{
	import cwin5.utils.swf.abc.MultinameInfo;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class RTQNameL extends AbstractMultiname
	{
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function RTQNameL( info:MultinameInfo) 
		{
			super( info);
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function readFrom(bytes:ByteArray):void 
		{
			super.readFrom(bytes);
		}
	}
	
}