package cwin5.control 
{
	import cwin5.utils.C5Utils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	/**
	 * 层管理器
	 * @author cwin5
	 */
	public class LayerManager
	{
		
		private static var _layerMap:Dictionary = new Dictionary();
		private static var _containerMap:Dictionary = new Dictionary();
		private static var _typeMap:Dictionary = new Dictionary();
		
		/**
		 * 初始化, 传入stage对象和类型数据
		 * 会根据数据排序生成列表
		 * 类型数据都为字符串,如:
		 * [LayerType.LOGIN,		// 放在最下
		 *  LayerType.GAME,
		 * 	LayerType.ROOM]			// 放在最上
		 * @param	stage
		 */
		public static function init(stage:Sprite , typeArr:Array):void
		{
			var container:Sprite = new Sprite();
			_typeMap[container] = typeArr;
			for (var i:int = 0; i < typeArr.length; i++)
			{
				var type:String = typeArr[i];
				if (_layerMap[type])
					throw new Error("This type has layer!");
				_layerMap[type] = new Sprite();
				_containerMap[type] = container;
				container.addChild(_layerMap[type]);
			}
			stage.addChild(container);
		}
		
		/**
		 * 隱藏層
		 * @param	type
		 */
		public static function hideLayer(type:String):void
		{
			C5Utils.removeFromStage(getLayer(type));
		}
		
		/**
		 * 顯示層
		 * @param	type
		 */
		public static function showLayer(type:String):void
		{
			var container:Sprite = _containerMap[type];
			var typeArr:Array = _typeMap[container];
			if (!typeArr)
				return;
			
			var index:int = typeArr.indexOf(type);
			if (index == -1)	// 不存在
				return;
			
			var layer:Sprite = getLayer(type);
			if (layer)
				container.addChildAt(layer, index);
		}
		
		/**
		 * 获取层
		 * @param	type
		 * @return
		 */
		public static function getLayer(type:String):Sprite
		{
			if (_layerMap[type] == null)
				throw new Error("This type hasn't layer!");
			return _layerMap[type];
		}
		
		/**
		 * 添加到层
		 * @param	type
		 * @param	displayObj
		 */
		public static function addToLayer(type:String , displayObj:DisplayObject):void
		{
			getLayer(type).addChild(displayObj);
		}
		
	}
	
}