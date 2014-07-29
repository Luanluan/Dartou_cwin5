package cwin5.utils.bytes
{
	
	/**
	* Reads length bits from the input uint and extends the left most bit
	* to fill the remaining left bits of a full uint.
	* For example:
	* 		input bits:  1001
	* 		output bits: 11111111111111111111111111111001
	* 
	* 		input bits:  001011
	* 		output bits: 00000000000000000000000000001011
	* @param	input
	* @param	length
	* @return
	* @author Ben Hopkins
	*/
	public function extendSign( input:uint, length:uint):uint
	{
		var signMask:uint = uint(1) << length - 1;
		var extendMask:uint = uint.MAX_VALUE << length;
		var sign:uint = (input & signMask) >> length - 1;
		var result:uint = input & ~extendMask;
		
		if ( sign == 1)
		{
			result |= extendMask;
		}
		
		return result;
	}
	
}