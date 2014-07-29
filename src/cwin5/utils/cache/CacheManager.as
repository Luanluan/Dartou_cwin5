package cwin5.utils.cache
{
	import cwin5.utils.C5System;
	import cwin5.utils.C5Utils;
	import flash.utils.Dictionary;
	
	/**
	 * 对象缓存管理器
	 * @author cwin5
	 */
	public class CacheManager
	{
		/// 默认最大对象缓存数
		private static const DEFAULT_AMOUNT:int = 40;
		
		/// 键值对象池
		private var _keyDict:Dictionary = null;
		
		/// 类型对象池
		private var _objDict:Dictionary = null;
		
		/// 数量对象池
		private var _amountDict:Dictionary = null;
		
		/// 初始化
		private function init():void
		{
			_keyDict = new Dictionary();
			_objDict = new Dictionary();
			_amountDict = new Dictionary();
		}
		
		/**
		 * 设置对象最大缓存数
		 * @param	objClass
		 * @param	amount
		 */
		public function setObjAmount(objClass:Class, amount:int):void
		{
			getList(objClass);
			_amountDict[objClass] = amount;
			//trace(objClass , _amountDict[objClass]);
		}
		
		/**
		 * 根据键值设置对象最大缓存数
		 * @param	key
		 * @param	amount
		 */
		public function setObjAmountByKey(key:Object , amount:int):void
		{
			var objClass:Class = _keyDict[key];
			if (objClass)
				setObjAmount(objClass, amount);
		}
		
		/**
		 * 根据键值取得对象
		 * @param	key
		 */
		public function getObjectByKey(key:Object):*
		{
			var objClass:Class = _keyDict[key];
			if(objClass)
			{
				return getObject(objClass);
			}
			return null;
		}
		
		/**
		 * 删除该键值的所有对象
		 * @param	key
		 */
		public function delObjectByKey(key:Object):void
		{
			var objClass:Class = _keyDict[key];
			if (objClass)
				delObject(objClass);
		}
		
		/**
		 * 注册类
		 * @param	key
		 * @param	objClass
		 */
		public function regObjClass(key:Object, objClass:Class):void
		{
			if (_keyDict[key])
				throw new Error("This key has object!");
			_keyDict[key] = objClass;
		}
		
		/**
		 * 获取对象
		 * 如果有缓存对象.则使用缓存对象.否则创建新对象
		 * @param	objClass
		 * @param	factory			工厂对象,默认直接new
		 * @param	params			创建参数
		 * @return
		 */
		public function getObject(objClass:Class , factory:ICreateFactory = null, params:Array = null):*
		{
			var obj:* = null;
			if (objClass)
			{
				var list:Array = getList(objClass);
				if (list.length > 0)
				{
					obj = list[0];
					list.shift();
				}
				else
				{
					if (factory)
						obj = factory.create.apply(null, params);
					else
						obj = new objClass();
				}
			}
			return obj;
		}
		
		/**
		 * 删除对象.如果缓存对象未满.则缓存起来
		 * 如果传入的对象类型是Class.则删除该Class的所有缓存对象
		 * @param	obj
		 */
		public function delObject(obj:*):void
		{
			if (obj)
			{
				if (obj is Class)
				{
					createList(obj);
				}
				else
				{
					var objClass:Class = C5System.getObjClass(obj);
					var list:Array = getList(objClass);
					var amount:int = _amountDict[objClass];
					//if (amount != 40) 
					//trace("amount:" , objClass , amount);
					if (list.length < amount)
					{
						C5Utils.addElement(list , obj);
					}
					
				}
			}
		}
		
		/// 获取该类型对象列表
		private function getList(objClass:Class):Array
		{
			if (_objDict[objClass] == null)
			{
				createList(objClass);
				_amountDict[objClass] = DEFAULT_AMOUNT;
				//trace("create" , objClass);
			}
			return _objDict[objClass];
		}
		
		/// 创建该类型对象列表, 也可用于清除
		private function createList(objClass:Class):void
		{
			_objDict[objClass] = [];
		}
		
		/**
		 * 构造
		 */
		public function CacheManager(single:Single)
		{
			if(single == null)
			{
				throw new Error("Can't create instance , Single is Null!");
			}
			init();
		}
		
		/**
		 * 单例引用
		 */
		public static function get instance():CacheManager
		{
			if(_instance == null)
			{
				_instance = new CacheManager(new Single());
			}
			return _instance;
		}
		
		private static var _instance:CacheManager = null;
	}
	
}
class Single{}