package cwin5.utils.astar 
{
	import cwin5.utils.C5Utils;
	
	/**
	 * A*对象
	 * @author cwin5
	 */
	public class AStarer
	{
		private var _mapArr:Array = null;			// 地图
		private var _pointList:Array = null;		// 点列表
		private var _checker:IAStarChecker = null;	// 扩展检测
		
		// 每次查找的偏移值
		private static const FIND_LIST:Array = [[ -1 , -1] , [0 , -1] , [1 , -1],
												[ -1 , 0],              [1 , 0],
												[ -1 , 1],   [0 , 1] , [ 1, 1]];
		
		// 所在位置的路径长度
		private static const FIND_LEN:Array = [14 , 10 , 14,
												10,      10,
												14, 10,  14];
		
		
		/**
		 * 构造
		 */
		public function AStarer(checker:IAStarChecker = null) 
		{
			_checker = checker;
		}
		
		/**
		 * 从常规地图点上生成地图设置地图
		 * @param	mapArr
		 */
		public function setMapByDefault(mapArr:Array):void
		{
			var temp:Array = [];
			var pointList:Array = [];
			for (var i:int = 0; i < mapArr.length; i++)
			{
				var subArr:Array = mapArr[i];
				temp[i] = [];
				for (var j:int = 0; j < subArr.length; j++)
				{
					var point:AStarPoint = new AStarPoint(i , j , Boolean(subArr[j]));
					pointList.push(point);
					temp[i][j] = point;
				}
			}
			setMapByPointList(temp , pointList);
		}
		
		/**
		 * 从转换好的地图点设置地图
		 * @param	mapArr
		 */
		public function setMapByPointList(mapArr:Array , pointList:Array):void
		{
			_mapArr = mapArr;
			_pointList = pointList;
		}
		
		/**
		 * 获取路径
		 * @param	startX
		 * @param	startY
		 * @param	endX
		 * @param	endY
		 * @return
		 */
		public function getPath(startX:int, startY:int, endX:int, endY:int):Array
		{
			if (_mapArr == null || _pointList == null)
				throw new Error("The MapList isn't initialize!");
			
			// 创建变量
			var startPoint:AStarPoint = _mapArr[startX][startY];
			var endPoint:AStarPoint = _mapArr[endX][endY];
			var openList:Array = [];
			var testPoint:AStarPoint;
			
			openList.push(startPoint);
			
			// 遍历地图
			while (openList.length)
			{
				var curPoint:AStarPoint = openList[0];
				
				// 从打开列表中移除当前点
				C5Utils.removeElement(openList, curPoint);
				
				// 并设为关闭
				curPoint.isClose = true;
				
				for (var i:int = 0; i < FIND_LIST.length; i++)
				{
					var len:int = FIND_LEN[i];
					var tx:int = FIND_LIST[i][0];
					var ty:int = FIND_LIST[i][1]
					var ax:int = curPoint.x + tx;
					var ay:int = curPoint.y + ty;
					
					
					// 如果为空或关闭, 继续寻找
					if (_mapArr[ax] == null ||
							(testPoint = _mapArr[ax][ay]) == null || 
							testPoint.isClose)
						continue;
					
					// 如果非可用点
					if (_checker && !_checker.check(tx, ty, len, testPoint, curPoint, endPoint,_mapArr))
						continue;
					
					// 计算点,如果testPoint 等于endPoint,跳出
					if (testPoint.calculate(len , curPoint , endPoint))
						break;
					
					// 添加到打开列表
					addToOpenList(testPoint , openList);
					
				}
			}
			
			// 创建路径
			var path:Array = createPath(endPoint);
			
			// 清空
			clear();
			
			return path;
		}
		
		/**
		 * 创建路径
		 * @param	endPoint		目标点
		 * @return
		 */
		private function createPath(endPoint:AStarPoint):Array
		{
			var path:Array = [];
			for (var point:AStarPoint = endPoint; point != null; point = point.parent)
			{
				path.push( [point.x , point.y] );
			}
			path.reverse();	// 并倒转
			return path;
		}
		
		/// 清除
		private function clear():void
		{
			for (var i:int = 0 ; i < _pointList.length; i++)
			{
				var point:AStarPoint = _pointList[i];
				point.setZero();
			}
		}
		
		/**
		 * 添加到打开列表
		 * @param	testPoint		要添加的点
		 * @param	list			打开列表
		 */
		private function addToOpenList(testPoint:AStarPoint ,list:Array):void
		{
			C5Utils.removeElement(list, testPoint);
			if (list.length == 0)
			{
				list.push(testPoint)
				return;
			}
			for ( var i:int = 0; i < list.length; i++)
			{
				var point:AStarPoint = list[i];
				if (testPoint.f <= point.f)
				{
					list.splice(i, 0, testPoint);
				}
			}
		}
		
		
	}

}