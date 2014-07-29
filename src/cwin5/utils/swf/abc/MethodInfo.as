package cwin5.utils.swf.abc
{
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class MethodInfo 
	{
		protected var _parameterTypeIndices:Array;
		protected var _returnTypeIndex:uint;
		protected var _nameIndex:uint;
		protected var _flags:uint;
		
		
		public function MethodInfo() 
		{
			
		}

		/*
		 *method_info 
			{ 
			 u30 param_count 
			 u30 return_type 
			 u30 param_type[param_count] 
			 u30 name 
			 u8  flags 
			 option_info options 
			 param_info param_names 
			} 
		 */
	}
	
}