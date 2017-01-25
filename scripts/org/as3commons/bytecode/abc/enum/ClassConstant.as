package org.as3commons.bytecode.abc.enum
{
   import flash.utils.Dictionary;
   
   public final class ClassConstant extends BaseEnum
   {
      
      private static const _items:Dictionary = new Dictionary();
      
      private static var _enumCreated:Boolean = false;
      
      public static const SEALED:ClassConstant = new ClassConstant(1,"sealed");
      
      public static const FINAL:ClassConstant = new ClassConstant(2,"final");
      
      public static const INTERFACE:ClassConstant = new ClassConstant(4,"interface");
      
      public static const PROTECTED_NAMESPACE:ClassConstant = new ClassConstant(8,"protected namespace");
      
      {
         _enumCreated = true;
      }
      
      private var _description:String;
      
      public function ClassConstant(param1:uint, param2:String)
      {
         super(param1);
         _items[param1] = this;
         this._description = param2;
      }
      
      public static function fromValue(param1:uint) : ClassConstant
      {
         var _loc2_:ClassConstant = _items[param1];
         if(_loc2_ == null)
         {
            throw new Error("Unable to match ClassConstant to " + _loc2_);
         }
         return _loc2_;
      }
      
      public function present(param1:uint) : Boolean
      {
         return Boolean(this.bitMask & param1);
      }
      
      public function get bitMask() : uint
      {
         return uint(value);
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      override public function toString() : String
      {
         return "";
      }
   }
}
