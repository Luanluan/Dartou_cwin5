package cwin5.utils.swf.abc
{
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class MultinameKinds 
	{
		static public const QNAME:uint = 0x07;
		static public const QNAMEA:uint = 0x0D;
		static public const RTQNAME:uint = 0x0F; 
		static public const RTQNAMEA:uint = 0x10; 
		static public const RTQNAMEL:uint = 0x11;
		static public const RTQNAMELA:uint = 0x12; 
		static public const MULTINAME:uint = 0x09;
		static public const MULTINAMEA:uint = 0x0E; 
		static public const MULTINAMEL:uint = 0x1B;
		static public const MULTINAMELA:uint = 0x1C; 
		
		//=========================================================
		//	Constructor
		//=========================================================

		public function MultinameKinds() 
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		static public function multinameKindToString( code:uint):String
		{
			var string:String;
			
			switch( code)
			{
				case MultinameKinds.QNAME: string = "QName"; break;
				case MultinameKinds.QNAMEA: string = "QNameA"; break;
				case MultinameKinds.RTQNAME: string = "RTQName"; break;
				case MultinameKinds.RTQNAMEA: string = "RTQNameA"; break;
				case MultinameKinds.RTQNAMEL: string = "RTQNameL"; break;
				case MultinameKinds.RTQNAMELA: string = "RTQNameLA"; break;
				case MultinameKinds.MULTINAME: string = "Multiname"; break;
				case MultinameKinds.MULTINAMEA: string = "MultinameA"; break;
				case MultinameKinds.MULTINAMEL: string = "MultinameL"; break;
				case MultinameKinds.MULTINAMELA: string = "MultinameLA"; break;
			}
			
			return string;
		}
	}
	
}