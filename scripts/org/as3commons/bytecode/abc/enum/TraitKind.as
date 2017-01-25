package org.as3commons.bytecode.abc.enum
{
   import flash.utils.Dictionary;
   import org.as3commons.lang.StringUtils;
   
   public final class TraitKind
   {
      
      private static var _enumCreated:Boolean = false;
      
      private static const _TYPES:Dictionary = new Dictionary();
      
      public static const SLOT:TraitKind = new TraitKind(0,"slot");
      
      public static const METHOD:TraitKind = new TraitKind(1,"method");
      
      public static const GETTER:TraitKind = new TraitKind(2,"getter");
      
      public static const SETTER:TraitKind = new TraitKind(3,"setter");
      
      public static const CLASS:TraitKind = new TraitKind(4,"class");
      
      public static const FUNCTION:TraitKind = new TraitKind(5,"function");
      
      public static const CONST:TraitKind = new TraitKind(6,"const");
      
      private static const UPPER_FOUR:uint = 15;
      
      {
         _enumCreated = true;
      }
      
      private var _value:uint;
      
      private var _description:String;
      
      private var _associatedClass:Class;
      
      public function TraitKind(param1:uint, param2:String)
      {
         super();
         this._value = param1;
         this._description = param2;
         _TYPES[this._value] = this;
      }
      
      public static function determineKind(param1:uint) : TraitKind
      {
         var _loc2_:* = param1 & UPPER_FOUR;
         var _loc3_:TraitKind = _TYPES[_loc2_];
         if(!_loc3_)
         {
            throw new Error("No match for kind: " + param1);
         }
         return _loc3_;
      }
      
      public function get bitMask() : uint
      {
         return this._value;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function toString() : String
      {
         return StringUtils.substitute("TraitKind[bitMask={0},description={1}]",this._value,this._description);
      }
   }
}
