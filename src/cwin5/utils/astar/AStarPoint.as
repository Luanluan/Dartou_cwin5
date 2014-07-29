package cwin5.utils.astar 
{
	/**
	 * A*地图点
	 * @author cwin5
	 */
	public class AStarPoint
	{
		private var _x:int = 0;			//所在地图位置
		private var _y:int = 0;			//所在地图位置
		
		private var _f:int = 0;			// 总距离值
		private var _g:int = 0;			// 与起点距离值
		private var _h:int = 0;			// 与终点距离值
		
		private var _parent:AStarPoint = null;	// 父级点
		
		private var _isBarrier:Boolean = false;	// 是否为障碍物
		private var _isClose:Boolean = false;	// 是否关闭
		
		/**
		 * 构造
		 * @param	x
		 * @param	y
		 * @param	isBarrier	是否为障碍物
		 */
		public function AStarPoint(x:int, y:int, isBarrier:Boolean) 
		{
			_x = x;
			_y = y;
			_isClose = _isBarrier = isBarrier;
		}
		
		/**
		 * 计算
		 * @param	len			当前点到本点的距离
		 * @param	curPoint	当前点
		 * @param	endPoint	目标点
		 * @return	如果目标点为本点.则返回true,并将父级点设为当前点
		 */
		public function calculate(len:int, curPoint:AStarPoint , endPoint:AStarPoint):Boolean
		{
			if (endPoint == this)
			{
				_parent = curPoint;
				return true;
			}
			
			var tg:int = curPoint.g + len;
			if (_g == 0 || tg < _g)	// 如果新的G点小于旧G点,则更新G点,并设当前点为父点
			{
				_g = tg;
				_parent = curPoint;
			}
			if (_h == 0)	// 计算与目标点的距离
			{
				_h = (Math.abs(endPoint.x - _x) + Math.abs(endPoint.y - _y)) * 10;
			}
			_f = _g + _h;
			
			return false;
		}
		
		/**
		 * 将F,G,H值清零,清除父级点
		 */
		public function setZero():void
		{
			_f = _g = _h = 0;
			_parent = null;
			if (!_isBarrier)
				_isClose = false;
		}
		
		/**
		 * 所在地图位置X
		 */
		public function get x():int { return _x; }
		
		/**
		 * 所在地图位置Y
		 */
		public function get y():int { return _y; }
		
		/**
		 * 总距离值
		 */
		public function get f():int { return _f; }
		
		/**
		 * 与起点距离值
		 */
		public function get g():int { return _g; }
		
		/**
		 * 与终点距离值
		 */
		public function get h():int { return _h; }
		
		/**
		 * 父级点
		 */
		public function get parent():AStarPoint { return _parent; }
		
		/**
		 * 是否关闭
		 */
		public function get isClose():Boolean { return _isClose; }
		public function set isClose(value:Boolean):void 
		{
			_isClose = value;
		}
		
		/**
		 * 是否为障碍物
		 */
		public function get isBarrier():Boolean { return _isBarrier; }
		
	}

}