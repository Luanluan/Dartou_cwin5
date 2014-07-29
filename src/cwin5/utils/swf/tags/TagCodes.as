package cwin5.utils.swf.tags
{
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class TagCodes 
	{
		static public const END:uint = 0;
		static public const SHOW_FRAME:uint = 1;
		static public const DEFINE_SHAPE:uint = 2;
		static public const PLACE_OBJECT:uint = 4;
		static public const REMOVE_OBJECT:uint = 5;
		static public const DEFINE_BITS:uint = 6;
		static public const DEFINE_BUTTON:uint = 7;
		static public const JPEG_TABLES:uint = 8;
		static public const SET_BACKGROUND_COLOR:uint = 9;
		static public const DEFINE_FONT:uint = 10;
		static public const DEFINE_TEXT:uint = 11;
		static public const DO_ACTION:uint = 12;
		static public const DEFINE_FONT_INFO:uint = 13;
		static public const DEFINE_SOUND:uint = 14;
		static public const START_SOUND:uint = 15;
		static public const DEFINE_BUTTON_SOUND:uint = 17;
		static public const SOUND_STREAM_HEAD:uint = 18;
		static public const SOUND_STREAM_BLOCK:uint = 19;
		static public const DEFINE_BITS_LOSSLESS:uint = 20;
		static public const DEFINE_BITS_JPEG2:uint = 21;
		static public const DEFINE_SHAPE2:uint = 22;
		static public const DEFINE_BUTTON_CXFORM:uint = 23;
		static public const PROTECT:uint = 24;
		static public const PLACE_OBJECT2:uint = 26;
		static public const REMOVE_OBJECT2:uint = 28;
		static public const DEFINE_SHAPE3:uint = 32;
		static public const DEFINE_TEXT2:uint = 33;
		static public const DEFINE_BUTTON2:uint = 34;
		static public const DEFINE_BITS_JPEG3:uint = 35;
		static public const DEFINE_BITS_LOSSLESS2:uint = 36;
		static public const DEFINE_EDIT_TEXT:uint = 37;
		static public const DEFINE_SPRITE:uint = 39;
		static public const FRAME_LABEL:uint = 43;
		static public const SOUND_STREAM_HEAD2:uint = 45;
		static public const DEFINE_MORPH_SHAPE:uint = 46;
		static public const DEFINE_FONT2:uint = 48;
		static public const EXPORT_ASSETS:uint = 56;
		static public const IMPORT_ASSETS:uint = 57;
		static public const ENABLE_DEBUGGER:uint = 58;
		static public const DO_INIT_ACTION:uint = 59;
		static public const DEFINE_VIDEO_STREAM:uint = 60;
		static public const VIDEO_FRAME:uint = 61;
		static public const DEFINE_FONT_INFO2:uint = 62;
		static public const ENABLE_DEBUGGER2:uint = 64;
		static public const SCRIPT_LIMITS:uint = 65;
		static public const SET_TAB_INDEX:uint = 66;
		static public const FILE_ATTRIBUTES:uint = 69;
		static public const PLACE_OBJECT3:uint = 70;
		static public const IMPORT_ASSETS2:uint = 71;
		static public const DEFINE_FONT_ALIGN_ZONES:uint = 73;
		static public const CSM_TEXT_SETTINGS:uint = 74;
		static public const DEFINE_FONT3:uint = 75;
		static public const SYMBOL_CLASS:uint = 76;
		static public const METADATA:uint = 77;
		static public const DEFINE_SCALING_GRID:uint = 78;
		static public const DO_ABC:uint = 82;
		static public const DEFINE_SHAPE4:uint = 83;
		static public const DEFINE_MORPH_SHAPE2:uint = 84;
		static public const DEFINE_SCENE_AND_FRAME_LABEL_DATA:uint = 86;
		static public const DEFINE_BINARY_DATA:uint = 87;
		static public const DEFINE_FONT_NAME:uint = 88;
		static public const START_SOUND2:uint = 89;

		//=========================================================
		//	Constructor
		//=========================================================
		
		public function TagCodes() 
		{
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		static public function tagCodeToString( code:uint):String
		{
			var string:String;
			
			switch( code)
			{
				case END: string = "End"; break;
				case SHOW_FRAME: string = "ShowFrame"; break;
				case DEFINE_SHAPE: string = "DefineShape"; break;
				case PLACE_OBJECT: string = "PlaceObject"; break;
				case REMOVE_OBJECT: string = "RemoveObject"; break;
				case DEFINE_BITS: string = "DefineBits"; break;
				case DEFINE_BUTTON: string = "DefineButton"; break;
				case JPEG_TABLES: string = "JPEGTables"; break;
				case SET_BACKGROUND_COLOR: string = "SetBackgroundColor"; break;
				case DEFINE_FONT: string = "DefineFont"; break;
				case DEFINE_TEXT: string = "DefineText"; break;
				case DO_ACTION: string = "DoAction"; break;
				case DEFINE_FONT_INFO: string = "DefineFontInfo"; break;
				case DEFINE_SOUND: string = "DefineSound"; break;
				case START_SOUND: string = "StartSound"; break;
				case DEFINE_BUTTON_SOUND: string = "DefineButtonSound"; break;
				case SOUND_STREAM_HEAD: string = "SoundStreamHead"; break;
				case SOUND_STREAM_BLOCK: string = "SoundStreamBlock"; break;
				case DEFINE_BITS_LOSSLESS: string = "DefineBitsLossless"; break;
				case DEFINE_BITS_JPEG2: string = "DefineBitsJPEG2"; break;
				case DEFINE_SHAPE2: string = "DefineShape2"; break;
				case DEFINE_BUTTON_CXFORM: string = "DefineButtonCxform"; break;
				case PROTECT: string = "Protect"; break;
				case PLACE_OBJECT2: string = "PlaceObject2"; break;
				case REMOVE_OBJECT2: string = "RemoveObject2"; break;
				case DEFINE_SHAPE3: string = "DefineShape3"; break;
				case DEFINE_TEXT2: string = "DefineText2"; break;
				case DEFINE_BUTTON2: string = "DefineButton2"; break;
				case DEFINE_BITS_JPEG3: string = "DefineBitsJPEG3"; break;
				case DEFINE_BITS_LOSSLESS2: string = "DefineBitsLossless2"; break;
				case DEFINE_EDIT_TEXT: string = "DefineEditText"; break;
				case DEFINE_SPRITE: string = "DefineSprite"; break;
				case FRAME_LABEL: string = "FrameLabel"; break;
				case SOUND_STREAM_HEAD2: string = "SoundStreamHead2"; break;
				case DEFINE_MORPH_SHAPE: string = "DefineMorphShape"; break;
				case DEFINE_FONT2: string = "DefineFont2"; break;
				case EXPORT_ASSETS: string = "ExportAssets"; break;
				case IMPORT_ASSETS: string = "ImportAssets"; break;
				case ENABLE_DEBUGGER: string = "EnableDebugger"; break;
				case DO_INIT_ACTION: string = "DoInitAction"; break;
				case DEFINE_VIDEO_STREAM: string = "DefineVideoStream"; break;
				case VIDEO_FRAME: string = "VideoFrame"; break;
				case DEFINE_FONT_INFO2: string = "DefineFontInfo2"; break;
				case ENABLE_DEBUGGER2: string = "EnableDebugger2"; break;
				case SCRIPT_LIMITS: string = "ScriptLimits"; break;
				case SET_TAB_INDEX: string = "SetTabIndex"; break;
				case FILE_ATTRIBUTES: string = "FileAttributes"; break;
				case PLACE_OBJECT3: string = "PlaceObject3"; break;
				case IMPORT_ASSETS2: string = "ImportAssets2"; break;
				case DEFINE_FONT_ALIGN_ZONES: string = "DefineFontAlignZones"; break;
				case CSM_TEXT_SETTINGS: string = "CSMTextSettings"; break;
				case DEFINE_FONT3: string = "DefineFont3"; break;
				case SYMBOL_CLASS: string = "SymbolClass"; break;
				case METADATA: string = "Metadata"; break;
				case DEFINE_SCALING_GRID: string = "DefineScalingGrid"; break;
				case DO_ABC: string = "DoABC"; break;
				case DEFINE_SHAPE4: string = "DefineShape4"; break;
				case DEFINE_MORPH_SHAPE2: string = "DefineMorphShape2"; break;
				case DEFINE_SCENE_AND_FRAME_LABEL_DATA: string = "DefineSceneAndFrameLabelData"; break;
				case DEFINE_BINARY_DATA: string = "DefineBinaryData"; break;
				case DEFINE_FONT_NAME: string = "DefineFontName"; break;
				case START_SOUND2: string = "StartSound2"; break;
				default: string = "UNKNOWN";
			}
			return string;
		}
	}
}