package org.as3commons.bytecode.io
{
   import flash.utils.Dictionary;
   
   public final class MethodBodyExtractionKind
   {
      
      private static var _enumCreated:Boolean = false;
      
      private static const _items:Dictionary = new Dictionary();
      
      public static const PARSE:MethodBodyExtractionKind = new MethodBodyExtractionKind(PARSE_VALUE);
      
      public static const SKIP:MethodBodyExtractionKind = new MethodBodyExtractionKind(SKIP_VALUE);
      
      public static const BYTEARRAY:MethodBodyExtractionKind = new MethodBodyExtractionKind(BYTEARRAY_VALUE);
      
      private static const PARSE_VALUE:String = "parseMethodBody";
      
      private static const SKIP_VALUE:String = "skipMethodBody";
      
      private static const BYTEARRAY_VALUE:String = "byteArrayMethodBody";
      
      {
         _enumCreated = true;
      }
      
      private var _value:String;
      
      public function MethodBodyExtractionKind(param1:String)
      {
         super();
         this._value = param1;
         _items[this._value] = this;
      }
      
      public static function fromValue(param1:String) : MethodBodyExtractionKind
      {
         return _items[param1] as MethodBodyExtractionKind;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function toString() : String
      {
         return "MethodBodyExtractionMethod[_value:\"" + this._value + "\"]";
      }
   }
}
