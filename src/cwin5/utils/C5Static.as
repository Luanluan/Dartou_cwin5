package cwin5.utils 
{
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	/**
	 * 静态数据
	 * @author cwin5
	 */
	public class C5Static
	{
		/// 原点
		public static const ORIGIN:Point = new Point(0, 0);
		
		/// 灰色滤镜
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3086000084877014, 0.6093999743461609, 0.0820000022649765, 0, 0, 0.3086000084877014, 0.6093999743461609, 0.0820000022649765, 0, 0, 0.3086000084877014, 0.6093999743461609, 0.0820000022649765, 0, 0, 0, 0, 0, 1, 0]);
		
		/// 空滤镜
		public static const NULL_FILTER:ColorMatrixFilter = new ColorMatrixFilter();
		
	}

}