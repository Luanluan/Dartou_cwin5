package cwin5.utils 
{
	import cwin5.control.StageProxy;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 移动管理器
	 * @author cwin5
	 */
	public class MoveManager
	{
		private var _list:Array = [];
		private var _pointList:Dictionary = new Dictionary();
		private var _limitList:Dictionary = new Dictionary();
		
		public var localObj:DisplayObject;
		public var wid:Number;
		public var hei:Number;
		
		//public function get scale():Number  { if (!localObj) return 1;  return localObj.scaleX; }
		public function get mouseX():Number {if (!localObj) return StageProxy.stage.mouseX;  return localObj.mouseX; }
		public function get mouseY():Number {if (!localObj) return StageProxy.stage.mouseY;  return localObj.mouseY; }
		
		/**
		 * 添加
		 * @param	obj
		 * @param 	limit	是否限制不可出舞台
		 */
		public function add(obj:DisplayObject , limit:Boolean = false):void
		{
			remove(obj);
			_list.push(obj);
			
			var offsetPoint:Point = new Point();
			offsetPoint.x = obj.x - mouseX;
			offsetPoint.y = obj.y - mouseY;
			
			_pointList[obj] = offsetPoint;
			_limitList[obj] = limit;
			limitObj(obj);
			if (_list.length == 1)
			{
				//C5EnterFrame.addFunction(update);
				StageProxy.stage.addEventListener(MouseEvent.MOUSE_MOVE , update);
			}
		}
		
		/**
		 * 移除
		 * @param	obj
		 */
		public function remove(obj:DisplayObject):void
		{
			if (C5Utils.removeElement(_list, obj))
			{
				delete _pointList[obj];
				delete _limitList[obj];
				if (_list.length == 0)
				{
					//C5EnterFrame.removeFunction(update);
					StageProxy.stage.removeEventListener(MouseEvent.MOUSE_MOVE , update);
				}
			}
		}
		
		/// 刷新
		private function update(e:Event = null):void
		{
			for (var i:int = 0; i < _list.length; i++) 
			{
				var obj:DisplayObject = _list[i];
				var p:Point = _pointList[obj];
				var limit:Boolean = _limitList[obj];
				obj.x = p.x + mouseX;
				obj.y = p.y + mouseY;
				if (limit)
				{
					limitObj(obj);
				}
			}
		}
		
		/// 限制
		private function limitObj(obj:DisplayObject):void
		{
			if (localObj)
			{
				if (obj.x < 0)
					obj.x = 0;
				else if (obj.width + obj.x > wid)
					obj.x = wid- obj.width;
				
				if (obj.y < 0)
					obj.y = 0;
				else if (obj.height + obj.y > hei)
					obj.y = hei - obj.height;	
			}
			else
			{
				if (obj.x < 0)
				{
					if (StageProxy.stage.mouseX <= obj.width)
						obj.x = StageProxy.stage.mouseX + 10;
					else
						obj.x = 0;
				}
				else if (obj.width + obj.x > StageProxy.stage.stageWidth)
				{
					if (StageProxy.stage.mouseX >= StageProxy.stage.stageWidth - obj.width )
						obj.x = StageProxy.stage.mouseX -obj.width;
					else
						obj.x = StageProxy.stage.stageWidth - obj.width;
				}
					
				if (obj.y < 0)
				{
					if (StageProxy.stage.mouseY <= obj.height)
						obj.y = StageProxy.stage.mouseY + 10;
					else
						obj.y = 0;
				}
				else if (obj.height + obj.y > StageProxy.stage.stageHeight)
				{
					if (StageProxy.stage.mouseY >= StageProxy.stage.stageHeight - obj.height )
						obj.y = StageProxy.stage.mouseY -obj.height;
					else
						obj.y = StageProxy.stage.stageHeight - obj.height;
				}	
			}
		}
		
		
		/**
		 * 构造函数
		 */
		public function MoveManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():MoveManager
		{
			if(_instance == null)
			{
				_instance = new MoveManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:MoveManager = null;
	}
	
}
class Single{}