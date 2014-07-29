package cwin5.utils.swf.tags
{
	import cwin5.utils.bytes.readStringFromBytes;
	import flash.display.BlendMode;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class SymbolClassTag extends Tag
	{
		protected var _symbolIDHash:Object;
		protected var _symbolIDs:Array;
		protected var _classes:Array;
		
		//=========================================================
		//	Properties
		//=========================================================
		
		public function get numberOfSymbols():uint { return _symbolIDs.length; }
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function SymbolClassTag() 
		{
			_tagCode = TagCodes.SYMBOL_CLASS;
			_symbolIDs = new Array();
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================
		
		override protected function _parseBytes(bytes:ByteArray):void 
		{
			var length:uint = bytes.readUnsignedShort();
			
			_symbolIDHash = new Object();
			_symbolIDs = new Array();
			_classes = [];
			
			var id:uint;
			var className:String;
			for ( var i:uint = 0; i < length; i++)
			{
				id = bytes.readUnsignedShort();
				className = readStringFromBytes( bytes);
				_symbolIDHash[ id] = className;
				_symbolIDs.push( id);
				_classes.push(className);
			}
		}
		
		public function getID( index:uint):uint
		{
			return _symbolIDs[ index];
		}
		
		public function getClassName( id:uint):String
		{
			return _symbolIDHash[ id];
		}
		
		public function getAllClass():Array
		{
			return _classes;
		}
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			
			var id:uint;
			for ( var i:uint = 0; i < _symbolIDs.length; i++)
			{
				id = _symbolIDs[i];
				string += "id:" + id + ", classname:" + _symbolIDHash[ id] + "\n\t";
			}
			
			return string;
		}
	}
	
}