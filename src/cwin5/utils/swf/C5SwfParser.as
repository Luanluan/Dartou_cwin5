package cwin5.utils.swf 
{
	import cwin5.utils.swf.tags.*;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	/**
	 * SWF文件分析器
	 * @author cwin5
	 */
	public class C5SwfParser
	{
		/**
		 * 构造
		 * @param	fileBytes
		 */
		public function C5SwfParser(fileBytes:ByteArray) 
		{
			parse(fileBytes);
		}
		
		/// 分析分件
		private function parse(fileBytes:ByteArray):void
		{
			
			var headFlag:String = fileBytes.readUTFBytes(3);
			
			if (headFlag != "FWS" && headFlag != "CWS")
			{
				trace("This isn't a swf file!");
				return;
			}
			
			//var compressed:Boolean = ();
			fileBytes.endian = Endian.LITTLE_ENDIAN;;
			
			var version:int = fileBytes.readByte();					// 版本
			var fileLength:uint = fileBytes.readInt();				// 文件大小
			
			fileBytes.readBytes(fileBytes);
			fileBytes.position = 0;
			if (headFlag == "CWS")	// 解压
			{
				fileBytes.uncompress(); 
			}
			
			/// 区域大小
			var rect:Rectangle = getFileRect(fileBytes);
			
			// 帧速, 8位整数, 8位小数
			var fps_float:uint = fileBytes.readUnsignedByte(); 
			var fps_int:uint = fileBytes.readUnsignedByte(); 
			var frameRate:int = fps_int + fps_float / 256 ;		
			
			var totalFrames:uint = fileBytes.readUnsignedShort(); 		// 总帧数
			
			
			trace(headFlag , version , fileLength);
			
			var tags:Array = [];
			// 分析tag
			while (fileBytes.bytesAvailable) 
			{ 
				tags.push(readTag(fileBytes)); 
			}
			
			for (var i:int = 0; i < tags.length; i++) 
			{
				var tag:Tag = tags[i];
				trace(tag);
				//if (tags[i].tagCode == TagCodes.SYMBOL_CLASS)
				//{
					//
					//var classTag:SymbolClassTag = tags[i];
					//trace(classTag.getAllClass());
				//}
			}
			
		}
		
		/// 读取区域大小
		private function getFileRect(fileBytes:ByteArray):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			
			var c : Array = []; 
			var current : uint = fileBytes.readUnsignedByte(); 
			var size : uint = current >> 3; 
			var off : int = 3; 
			for (var i : int = 0; i < 4; i += 1) 
			{ 
				c[i] = current << (32 - off) >> (32 - size); 
				off -= size; 
				while (off < 0) 
				{ 
					current = fileBytes.readUnsignedByte(); 
					c[i] |= off < -8 ? current << (-off - 8) : current >> (-off - 8); 
					off += 8; 
				} 
			} 
			
			rect.width = (c[1] - c[0]) / 20;
			rect.height = (c[3] - c[2]) / 20;
			
			return rect;
			
		}
		
		/// 读取标签
		private function readTag(fileBytes:ByteArray):Tag
		{
			var tagHeader:TagHeader = new TagHeader();
			tagHeader.readFrom(fileBytes);
			
			/// 取得分析器
			var tag:Tag = createNewTag(tagHeader.tagCode);
				
			tag.readFrom(fileBytes, tagHeader);
			return tag;
		}
		
		private function createNewTag( tagCode:uint):Tag
		{
			var tag:Tag;
			
			switch( tagCode)
			{
				case TagCodes.DEFINE_BITS_LOSSLESS: tag = new DefineBitsLossless(); break;
				case TagCodes.DEFINE_BITS_LOSSLESS2: tag = new DefineBitsLossless2(); break;
				case TagCodes.DEFINE_SCENE_AND_FRAME_LABEL_DATA: tag = new DefineSceneAndFrameLabelDataTag(); break;
				case TagCodes.DO_ABC: tag = new DoABCTag(); break;
				case TagCodes.FILE_ATTRIBUTES: tag = new FileAttributesTag(); break;
				case TagCodes.METADATA: tag = new MetaDataTag(); break;
				case TagCodes.SCRIPT_LIMITS: tag = new ScriptLimitsTag(); break;
				//case TagCodes.SET_BACKGROUND_COLOR: tag = new SetBackgroundColorTag(); break;
				case TagCodes.SYMBOL_CLASS: tag = new SymbolClassTag(); break;
				default:
					tag = new Tag();
			}
			
			return tag;
		}
		
		
		
	}

}