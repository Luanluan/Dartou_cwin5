package cwin5.utils 
{
	import flash.geom.Point;
	
	/**
	 * 数学函数 , 角度处理
	 * @author cwin5
	 */
	public class C5Math 
	{
		/**
		 * 旋转坐标
		 * @param	x
		 * @param	y
		 * @param	sin			旋转角度的正弦
		 * @param	cos			旋转角度的余弦
		 * @param	reverse		是否反转
		 */
		public static function rotatePos(x:Number, y:Number, sin:Number, cos:Number, reverse:Boolean):Point
		{
			var result:Point = new Point();
			
			if (reverse)  // 反转
			{
				result.x = x * cos + y * sin;
				result.y = y * cos - x * sin;
			}
			else 		 // 非反转
			{
				result.x = x * cos - y * sin;
				result.y = y * cos + x * sin;
			}
			
			return result;
		}
		
		/**
		 * 获取两点的距离
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return
		 */
		public static function getDistance(x1:Number , y1:Number , x2:Number , y2:Number):Number
		{
			return Point.distance(new Point(x1, y1) , new Point(x2, y2));
		}
		
		/**
		 * 获取弧度
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return
		 */
		public static function getRadian(x1:Number , y1:Number , x2:Number , y2:Number):Number
		{
			var nx:Number = x1 - x2;
			var ny:Number = y1 - y2;
			return Math.atan2(ny , nx);
		}
		
		/**
		 * 从角度获取弧度
		 * @param	angle
		 * @return
		 */
		public static function getRadianByAngle(angle:Number):Number
		{
			return Math.PI * angle / 180;
		}
		
		/**
		 * 获取角度
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return
		 */
		public static function getAngle(x1:Number , y1:Number , x2:Number , y2:Number):Number
		{
			return getAngleByRadian(getRadian(x1, y1, x2, y2));
		}
		
		/**
		 * 获取正数角度
		 * @param	angle
		 * @return
		 */
		public static function getPlusAngle(angle:Number):Number
		{
			angle += 360;
			angle %= 360;
			return angle;
		}
		
		/**
		 * 获取半圆角度
		 * @param	angle
		 * @return
		 */
		public static function getHalfAngle(angle:Number):Number
		{
			angle %= 360;
			if (angle > 180)
			{
				angle -= 360;
			}
			else if (angle < -180)
			{
				angle += 360;
			}
			return angle;
		}
		
		/**
		 * 从弧度中获取角度
		 * @param	radian
		 * @return
		 */
		public static function getAngleByRadian(radian:Number):Number
		{
			return 180 * radian / Math.PI ;
		}
		
		/**
		 * 将数值精确到小数点到几位
		 * @param	value		要精确的数字
		 * @param	bit			位数
		 * @return
		 */
		public static function precision(value:Number , bit:Number = 10):Number
		{
			if ( isNaN(value) )
				return 0;
			return Number(value.toFixed(bit));
		}
		
		/**
		 * 检测一个点是否在圆内
		 * @param	x				要检测点的X
		 * @param	y				要检测点的Y
		 * @param	cx				圆的X
		 * @param	cy				圆的Y
		 * @param	radius			圆的半径
		 * @return
		 */
		public static function isInCircle(x:Number , y :Number , cx:Number , cy:Number , radius:Number):Boolean
		{
			return getDistance(x , y , cx , cy) <= radius;
		}
		
		/**
		 * 检测一个点是否在矩形内
		 * @param	x				要检测点的X
		 * @param	y				要检测点的Y
		 * @param	rx				矩形的X
		 * @param	ry				矩形的Y
		 * @param	width			矩形的宽
		 * @param	height			矩形的高
		 * @return
		 */
		public static function isInRect(x:Number , y:Number , rx:Number , ry:Number , width:Number , height:Number):Boolean
		{
			var dx:Number = Math.abs(x - rx);
			var dy:Number = Math.abs(y - ry);
			return dx <= width /2 && dy <= height / 2;
		}
		
		/**
		 * 动力守恒
		 * 返回一个数组,
		 * 0为速度1变换后的速度
		 * 1为速度2变换后的速度
		 * @param	vx1		速度1
		 * @param	vx2		速度2
		 * @param	mass1	重量1
		 * @param	mass2	重量2
		 * @return
		 */
		public static function momentumConservation(vx1:Number , vx2:Number , mass1:Number , mass2:Number):Array
		{
			var vxTotal:Number = vx1 - vx2;
			vx1 = ( ( mass1 - mass2 ) * vx1 + 
						2 * mass2 * vx2) /
						(mass1 + mass2);
			vx2 = vxTotal + vx1;
			return [vx1 , vx2];
		}
		
		public static function getRandom(s:Number , e:Number):Number
		{
			return Math.random() * (e - s) + s;
		}
		
		
	}
	
}