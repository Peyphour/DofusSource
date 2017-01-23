package com.ankamagames.dofus.uiApi
{
   import by.blooddy.crypto.Base64;
   import by.blooddy.crypto.image.JPEGEncoder;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.filesystem.File;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class CaptureApi implements IApi
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CaptureApi));
      
      private static var _instance:CaptureApi;
       
      
      public function CaptureApi()
      {
         super();
         MEMORY_LOG[this] = 1;
         _instance = this;
      }
      
      public static function getInstance() : CaptureApi
      {
         if(!_instance)
         {
            _instance = new CaptureApi();
         }
         return _instance;
      }
      
      [NoBoxing]
      [Untrusted]
      public function getScreen(param1:Rectangle = null, param2:Number = 1.0) : BitmapData
      {
         return this.capture(StageShareManager.stage,param1,StageShareManager.stageVisibleBounds,param2);
      }
      
      [NoBoxing]
      [Untrusted]
      public function getBattleField(param1:Rectangle = null, param2:Number = 1.0) : BitmapData
      {
         return this.capture(Atouin.getInstance().worldContainer,param1,new Rectangle(-Atouin.getInstance().worldContainer.x,0,StageShareManager.startWidth - Atouin.getInstance().worldContainer.x * 2,AtouinConstants.CELL_HEIGHT * AtouinConstants.MAP_HEIGHT + 15),param2);
      }
      
      [NoBoxing]
      [Untrusted]
      public function getFromTarget(param1:Object, param2:Rectangle = null, param3:Number = 1.0, param4:Boolean = false) : BitmapData
      {
         if(!param1 || !(param1 is DisplayObject))
         {
            return null;
         }
         var _loc5_:DisplayObject = param1 as DisplayObject;
         var _loc6_:Rectangle = _loc5_.getBounds(_loc5_);
         if(!_loc6_.width || !_loc6_.height)
         {
            return null;
         }
         return this.capture(_loc5_,param2,_loc6_,param3,param4);
      }
      
      [NoBoxing]
      [Untrusted]
      public function jpegEncode(param1:BitmapData, param2:uint = 80, param3:Boolean = true, param4:String = "image.jpg") : ByteArray
      {
         var _loc5_:ByteArray = JPEGEncoder.encode(param1,param2);
         if(param3 && AirScanner.hasAir())
         {
            File.desktopDirectory.save(_loc5_,param4);
         }
         return _loc5_;
      }
      
      [NoBoxing]
      [Untrusted]
      public function pngEncode(param1:BitmapData, param2:Boolean = true, param3:String = "image.png") : ByteArray
      {
         var _loc4_:ByteArray = PNGEncoder2.encode(param1);
         if(param2 && AirScanner.hasAir())
         {
            File.desktopDirectory.save(_loc4_,param3);
         }
         return _loc4_;
      }
      
      [NoBoxing]
      [Untrusted]
      public function getScreenAsJpgCompressedBase64(param1:Rectangle = null, param2:Number = 1.0, param3:uint = 80) : String
      {
         var _loc7_:ByteArray = null;
         var _loc4_:String = "";
         var _loc5_:Rectangle = StageShareManager.stageVisibleBounds;
         var _loc6_:BitmapData = this.capture(StageShareManager.stage,param1,_loc5_,param2);
         if(_loc6_)
         {
            _loc7_ = JPEGEncoder.encode(_loc6_,param3);
            _loc4_ = Base64.encode(_loc7_);
            _loc7_.clear();
         }
         return _loc4_;
      }
      
      private function capture(param1:DisplayObject, param2:Rectangle, param3:Rectangle, param4:Number = 1.0, param5:Boolean = false) : BitmapData
      {
         var _loc6_:Rectangle = null;
         var _loc7_:Matrix = null;
         var _loc8_:BitmapData = null;
         if(!param2)
         {
            _loc6_ = param3;
         }
         else
         {
            _loc6_ = param3.intersection(param2);
         }
         if(param1)
         {
            _loc7_ = new Matrix();
            _loc7_.scale(param4,param4);
            _loc7_.translate(-_loc6_.x * param4,-_loc6_.y * param4);
            _loc8_ = new BitmapData(_loc6_.width * param4,_loc6_.height * param4,param5,!!param5?uint(16711680):uint(4294967295));
            _loc8_.draw(param1,_loc7_);
            return _loc8_;
         }
         return null;
      }
   }
}
