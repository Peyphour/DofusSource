package org.as3commons.bytecode.abc.enum
{
   import flash.utils.Dictionary;
   import org.as3commons.lang.StringUtils;
   
   public final class ConstantKind
   {
      
      private static var _enumCreated:Boolean = false;
      
      private static const _TYPES:Dictionary = new Dictionary();
      
      public static const UNKNOWN:ConstantKind = new ConstantKind(0,"UNKNOWN");
      
      public static const INT:ConstantKind = new ConstantKind(3,"int");
      
      public static const UINT:ConstantKind = new ConstantKind(4,"uint");
      
      public static const DOUBLE:ConstantKind = new ConstantKind(6,"double");
      
      public static const UTF8:ConstantKind = new ConstantKind(1,"utf8");
      
      public static const TRUE:ConstantKind = new ConstantKind(11,"true");
      
      public static const FALSE:ConstantKind = new ConstantKind(10,"false");
      
      public static const NULL:ConstantKind = new ConstantKind(12,"null");
      
      public static const UNDEFINED:ConstantKind = new ConstantKind(0,"undefined");
      
      public static const NAMESPACE:ConstantKind = new ConstantKind(8,"namespace");
      
      public static const PACKAGE_NAMESPACE:ConstantKind = new ConstantKind(22,"package namespace");
      
      public static const PACKAGE_INTERNAL_NAMESPACE:ConstantKind = new ConstantKind(23,"package internal namespace");
      
      public static const PROTECTED_NAMESPACE:ConstantKind = new ConstantKind(24,"protected namespace");
      
      public static const EXPLICIT_NAMESPACE:ConstantKind = new ConstantKind(25,"explicit namespace");
      
      public static const STATIC_PROTECTED_NAMESPACE:ConstantKind = new ConstantKind(26,"static protected namespace");
      
      public static const PRIVATE_NAMESPACE:ConstantKind = new ConstantKind(5,"private namespace");
      
      {
         _enumCreated = true;
      }
      
      private var _kind:uint;
      
      private var _description:String;
      
      public function ConstantKind(param1:uint, param2:String)
      {
         super();
         this._kind = param1;
         this._description = param2;
         _TYPES[this._kind] = this;
      }
      
      public static function determineKind(param1:int) : ConstantKind
      {
         var _loc2_:ConstantKind = _TYPES[param1];
         if(_loc2_ == null)
         {
            throw new Error("Unable to match ConstantKind to " + param1);
         }
         return _loc2_;
      }
      
      public static function determineKindFromInstance(param1:*) : ConstantKind
      {
         var _loc2_:Boolean = false;
         if(param1 is String)
         {
            return ConstantKind.UTF8;
         }
         if(param1 is uint)
         {
            return ConstantKind.UINT;
         }
         if(param1 is int)
         {
            return ConstantKind.INT;
         }
         if(param1 is Number)
         {
            return ConstantKind.DOUBLE;
         }
         if(param1 is Boolean)
         {
            _loc2_ = param1 as Boolean;
            return !!_loc2_?ConstantKind.TRUE:ConstantKind.FALSE;
         }
         if(param1 == null)
         {
            return ConstantKind.NULL;
         }
         return ConstantKind.UNKNOWN;
      }
      
      public function get value() : uint
      {
         return this._kind;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function toString() : String
      {
         return StringUtils.substitute("ConstantKind[description={0}]",this._description);
      }
   }
}
