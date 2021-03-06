package org.as3commons.lang
{
   import flash.utils.Dictionary;
   
   public final class TypeDescriptionKind
   {
      
      private static var _enumCreated:Boolean = false;
      
      private static const _items:Dictionary = new Dictionary();
      
      public static const JSON:TypeDescriptionKind = new TypeDescriptionKind(JSON_NAME);
      
      public static const XML:TypeDescriptionKind = new TypeDescriptionKind(XML_NAME);
      
      private static const JSON_NAME:String = "JSONTypeDescription";
      
      private static const XML_NAME:String = "XMLTypeDescription";
      
      {
         _enumCreated = true;
      }
      
      private var _value:String;
      
      public function TypeDescriptionKind(param1:String)
      {
         super();
         Assert.state(!_enumCreated,"TypeDescriptionKind enumeration has already been created");
         this._value = param1;
         _items[this._value] = this;
      }
      
      public static function fromValue(param1:String) : TypeDescriptionKind
      {
         return _items[param1] as TypeDescriptionKind;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function toString() : String
      {
         return StringUtils.substitute("[TypeDescriptionKind(value=\'{0}\')]",this.value);
      }
   }
}
