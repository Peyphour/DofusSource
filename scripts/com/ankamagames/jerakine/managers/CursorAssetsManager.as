package com.ankamagames.jerakine.managers
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursorData;
   import flash.utils.Dictionary;
   
   public class CursorAssetsManager
   {
      
      private static var _cursors:Dictionary = new Dictionary();
       
      
      public function CursorAssetsManager()
      {
         super();
      }
      
      public static function addCursor(param1:String, param2:*) : MouseCursorData
      {
         var _loc5_:MovieClip = null;
         var _loc6_:uint = 0;
         if(!Mouse.supportsNativeCursor)
         {
            return null;
         }
         var _loc3_:MouseCursorData = new MouseCursorData();
         var _loc4_:Vector.<BitmapData> = new Vector.<BitmapData>();
         if(param2 is Bitmap)
         {
            _loc4_.push(Bitmap(param2).bitmapData);
         }
         else if(param2 is BitmapData)
         {
            _loc4_.push(param2);
         }
         else if(param2 is MovieClip)
         {
            _loc5_ = param2;
            _loc3_.hotSpot = getOrigin(param2);
            _loc6_ = 1;
            while(_loc6_ <= _loc5_.totalFrames)
            {
               _loc5_.gotoAndStop(_loc6_);
               addFrame(_loc5_,_loc4_);
               _loc6_++;
            }
         }
         else if(param2 is DisplayObject)
         {
            _loc3_.hotSpot = getOrigin(param2);
            addFrame(param2 as DisplayObject,_loc4_);
         }
         else
         {
            return null;
         }
         _loc3_.frameRate = 25;
         _loc3_.data = _loc4_;
         Mouse.registerCursor(param1,_loc3_);
         _cursors[param1] = _loc3_;
         return _loc3_;
      }
      
      public static function getCursor(param1:String) : MouseCursorData
      {
         return _cursors[param1];
      }
      
      private static function addFrame(param1:DisplayObject, param2:Vector.<BitmapData>) : void
      {
         var _loc3_:Rectangle = param1.getBounds(param1);
         var _loc4_:BitmapData = new BitmapData(32,32,true,0);
         _loc4_.draw(param1);
         param2.push(_loc4_);
      }
      
      private static function getOrigin(param1:DisplayObject) : Point
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:uint = 0;
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = param1 as DisplayObjectContainer;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               if(_loc2_.getChildAt(_loc3_).name.indexOf("origin") != -1)
               {
                  return new Point(_loc2_.getChildAt(_loc3_).x,_loc2_.getChildAt(_loc3_).y);
               }
               _loc3_++;
            }
         }
         return new Point();
      }
   }
}
