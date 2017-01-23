package com.ankamagames.dofus.uiApi
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class CaptureApi
   {
       
      
      public function CaptureApi()
      {
         super();
      }
      
      [Untrusted]
      public function getScreen(param1:Rectangle = null, param2:Number = 1.0) : BitmapData
      {
         return null;
      }
      
      [Untrusted]
      public function getBattleField(param1:Rectangle = null, param2:Number = 1.0) : BitmapData
      {
         return null;
      }
      
      [Untrusted]
      public function getFromTarget(param1:Object, param2:Rectangle = null, param3:Number = 1.0, param4:Boolean = false) : BitmapData
      {
         return null;
      }
      
      [Untrusted]
      public function jpegEncode(param1:BitmapData, param2:uint = 80, param3:Boolean = true, param4:String = "image.jpg") : ByteArray
      {
         return null;
      }
      
      [Untrusted]
      public function pngEncode(param1:BitmapData, param2:Boolean = true, param3:String = "image.png") : ByteArray
      {
         return null;
      }
      
      [Untrusted]
      public function getScreenAsJpgCompressedBase64(param1:Rectangle = null, param2:Number = 1.0, param3:uint = 80) : String
      {
         return null;
      }
   }
}
