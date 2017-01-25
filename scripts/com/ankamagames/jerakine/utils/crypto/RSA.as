package com.ankamagames.jerakine.utils.crypto
{
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.util.der.PEM;
   import flash.utils.ByteArray;
   
   public class RSA
   {
       
      
      public function RSA()
      {
         super();
      }
      
      public static function publicEncrypt(param1:String, param2:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:RSAKey = PEM.readRSAPublicKey(param1);
         _loc4_.encrypt(param2,_loc3_,param2.length);
         return _loc3_;
      }
   }
}
