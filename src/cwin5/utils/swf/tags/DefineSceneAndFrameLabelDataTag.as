package cwin5.utils.swf.tags
{
	import cwin5.utils.bytes.readEncodedU32;
	import cwin5.utils.swf.records.FrameLabelRecord;
	import cwin5.utils.swf.records.SceneRecord;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class DefineSceneAndFrameLabelDataTag extends Tag
	{
		protected var _scenes:Array;
		protected var _labels:Array;
		
		//=========================================================
		//	Constructor
		//=========================================================
		
		public function DefineSceneAndFrameLabelDataTag() 
		{
			_tagCode = TagCodes.DEFINE_SCENE_AND_FRAME_LABEL_DATA;
		}
		
		//=========================================================
		//	Private Methods
		//=========================================================

		override protected function _parseBytes(bytes:ByteArray):void 
		{
			var sceneCount:uint = readEncodedU32( bytes);
			var scene:SceneRecord;
			var label:FrameLabelRecord;
			
			_scenes = new Array();
			_labels = new Array();
			
			for ( var i:uint = 0; i < sceneCount; i++)
			{
				scene = new SceneRecord();
				scene.readFrom( bytes);
				_scenes.push( scene);
			}
			
			var labelCount:uint = readEncodedU32( bytes);
			for ( i = 0; i < labelCount; i++)
			{
				label = new FrameLabelRecord();
				label.readFrom( bytes);
				_labels.push( label);
			}
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		override public function toString():String 
		{
			var string:String = super.toString() + "\n\t";
			var scene:SceneRecord;
			var label:FrameLabelRecord;
			
			string += _scenes.length + " scenes:\n\t";
			for ( var i:uint = 0; i < _scenes.length; i++)
			{
				scene = _scenes[i];
				string += "\tframe offset:" + scene.frameOffset + ", name:" + scene.name + "\n\t";
			}
			
			string += _labels.length + " labels:\n\t\t";
			for ( i = 0; i < _labels.length; i++)
			{
				label = _labels[i];
				string += "frame:" + label.frame + ", label:" + label.label + "\n\t\t";
			}
			
			return string;
		}
	}
	
}