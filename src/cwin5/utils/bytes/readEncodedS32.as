package cwin5.utils.bytes
{
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public function readEncodedS32( bytes:ByteArray):int 
	{
		var result:uint = bytes.readUnsignedByte();
		
		if (!(result & 0x00000080)) 
		{ 
			return int( extendSign( result, 7)); 
		}
		
		result = (result & 0x0000007f) | (bytes.readUnsignedByte()<<7); 
		if (!(result & 0x00004000)) 
		{ 
			return int( extendSign( result, 14)); 
		} 
		  
		result = (result & 0x00003fff) | (bytes.readUnsignedByte()<<14); 
		if (!(result & 0x00200000)) 
		{ 
			return int( extendSign( result, 21)); 
		} 
		  
		result = (result & 0x001fffff) | (bytes.readUnsignedByte()<<21); 
		if (!(result & 0x10000000)) 
		{
			return int( extendSign( result, 28)); 
		} 
		  
		result = (result & 0x0fffffff) | (bytes.readUnsignedByte() << 28); 
		return int( result);
	}
	
}