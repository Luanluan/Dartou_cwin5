package cwin5.utils.astar 
{
	
	/**
	 * 默认检测器
	 * @author cwin5
	 */
	public class DefaultChecker implements IAStarChecker
	{
		
		public function DefaultChecker() 
		{
			
		}
		
		/**
		 * 检测
		 * @param	tx			当前寻找偏移X
		 * @param	ty			当前寻找偏移Y
		 * @param	len			testPoint到curPoint的距离
		 * @param	testPoint	要检测的点
		 * @param	curPoint	当前点
		 * @param	endPoint	目标点
		 * @param	mapArr		地图数组
		 * @return	返回true就是为可用点,返回false则为非可用点
		 */
		public function check(tx:int, ty:int, len:int, testPoint:AStarPoint, 
								curPoint:AStarPoint, endPoint:AStarPoint, mapArr:Array):Boolean
		{
			if (len == 10)		// 平移为可走
				return true;
			
			var p1:AStarPoint;
			var p2:AStarPoint;	
			p1 = mapArr[curPoint.x + tx][curPoint.y];
			p2 = mapArr[curPoint.x][curPoint.y + ty];
			if (p1.isBarrier && p2.isBarrier)
				return false;
			/*
			if (tx == -1 && ty == -1)			// 左上角
			{
				p1 = mapArr[curPoint.x - 1][curPoint.y];
				p2 = mapArr[curPoint.x][curPoint.y - 1];
			}
			else if (tx == 1 && ty == -1)		// 右上角
			{
				p1 = mapArr[curPoint.x + 1][curPoint.y];
				p2 = mapArr[curPoint.x][curPoint.y - 1];
			}
			else if (tx == -1 && ty == 1)		// 左下角
			{
				p1 = mapArr[curPoint.x - 1][curPoint.y];
				p2 = mapArr[curPoint.x][curPoint.y + 1];
			}
			else if (tx == 1 && ty == 1)		// 右下角
			{
				p1 = mapArr[curPoint.x + 1][curPoint.y];
				p2 = mapArr[curPoint.x][curPoint.y + 1];
			}
			*/
			return true;
		}
		
	}

}