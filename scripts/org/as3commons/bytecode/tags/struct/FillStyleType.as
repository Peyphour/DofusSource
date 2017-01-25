package org.as3commons.bytecode.tags.struct
{
   import flash.utils.Dictionary;
   import org.as3commons.bytecode.abc.enum.BaseEnum;
   
   public final class FillStyleType extends BaseEnum
   {
      
      private static const _items:Dictionary = new Dictionary();
      
      private static var _enumCreated:Boolean = false;
      
      public static const SOLID_FILL:FillStyleType = new FillStyleType(0);
      
      public static const LINEAR_GRADIENT_FILL:FillStyleType = new FillStyleType(16);
      
      public static const RADIAL_GRADIENT_FILL:FillStyleType = new FillStyleType(18);
      
      public static const FOCAL_RADIAL_GRADIENT_FILL:FillStyleType = new FillStyleType(19);
      
      public static const REPEATING_BITMAP_FILL:FillStyleType = new FillStyleType(64);
      
      public static const CLIPPED_BITMAP_FILL:FillStyleType = new FillStyleType(65);
      
      public static const NONSMOOTHED_REPEATING_BITMAP:FillStyleType = new FillStyleType(66);
      
      public static const NONSMOOTHED_CLIPPED_BITMAP:FillStyleType = new FillStyleType(67);
      
      {
         _enumCreated = true;
      }
      
      public function FillStyleType(param1:uint)
      {
         super(param1);
         _items[param1] = this;
      }
      
      public static function fromValue(param1:uint) : FillStyleType
      {
         var _loc2_:FillStyleType = _items[param1];
         if(_loc2_ == null)
         {
            throw new Error("Unable to match FillStyleType to " + param1);
         }
         return _loc2_;
      }
   }
}
