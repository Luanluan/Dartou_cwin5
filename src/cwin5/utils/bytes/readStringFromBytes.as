package cwin5.utils.bytes
{
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	/**
	 * Reads a null terminated string from a ByteArray.
	 * @param	bytes
	 * @return
	 */
	public function readStringFromBytes( bytes:ByteArray):String 
	{
		var char:uint = 1;
		var output:String = "";
		
		while ( char != 0)
		{
			char = bytes.readUnsignedByte();
			if ( char != 0)
			{
				output += String.fromCharCode( char);
			}
		}
		
		return output;
	}
	
}