package cwin5.utils.bytes
{
	import flash.utils.IDataInput;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class BitReader 
	{
		private var _input:IDataInput;
		private var _currentByte:uint;
		private var _bitPosition:uint;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get bitPosition():uint { return _bitPosition; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function BitReader( input:IDataInput) 
		{
			_input = input;
			_bitPosition = 8;		// Setting the _bitPosition to 8 delays reading from the 
									// input until the first time a public read method is called.
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		/**
		 * Reads the next bit from the input data and increments the bit position.
		 * @return
		 */
		private function _readBit():uint
		{
			if ( _bitPosition >= 8)
			{
				_bitPosition = 0;
				_currentByte = _input.readUnsignedByte();
			}
			
			var mask:uint = uint(1) << (7 - _bitPosition);
			var bit:uint = (_currentByte & mask) >> (7 - _bitPosition);
			_bitPosition++;
			
			return bit;
		}
		
		/**
		 * Reads the next bit from the input data and updates the bit position.
		 * The bit buffer is shifted to the left, the read bit is added and 
		 * the resulting value is returned.
		 * @param	buffer
		 * @return				The bitBuffer with the read bit added.
		 */
		private function _readBitToBuffer( buffer:uint):uint
		{
			return (buffer << 1) | _readBit();
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		/**
		 * Reads a variable number of bits from the stream. The maximum
		 * number of bits that can be read is 32 (since the return value
		 * is a 32-bit <code>uint</code>).
		 * @param	length
		 * @return
		 */
		public function readUnsigned( length:uint):uint
		{
			var value:uint = 0;
			
			while ( length > 0)
			{
				value = _readBitToBuffer( value);
				length--;
			}
			
			return value;
		}
		
		public function readSigned( length:uint):int
		{
			var value:uint = readUnsigned( length);
			return int( extendSign( value, length));
		}
	}
	
}