package com.ankamagames.jerakine.utils.crypto
{
   import flash.utils.ByteArray;
   
   public class CRC32
   {
      
      private static var CRCTable:Array = initCRCTable();
       
      
      private var _crc32:uint;
      
      public function CRC32()
      {
         super();
      }
      
      private static function initCRCTable() : Array
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = new Array(256);
         var _loc2_:int = 0;
         while(_loc2_ < 256)
         {
            _loc3_ = _loc2_;
            _loc4_ = 0;
            while(_loc4_ < 8)
            {
               _loc3_ = !!(_loc3_ & 1)?uint(_loc3_ >>> 1 ^ 3988292384):uint(_loc3_ >>> 1);
               _loc4_++;
            }
            _loc1_[_loc2_] = _loc3_;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function update(param1:ByteArray, param2:int = 0, param3:int = 0) : void
      {
         param3 = param3 == 0?int(param1.length):int(param3);
         var _loc4_:uint = ~this._crc32;
         var _loc5_:int = param2;
         while(_loc5_ < param3)
         {
            _loc4_ = CRCTable[(_loc4_ ^ param1[_loc5_]) & 255] ^ _loc4_ >>> 8;
            _loc5_++;
         }
         this._crc32 = ~_loc4_;
      }
      
      public function getValue() : uint
      {
         return this._crc32 & 4294967295;
      }
      
      public function reset() : void
      {
         this._crc32 = 0;
      }
   }
}
