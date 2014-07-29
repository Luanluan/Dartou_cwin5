package cwin5.framework 
{
	import cwin5.utils.C5Utils;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * 数据抽象基类
	 * @author cwin5
	 */
	public class C5Data
	{
		/// 绑定列表
		protected var _bindingList:Dictionary = new Dictionary();
		
		/**
		 * 构造
		 */
		public function C5Data() 
		{
			
		}
		
		/// 调用绑定
		protected function callBinding(valueName:String):void
		{
			var paramName:String;
			var value:* = this[valueName];
			var list:Dictionary = _bindingList[valueName];
			if (list)
			{
				for (var bindingObj:Object in list)
				{
					var paramList:Array = getParamList(list, bindingObj);
					for (var i:int = 0; i < paramList.length; i++) 
					{
						if (paramList[i] is Function)
						{
							paramList[i](valueName , value);
						}
						else
						{
							paramName = paramList[i];
							bindingObj[paramName] = value;
						}
					}
				}
			}
		}
		
		/**
		 * 设置参数
		 * @param	valueName
		 * @param	value
		 */
		public function setValue(valueName:String , value:*):void
		{
			if (!verifyValue(valueName, value))
				return;
			
			this[valueName] = value;
			
			callBinding(valueName);
		}
		
		/// 子类可复写, 数据验证, 对数据进行修正, 修正后, 如果需要赋值, 则返回true , 否则为false
		protected function verifyValue(valueName:String , value:*):Boolean
		{
			return true;
		}
		
		/**
		 * 获取参数
		 * @param	valueName	参数名
		 */
		public function getValue(valueName:String):*
		{
			return this[valueName];
		}
		
		/**
		 * 绑定
		 * @param	valueName		数据属性名字
		 * @param	bindingObj		绑定对象
		 * @param	bindingParam	绑定对象参数
		 */
		public function binding(valueName:String , bindingObj:Object , bindingParam:String):void
		{
			var list:Dictionary = getBindingList(valueName);
			var paramList:Array = getParamList(list, bindingObj);
			C5Utils.addElement(paramList, bindingParam);
			bindingObj[bindingParam] = this[valueName];
		}
		
		/**
		 * 绑定回调
		 * 回调需两个参数:	valueName  value
		 * @param	valueName		数据属性名字
		 * @param	callBack		回调
		 */
		public function bindingCallBack(valueName:String ,callBack:Function):void
		{
			var list:Dictionary = getBindingList(valueName);
			var paramList:Array = getParamList(list, Function);
			C5Utils.addElement(paramList, callBack);
			callBack(valueName , this[valueName]);
		}
		
		/**
		 * 删除回调
		 * @param	valueName
		 * @param	bindingObj
		 * @param	callBack
		 */
		public function delCallBack(valueName:String , callBack:Function):void
		{
			var list:Dictionary = getBindingList(valueName);
			var paramList:Array = getParamList(list, Function);
			C5Utils.removeElement(paramList, callBack);
		}
		
		/**
		 * 移除绑定
		 * @param	valueName		数据属性名字
		 * @param	bindingObj		绑定对象
		 * @param	bindingParam	绑定对象参数
		 */
		public function delBinding(valueName:String , bindingObj:Object , bindingParam:String):void
		{
			var list:Dictionary = getBindingList(valueName);
			var paramList:Array = getParamList(list, bindingObj);
			C5Utils.removeElement(paramList, bindingParam);
		}
		
		/**
		 * 删除对象与数据的所有绑定
		 * @param	bindingObj
		 */
		public function delObjBinding(bindingObj:Object):void
		{
			for each(var list:Dictionary in _bindingList)
			{
				if (list[bindingObj])
					delete list[bindingObj];
			}
		}
		
		/// 获取绑定列表
		private function getBindingList(valueName:String):Dictionary
		{
			if (_bindingList[valueName] == null)
				_bindingList[valueName] = new Dictionary();
			return _bindingList[valueName];
		}
		
		/// 获取绑定参数列表
		private function getParamList(list:Dictionary , bindingObj:Object):Array
		{
			if (list[bindingObj] == null)
				list[bindingObj] = [];
			return list[bindingObj];
		}
		
		
	}
	
}