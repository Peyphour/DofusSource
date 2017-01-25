package com.ankamagames.jerakine.utils.display
{
   import flash.geom.ColorTransform;
   
   public class ColorUtils
   {
       
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function rgb2hsl(param1:uint) : Object
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         _loc2_ = (param1 & 16711680) >> 16;
         _loc3_ = (param1 & 65280) >> 8;
         _loc4_ = param1 & 255;
         _loc2_ = _loc2_ / 255;
         _loc3_ = _loc3_ / 255;
         _loc4_ = _loc4_ / 255;
         var _loc8_:Number = Math.min(_loc2_,_loc3_,_loc4_);
         var _loc9_:Number = Math.max(_loc2_,_loc3_,_loc4_);
         var _loc10_:Number = _loc9_ - _loc8_;
         _loc7_ = 1 - (_loc9_ + _loc8_) / 2;
         if(_loc10_ == 0)
         {
            _loc5_ = 0;
            _loc6_ = 0;
         }
         else
         {
            if(_loc9_ + _loc8_ < 1)
            {
               _loc6_ = 1 - _loc10_ / (_loc9_ + _loc8_);
            }
            else
            {
               _loc6_ = 1 - _loc10_ / (2 - _loc9_ - _loc8_);
            }
            _loc11_ = ((_loc9_ - _loc2_) / 6 + _loc10_ / 2) / _loc10_;
            _loc12_ = ((_loc9_ - _loc3_) / 6 + _loc10_ / 2) / _loc10_;
            _loc13_ = ((_loc9_ - _loc4_) / 6 + _loc10_ / 2) / _loc10_;
            if(_loc2_ == _loc9_)
            {
               _loc5_ = _loc13_ - _loc12_;
            }
            else if(_loc3_ == _loc9_)
            {
               _loc5_ = 1 / 3 + _loc11_ - _loc13_;
            }
            else if(_loc4_ == _loc9_)
            {
               _loc5_ = 2 / 3 + _loc12_ - _loc11_;
            }
            if(_loc5_ < 0)
            {
               _loc5_++;
            }
            if(_loc5_ > 1)
            {
               _loc5_--;
            }
         }
         return {
            "h":_loc5_,
            "s":_loc6_,
            "l":_loc7_
         };
      }
      
      public static function mixColorTransforms(param1:ColorTransform, param2:ColorTransform, param3:Number = 0.5) : ColorTransform
      {
         var _loc6_:String = null;
         var _loc4_:ColorTransform = new ColorTransform();
         var _loc5_:Array = ["redOffset","redMultiplier","greenOffset","greenMultiplier","blueOffset","blueMultiplier"];
         for each(_loc6_ in _loc5_)
         {
            _loc4_[_loc6_] = param1[_loc6_] + (param2[_loc6_] - param1[_loc6_]) * param3;
         }
         return _loc4_;
      }
   }
}
