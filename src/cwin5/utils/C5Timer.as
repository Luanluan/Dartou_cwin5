package cwin5.utils 
{
	import com.greensock.TweenLite;
	import flash.utils.Dictionary;
	
	/**
	 * 计时器,基于TweenLite的计时方式,减少计时偏差
	 * @author cwin5
	 */
	public class C5Timer
	{
		/// tweenLite字典
		private static const DICT:Dictionary = new Dictionary();
		
		
		/**
		 * 添加计时,如果已有回调则覆盖
		 * @param	delay			延时,以秒为单位
		 * @param	callBack		回调函数
		 * @param	params			参数
		 */
		public static function add(delay:Number, callBack:Function, ...params):void
		{
			if (DICT[callBack])
			{
				DICT[callBack].kill();
			}
			DICT[callBack] = TweenLite.to(C5Timer , delay, 
													{ onComplete:complete , 
													onCompleteParams:[callBack , params] } );
		}
		
		public static function addNoOverride(delay:Number, callBack:Function, ...params):TweenLite
		{
			return TweenLite.to(C5Timer , delay, { onComplete:callBack , onCompleteParams:params } );
		}
		
		public static function addValueChange(delay:Number , obj:Object , propretyName:String , value:* ):TweenLite
		{
			return TweenLite.to(C5Timer , delay , { onComplete:onValueChange , onCompleteParams: [obj , propretyName , value] } );
		}
		
		private static function onValueChange(obj:Object , propretyName:String , value:*):void
		{
			obj[propretyName] = value;
		}
		
		public static function addNumChange(delay:Number , obj:Object , propretyName:String , value:* ):TweenLite
		{
			return TweenLite.to(C5Timer , delay , { onComplete:onNumChange , onCompleteParams: [obj , propretyName , value] } );
		}
		
		static private function onNumChange(obj:Object , propretyName:String , value:*):void
		{
			obj[propretyName] += value;
		}
		
		/**
		 * 根据帧频计算
		 * @param	frames
		 * @param	callBack
		 * @param	...params
		 */
		public static function addByFrames(frames:Number , callBack:Function, ...params):void
		{
			if (DICT[callBack])
			{
				DICT[callBack].kill();
			}
			DICT[callBack] = TweenLite.to(C5Timer , frames, 
													{ onComplete:complete , useFrames:true,
													onCompleteParams:[callBack , params] } );
		}
		
		/**
		 * 移除一个计时
		 * @param	callBack
		 */
		public static function remove(callBack:Function):void
		{
			if (DICT[callBack])
			{
				DICT[callBack].kill();
				deleteFunc(callBack);
			}
		}
		
		/// 完成
		private static function complete(callBack:Function, params:Array):void
		{
			deleteFunc(callBack);
			callBack.apply(null, params);
		}
		
		/// 删除函数
		private static function deleteFunc(callBack:Function):void
		{
			delete DICT[callBack];
		}
		
	}

}