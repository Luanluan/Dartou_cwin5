package cwin5.utils.swf.abc
{
	
	/**
	* ...
	* @author Ben Hopkins
	*/
	public class NamespaceKinds 
	{
		static public const NAMESPACE:uint = 0x08;
		static public const PACKAGE_NAMESPACE:uint = 0x16;
		static public const PACKAGE_INTERNAL_NAMESPACE:uint = 0x17;
		static public const PROTECTED_NAMESPACE:uint = 0x18; 
		static public const EXPLICIT_NAMESPACE:uint = 0x19;
		static public const STATIC_PROTECTED_NAMESPACE:uint = 0x1A;
		static public const PRIVATE_NAMESPACE:uint = 0x05    

		public function NamespaceKinds() 
		{
			
		}
		
		//=========================================================
		//	Public Methods
		//=========================================================
		
		static public function namespaceKindToString( code:uint):String
		{
			var string:String;
			
			switch( code)
			{
				case NamespaceKinds.NAMESPACE: string = "Namespace"; break;
				case NamespaceKinds.PACKAGE_NAMESPACE: string = "PackageNamespace"; break;
				case NamespaceKinds.PACKAGE_INTERNAL_NAMESPACE: string = "PackageInternalNamespace"; break;
				case NamespaceKinds.PROTECTED_NAMESPACE: string = "ProtectedNamespace"; break;
				case NamespaceKinds.EXPLICIT_NAMESPACE: string = "ExplicitNamespace"; break;
				case NamespaceKinds.STATIC_PROTECTED_NAMESPACE: string = "StaticProtectedNamespace"; break;
				case NamespaceKinds.PRIVATE_NAMESPACE: string = "PrivateNamespace"; break;
			}
			return string;
		}
	}
	
}