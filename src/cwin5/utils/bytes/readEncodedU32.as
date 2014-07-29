package cwin5.utils.bytes
{
	import flash.utils.ByteArray;

	/**
	* ...
	* @author Ben Hopkins
	*/
	public function readEncodedU32( bytes:ByteArray):uint
	{
		var result:uint = bytes.readUnsignedByte();
		
		if (!(result & 0x00000080)) 
		{ 
			return result; 
		}
		
		result = (result & 0x0000007f) | (bytes.readUnsignedByte()<<7); 
		if (!(result & 0x00004000)) 
		{ 
			return result; 
		} 
		  
		result = (result & 0x00003fff) | (bytes.readUnsignedByte()<<14); 
		if (!(result & 0x00200000)) 
		{ 
			return result; 
		} 
		  
		result = (result & 0x001fffff) | (bytes.readUnsignedByte()<<21); 
		if (!(result & 0x10000000)) 
		{
			return result; 
		} 
		  
		result = (result & 0x0fffffff) | (bytes.readUnsignedByte() << 28); 
		return result;
	}
	
}