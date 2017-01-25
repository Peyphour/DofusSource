package com.ankamagames.jerakine.utils.display
{
   public class AngleToOrientation
   {
       
      
      public function AngleToOrientation()
      {
         super();
      }
      
      public static function angleToOrientation(param1:Number) : uint
      {
         var _loc2_:uint = 0;
         switch(true)
         {
            case param1 > -(Math.PI / 8) && param1 <= Math.PI / 8:
               _loc2_ = 0;
               break;
            case param1 > -(Math.PI * (3 / 8)) && param1 <= -(Math.PI / 8):
               _loc2_ = 7;
               break;
            case param1 > -(Math.PI * (5 / 8)) && param1 <= -(Math.PI * (3 / 8)):
               _loc2_ = 6;
               break;
            case param1 > -(Math.PI * (7 / 8)) && param1 <= -(Math.PI * (5 / 8)):
               _loc2_ = 5;
               break;
            case param1 > Math.PI * (7 / 8) || param1 <= -(Math.PI * (7 / 8)):
               _loc2_ = 4;
               break;
            case param1 > Math.PI * (5 / 8) && param1 <= Math.PI * (7 / 8):
               _loc2_ = 3;
               break;
            case param1 > Math.PI * (3 / 8) && param1 <= Math.PI * (5 / 8):
               _loc2_ = 2;
               break;
            case param1 > Math.PI / 8 && param1 <= Math.PI * (3 / 8):
               _loc2_ = 1;
         }
         return _loc2_;
      }
   }
}
