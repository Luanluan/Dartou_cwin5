package cwin5.utils.astar 
{
	
	/**
	 * AStar扩展检测接口
	 * 可选择继承DefaultChecker,
	 * 或组合DefaultChecker实现,
	 * 或单独实现
	 * @author cwin5
	 */
	public interface IAStarChecker 
	{
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
		function check(tx:int , ty:int , len:int, testPoint:AStarPoint,
							curPoint:AStarPoint, endPoint:AStarPoint, mapArr:Array):Boolean;
	}
	
}