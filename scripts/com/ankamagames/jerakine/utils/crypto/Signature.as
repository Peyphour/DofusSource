package com.ankamagames.jerakine.utils.crypto
{
   import by.blooddy.crypto.MD5;
   import by.blooddy.crypto.SHA256;
   import com.ankamagames.jerakine.utils.errors.SignatureError;
   import com.hurlant.crypto.rsa.RSAKey;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.getTimer;
   
   public class Signature
   {
      
      public static const ANKAMA_SIGNED_FILE_HEADER:String = "AKSF";
      
      public static const SIGNATURE_HEADER:String = "AKSD";
       
      
      private var _key:SignatureKey;
      
      private var _keyV2:RSAKey;
      
      public function Signature(... rest)
      {
         var _loc2_:* = undefined;
         super();
         if(rest.length == 0)
         {
            throw new ArgumentError("You must provide at least one key");
         }
         for each(_loc2_ in rest)
         {
            if(_loc2_ is SignatureKey)
            {
               this._key = _loc2_;
               continue;
            }
            if(_loc2_ is RSAKey)
            {
               this._keyV2 = _loc2_;
               continue;
            }
            throw new ArgumentError("Invalid key type");
         }
      }
      
      public function sign(param1:IDataInput, param2:Boolean = true) : ByteArray
      {
         var _loc3_:ByteArray = null;
         if(!this._key.canSign)
         {
            throw new Error("La clef fournit ne permet pas de signer des données");
         }
         if(param1 is ByteArray)
         {
            _loc3_ = param1 as ByteArray;
         }
         else
         {
            _loc3_ = new ByteArray();
            param1.readBytes(_loc3_);
            _loc3_.position = 0;
         }
         var _loc4_:uint = _loc3_["position"];
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:uint = Math.random() * 255;
         _loc5_.writeByte(_loc6_);
         _loc5_.writeUnsignedInt(_loc3_.bytesAvailable);
         var _loc7_:Number = getTimer();
         _loc5_.writeUTFBytes(MD5.hash(_loc3_.readUTFBytes(_loc3_.bytesAvailable)));
         trace("Temps de hash pour signature : " + (getTimer() - _loc7_) + " ms");
         var _loc8_:uint = 2;
         while(_loc8_ < _loc5_.length)
         {
            _loc5_[_loc8_] = _loc5_[_loc8_] ^ _loc6_;
            _loc8_++;
         }
         var _loc9_:ByteArray = new ByteArray();
         _loc5_.position = 0;
         this._key.sign(_loc5_,_loc9_,_loc5_.length);
         var _loc10_:ByteArray = new ByteArray();
         _loc10_.writeUTF(ANKAMA_SIGNED_FILE_HEADER);
         _loc10_.writeShort(1);
         _loc10_.writeInt(_loc9_.length);
         _loc9_.position = 0;
         _loc10_.writeBytes(_loc9_);
         if(param2)
         {
            _loc3_.position = _loc4_;
            _loc10_.writeBytes(_loc3_);
         }
         return _loc10_;
      }
      
      public function verify(param1:IDataInput, param2:ByteArray) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         _loc3_ = param1.readUTF();
         if(_loc3_ != ANKAMA_SIGNED_FILE_HEADER)
         {
            param1["position"] = 0;
            _loc4_ = param1.bytesAvailable - ANKAMA_SIGNED_FILE_HEADER.length;
            param1["position"] = _loc4_;
            _loc3_ = param1.readUTFBytes(4);
            if(_loc3_ == ANKAMA_SIGNED_FILE_HEADER)
            {
               return this.verifyV2Signature(param1,param2,_loc4_);
            }
            throw new SignatureError("Invalid header",SignatureError.INVALID_HEADER);
         }
         return this.verifyV1Signature(param1,param2);
      }
      
      private function verifyV1Signature(param1:IDataInput, param2:ByteArray) : Boolean
      {
         if(_loc6_)
         {
            §§push(_loc3_);
            §§push(0);
            if(!_loc6_)
            {
               §§push(--(-(-§§pop() * 0 + 1) + 81));
            }
            var /*UnknownSlot*/:* = uint(§§pop());
         }
         if(_loc6_)
         {
         }
         var input:IDataInput = param1;
         if(_loc5_)
         {
            addr47:
            while(true)
            {
               var formatVersion:uint = input.readShort();
               if(_loc6_)
               {
               }
               var sigData:ByteArray = new ByteArray();
               if(!_loc5_)
               {
               }
               break;
            }
            var decryptedHash:ByteArray = new ByteArray();
            if(!_loc5_)
            {
            }
            try
            {
               var len:uint = input.readInt();
               if(!_loc5_)
               {
                  §§push(input);
                  §§push(sigData);
                  §§push(0);
                  if(!_loc6_)
                  {
                     §§push((§§pop() - 1 - 13 - 47 - 1) * 100 - 1);
                  }
                  §§pop().readBytes(§§pop(),§§pop(),len);
               }
            }
            catch(e:Error)
            {
               throw new SignatureError("Invalid signature format, not enough data.",SignatureError.INVALID_SIGNATURE);
            }
            try
            {
               this._key.verify(sigData,decryptedHash,sigData.length);
            }
            catch(e:Error)
            {
               return false;
            }
            §§push(decryptedHash);
            §§push(0);
            if(_loc5_)
            {
               §§push(-(§§pop() + 76 - 74 + 1 + 1) * 8 - 1);
            }
            §§pop().position = §§pop();
            if(_loc5_)
            {
               addr179:
               while(true)
               {
                  var hash:ByteArray = new ByteArray();
                  if(_loc6_)
                  {
                  }
                  break;
               }
               §§push(_loc3_);
               §§push(2);
               if(_loc5_)
               {
                  §§push(§§pop() + 42 - 1 + 1 + 1 + 90);
               }
               var /*UnknownSlot*/:* = uint(§§pop());
               if(!_loc5_)
               {
               }
               loop2:
               while(i < decryptedHash.length)
               {
                  if(_loc5_)
                  {
                     loop3:
                     while(true)
                     {
                        §§push(i);
                        if(_loc6_)
                        {
                           §§push(uint(§§pop() + 1));
                        }
                        var i:uint = §§pop();
                        if(!_loc5_)
                        {
                           if(_loc6_)
                           {
                              continue loop2;
                           }
                        }
                        addr258:
                        while(true)
                        {
                           if(_loc5_)
                           {
                              break loop3;
                           }
                           continue loop3;
                        }
                     }
                     continue;
                  }
                  while(true)
                  {
                     decryptedHash[i] = decryptedHash[i] ^ ramdomPart;
                     §§goto(addr258);
                  }
               }
               if(_loc6_)
               {
               }
               var contentLen:int = decryptedHash.readUnsignedInt();
               if(!_loc6_)
               {
                  while(true)
                  {
                     trace("Temps de hash pour validation de signature : " + (getTimer() - tH) + " ms");
                     if(!_loc5_)
                     {
                        if(!_loc6_)
                        {
                           addr302:
                           while(true)
                           {
                              §§push(_loc3_);
                              §§push(MD5.hash(output.readUTFBytes(output.bytesAvailable)));
                              if(_loc6_)
                              {
                                 §§push(1);
                                 if(!_loc6_)
                                 {
                                    §§push(--(§§pop() * 3 * 108 + 69) + 106);
                                 }
                                 §§push(§§pop().substr(§§pop()));
                              }
                              var /*UnknownSlot*/:* = §§pop();
                              if(_loc5_)
                              {
                                 addr336:
                                 while(true)
                                 {
                                    input.readBytes(output);
                                    if(!_loc5_)
                                    {
                                    }
                                    addr376:
                                    while(true)
                                    {
                                       var tH:Number = getTimer();
                                    }
                                 }
                              }
                              else
                              {
                                 break;
                              }
                           }
                           continue;
                        }
                        while(true)
                        {
                           §§push(output);
                           §§push(0);
                           if(_loc5_)
                           {
                              §§push((§§pop() - 33 - 1 - 1 - 1) * 50);
                           }
                           §§pop().position = §§pop();
                           if(!_loc5_)
                           {
                           }
                           break;
                        }
                        §§push(_loc3_);
                        if(_loc6_)
                        {
                           §§push(signHash);
                           if(!_loc5_)
                           {
                              §§push(Boolean(§§pop()));
                              if(!_loc5_)
                              {
                                 §§push(§§pop());
                                 if(!_loc5_)
                                 {
                                    if(§§pop())
                                    {
                                       if(!_loc5_)
                                       {
                                          §§pop();
                                          if(_loc5_)
                                          {
                                          }
                                          addr454:
                                          §§push(contentLen == testedContentLen);
                                          if(!_loc5_)
                                          {
                                             addr461:
                                             §§push(Boolean(§§pop()));
                                          }
                                       }
                                       addr453:
                                       §§pop();
                                       §§goto(addr454);
                                    }
                                    addr444:
                                    §§push(§§pop());
                                 }
                                 if(§§pop())
                                 {
                                    if(_loc6_)
                                    {
                                       §§goto(addr453);
                                    }
                                 }
                                 §§goto(addr461);
                              }
                              var /*UnknownSlot*/:* = §§pop();
                              if(_loc6_)
                              {
                              }
                              return result;
                           }
                           addr438:
                           §§push(§§pop() == contentHash);
                           if(!_loc5_)
                           {
                              §§goto(addr444);
                           }
                           §§goto(addr453);
                        }
                        §§goto(addr438);
                        §§push(signHash);
                     }
                     while(true)
                     {
                        if(_loc5_)
                        {
                           addr386:
                           while(true)
                           {
                              §§push(_loc3_);
                              §§push(decryptedHash.readUTFBytes(decryptedHash.bytesAvailable));
                              §§push(1);
                              if(_loc5_)
                              {
                                 §§push(((§§pop() + 106 - 1 + 1 - 94) * 94 + 1) * 56);
                              }
                              var /*UnknownSlot*/:* = §§pop().substr(§§pop());
                              if(!_loc5_)
                              {
                              }
                              §§goto(addr415);
                           }
                        }
                        else
                        {
                           §§goto(addr302);
                        }
                        §§goto(addr336);
                     }
                  }
               }
               while(true)
               {
                  var testedContentLen:int = input.bytesAvailable;
                  if(!_loc6_)
                  {
                     §§goto(addr376);
                  }
                  §§goto(addr386);
               }
            }
            while(true)
            {
               var ramdomPart:int = decryptedHash.readByte();
               if(!_loc5_)
               {
                  §§goto(addr179);
               }
               §§goto(addr201);
            }
         }
         while(true)
         {
            var output:ByteArray = param2;
            if(_loc6_)
            {
               §§goto(addr47);
            }
            §§goto(addr77);
         }
      }
      
      private function verifyV2Signature(param1:IDataInput, param2:ByteArray, param3:int) : Boolean
      {
         §§push(_loc4_);
         §§push(0);
         if(_loc6_)
         {
            §§push(§§pop() * 75 * 116 - 1 - 105);
         }
         var /*UnknownSlot*/:* = §§pop();
         if(_loc7_)
         {
            if(!_loc7_)
            {
               loop0:
               while(true)
               {
                  var output:ByteArray = param2;
                  if(!_loc6_)
                  {
                     if(_loc6_)
                     {
                        while(true)
                        {
                           var contentHash:String = null;
                           if(_loc7_)
                           {
                              if(_loc6_)
                              {
                                 addr62:
                                 while(true)
                                 {
                                    §§push(_loc4_);
                                    §§push(0);
                                    if(!_loc7_)
                                    {
                                       §§push(-((§§pop() - 87 - 7 - 111) * 38 * 16 * 11));
                                    }
                                    var /*UnknownSlot*/:* = uint(§§pop());
                                    if(!_loc6_)
                                    {
                                    }
                                    addr208:
                                    while(true)
                                    {
                                       var sigHeader:String = null;
                                       if(!_loc7_)
                                       {
                                          break;
                                       }
                                       addr163:
                                       while(true)
                                       {
                                          §§push(_loc4_);
                                          §§push(0);
                                          if(!_loc7_)
                                          {
                                             §§push(§§pop() - 1 + 1 + 74 + 57 + 1);
                                          }
                                          var /*UnknownSlot*/:* = uint(§§pop());
                                          if(!_loc7_)
                                          {
                                             break;
                                          }
                                          addr135:
                                          while(true)
                                          {
                                             §§push(_loc4_);
                                             §§push(0);
                                             if(_loc6_)
                                             {
                                                §§push(-§§pop() * 18 - 79 - 3);
                                             }
                                             var /*UnknownSlot*/:* = uint(§§pop());
                                             if(!_loc7_)
                                             {
                                                addr154:
                                                while(true)
                                                {
                                                   var sigHash:String = null;
                                                }
                                             }
                                             addr113:
                                             while(true)
                                             {
                                                §§push(_loc4_);
                                                §§push(0);
                                                if(_loc6_)
                                                {
                                                   §§push(-((§§pop() - 1) * 117 + 23 + 1 + 1) + 24);
                                                }
                                                var /*UnknownSlot*/:* = uint(§§pop());
                                             }
                                          }
                                       }
                                    }
                                    break loop0;
                                 }
                              }
                              while(true)
                              {
                                 var sigDate:Date = null;
                                 if(!_loc7_)
                                 {
                                    addr96:
                                    while(true)
                                    {
                                       §§push(_loc4_);
                                       §§push(0);
                                       if(_loc6_)
                                       {
                                          §§push((§§pop() - 1) * 88 * 40);
                                       }
                                       var /*UnknownSlot*/:* = uint(§§pop());
                                    }
                                 }
                                 addr191:
                                 while(true)
                                 {
                                    var input:IDataInput = param1;
                                    if(!_loc7_)
                                    {
                                       addr199:
                                       while(true)
                                       {
                                          var sigData:ByteArray = null;
                                          if(!_loc6_)
                                          {
                                             §§goto(addr62);
                                          }
                                          §§goto(addr208);
                                       }
                                    }
                                    else
                                    {
                                       break;
                                    }
                                 }
                                 continue loop0;
                              }
                           }
                           while(!_loc7_)
                           {
                              §§goto(addr113);
                           }
                        }
                     }
                     break;
                  }
                  while(true)
                  {
                     if(!_loc7_)
                     {
                        §§goto(addr163);
                     }
                     §§goto(addr96);
                  }
               }
               var headerPosition:int = param3;
               if(!_loc6_)
               {
               }
               if(!this._keyV2)
               {
                  throw new SignatureError("No key for this signature version");
               }
               try
               {
                  §§push(input);
                  §§push("position");
                  §§push(headerPosition);
                  §§push(4);
                  if(!_loc7_)
                  {
                     §§push(§§pop() - 1 - 1 + 1 + 1);
                  }
                  §§pop()[§§pop()] = §§pop() - §§pop();
                  if(!_loc6_)
                  {
                     var signedDataLenght:int = input.readShort();
                     if(_loc6_)
                     {
                        loop14:
                        while(true)
                        {
                           §§push(sigData);
                           §§push(0);
                           if(_loc6_)
                           {
                              §§push((§§pop() + 8 - 1 + 1 + 1 + 1) * 49 + 27);
                           }
                           §§pop().position = §§pop();
                           if(_loc7_)
                           {
                           }
                           sigHeader = sigData.readUTF();
                           if(!_loc7_)
                           {
                              addr290:
                              while(true)
                              {
                                 var cryptedData:ByteArray = new ByteArray();
                                 if(!_loc7_)
                                 {
                                    addr301:
                                    while(true)
                                    {
                                       trace("Décryptage en " + (getTimer() - tsDecrypt) + " ms");
                                       if(_loc7_)
                                       {
                                          if(_loc7_)
                                          {
                                             continue loop14;
                                          }
                                       }
                                       break;
                                    }
                                    if(!_loc7_)
                                    {
                                       loop20:
                                       while(true)
                                       {
                                          sigData.readInt();
                                          if(_loc6_)
                                          {
                                             addr446:
                                             while(true)
                                             {
                                                var sigFileLenght:uint = sigData.readInt();
                                                if(_loc6_)
                                                {
                                                   addr459:
                                                   while(true)
                                                   {
                                                      var sigVersion:uint = sigData.readByte();
                                                      if(!_loc6_)
                                                      {
                                                         continue loop20;
                                                      }
                                                   }
                                                }
                                                else
                                                {
                                                   §§push(sigFileLenght);
                                                   if(!_loc6_)
                                                   {
                                                      §§push(headerPosition);
                                                      §§push(4);
                                                      if(_loc6_)
                                                      {
                                                         §§push((§§pop() * 87 - 1) * 108);
                                                      }
                                                      §§push(§§pop() - §§pop());
                                                      if(_loc7_)
                                                      {
                                                         §§push(§§pop() - signedDataLenght);
                                                      }
                                                      if(§§pop() != §§pop())
                                                      {
                                                         if(_loc7_)
                                                         {
                                                         }
                                                         §§push();
                                                         §§push("Longueur de fichier incorrect, " + sigFileLenght + " attendu, lu :");
                                                         §§push(headerPosition);
                                                         §§push(4);
                                                         if(!_loc7_)
                                                         {
                                                            §§push((§§pop() + 97 - 1) * 14 * 66);
                                                         }
                                                         §§pop().trace(§§pop() + (§§pop() - §§pop() - signedDataLenght));
                                                         addr538:
                                                         if(_loc7_)
                                                         {
                                                         }
                                                         addr596:
                                                         return false;
                                                      }
                                                      var hashType:uint = sigData.readByte();
                                                      if(_loc6_)
                                                      {
                                                         addr555:
                                                         while(true)
                                                         {
                                                            §§push(input);
                                                            §§push(output);
                                                            §§push(0);
                                                            if(_loc6_)
                                                            {
                                                               §§push(§§pop() + 14 - 95 - 90 - 1 + 1);
                                                            }
                                                            §§push(headerPosition);
                                                            §§push(4);
                                                            if(!_loc7_)
                                                            {
                                                               §§push(§§pop() - 1 - 1 + 70 + 1 - 56);
                                                            }
                                                            §§pop().readBytes(§§pop(),§§pop(),§§pop() - §§pop() - signedDataLenght);
                                                            if(_loc7_)
                                                            {
                                                               if(!_loc7_)
                                                               {
                                                                  §§goto(addr596);
                                                               }
                                                            }
                                                            addr635:
                                                            var tsHash:uint = getTimer();
                                                            addr768:
                                                            if(_loc7_)
                                                            {
                                                               break;
                                                            }
                                                            §§push(output);
                                                            §§push(0);
                                                            if(!_loc7_)
                                                            {
                                                               §§push(-(§§pop() - 84) - 1 + 44);
                                                            }
                                                            §§pop().position = §§pop();
                                                            if(_loc7_)
                                                            {
                                                               if(!_loc7_)
                                                               {
                                                                  addr787:
                                                                  while(true)
                                                                  {
                                                                     sigDate.setTime(sigData.readDouble());
                                                                     if(!_loc6_)
                                                                     {
                                                                        if(_loc7_)
                                                                        {
                                                                        }
                                                                        addr828:
                                                                        trace(sigDate);
                                                                        if(_loc6_)
                                                                        {
                                                                        }
                                                                        break;
                                                                     }
                                                                     break;
                                                                  }
                                                                  return false;
                                                               }
                                                               while(true)
                                                               {
                                                                  trace("Hash en " + (getTimer() - tsHash) + " ms");
                                                                  if(!_loc6_)
                                                                  {
                                                                  }
                                                                  sigDate = new Date();
                                                                  if(_loc6_)
                                                                  {
                                                                     break;
                                                                  }
                                                                  §§goto(addr787);
                                                               }
                                                               §§goto(addr828);
                                                            }
                                                            if(!_loc6_)
                                                            {
                                                            }
                                                            if(sigHash != contentHash)
                                                            {
                                                               trace("Hash incorrect, " + sigHash + " attendu, lu :" + contentHash);
                                                               §§goto(addr853);
                                                            }
                                                         }
                                                      }
                                                      else
                                                      {
                                                         sigHash = sigData.readUTF();
                                                      }
                                                   }
                                                   break;
                                                }
                                                while(true)
                                                {
                                                   if(_loc7_)
                                                   {
                                                   }
                                                   §§push(input);
                                                   §§push("position");
                                                   §§push(0);
                                                   if(_loc6_)
                                                   {
                                                      §§push(-(§§pop() - 43 - 85 + 1) + 1);
                                                   }
                                                   §§pop()[§§pop()] = §§pop();
                                                   if(!_loc6_)
                                                   {
                                                      addr630:
                                                      while(true)
                                                      {
                                                         if(!_loc6_)
                                                         {
                                                            §§goto(addr555);
                                                         }
                                                         §§goto(addr635);
                                                      }
                                                   }
                                                }
                                             }
                                             if(!_loc6_)
                                             {
                                                §§push(0);
                                                if(!_loc7_)
                                                {
                                                   §§push(-§§pop() + 77 - 1);
                                                }
                                                if(_loc7_)
                                                {
                                                   §§push(_loc5_);
                                                   if(!_loc6_)
                                                   {
                                                      if(§§pop() === §§pop())
                                                      {
                                                         if(_loc6_)
                                                         {
                                                            addr736:
                                                            §§push(1);
                                                            if(_loc6_)
                                                            {
                                                               §§push((§§pop() + 54) * 54 * 26 - 1 + 1 + 1 - 1);
                                                            }
                                                            if(_loc7_)
                                                            {
                                                               addr752:
                                                            }
                                                         }
                                                      }
                                                      else
                                                      {
                                                         §§push(1);
                                                         if(!_loc7_)
                                                         {
                                                            §§push(-(-(§§pop() - 83 + 1 + 1) + 2) * 89);
                                                         }
                                                         if(_loc6_)
                                                         {
                                                         }
                                                      }
                                                      addr766:
                                                      switch(§§pop())
                                                      {
                                                         case 0:
                                                            §§push(_loc4_);
                                                            §§push(MD5.hashBytes(output));
                                                            if(_loc7_)
                                                            {
                                                               §§push(§§pop());
                                                            }
                                                            var /*UnknownSlot*/:* = §§pop();
                                                            break;
                                                         case 1:
                                                            §§push(_loc4_);
                                                            §§push(SHA256.hashBytes(output));
                                                            if(!_loc6_)
                                                            {
                                                               §§push(§§pop());
                                                            }
                                                            var /*UnknownSlot*/:* = §§pop();
                                                            break;
                                                         default:
                                                            §§push(false);
                                                            if(!_loc6_)
                                                            {
                                                               return §§pop();
                                                            }
                                                            §§goto(addr853);
                                                      }
                                                      §§goto(addr768);
                                                   }
                                                   addr735:
                                                   if(§§pop() === §§pop())
                                                   {
                                                      §§goto(addr736);
                                                   }
                                                   else
                                                   {
                                                      §§push(2);
                                                      if(_loc6_)
                                                      {
                                                         §§push(-(§§pop() - 106) + 113);
                                                      }
                                                   }
                                                   §§goto(addr766);
                                                }
                                                §§goto(addr735);
                                                §§push(_loc5_);
                                             }
                                             §§push(0);
                                             if(!_loc7_)
                                             {
                                                §§push((-(§§pop() - 1 - 1) + 1) * 45 * 33);
                                             }
                                             if(_loc6_)
                                             {
                                                §§goto(addr752);
                                             }
                                             §§goto(addr766);
                                          }
                                          while(true)
                                          {
                                             sigData.readInt();
                                             if(!_loc6_)
                                             {
                                                if(_loc7_)
                                                {
                                                   §§goto(addr446);
                                                }
                                                §§goto(addr596);
                                             }
                                             break;
                                          }
                                          §§goto(addr630);
                                       }
                                    }
                                    §§push(false);
                                    if(!_loc6_)
                                    {
                                       return §§pop();
                                    }
                                    §§goto(addr596);
                                 }
                                 addr344:
                                 while(true)
                                 {
                                    §§push(input);
                                    §§push(cryptedData);
                                    §§push(0);
                                    if(_loc6_)
                                    {
                                       §§push((§§pop() - 88 + 1 + 1) * 23 + 11);
                                    }
                                    §§pop().readBytes(§§pop(),§§pop(),signedDataLenght);
                                    if(!_loc7_)
                                    {
                                       addr367:
                                       while(true)
                                       {
                                          this._keyV2.verify(cryptedData,sigData,cryptedData.length);
                                          if(_loc7_)
                                          {
                                             §§goto(addr301);
                                          }
                                          §§goto(addr596);
                                       }
                                    }
                                    while(true)
                                    {
                                       sigData = new ByteArray();
                                       if(!_loc6_)
                                       {
                                          if(_loc7_)
                                          {
                                          }
                                          var tsDecrypt:uint = getTimer();
                                          if(_loc6_)
                                          {
                                             break loop14;
                                          }
                                          §§goto(addr367);
                                       }
                                       break;
                                    }
                                    §§goto(addr538);
                                 }
                              }
                           }
                           break;
                        }
                        if(sigHeader != SIGNATURE_HEADER)
                        {
                           if(_loc7_)
                           {
                              if(!_loc6_)
                              {
                              }
                              trace("Header crypté de signature incorrect, " + SIGNATURE_HEADER + " attendu, lu :" + sigHeader);
                              if(!_loc6_)
                              {
                                 §§goto(addr428);
                              }
                              §§goto(addr768);
                           }
                        }
                        §§goto(addr459);
                     }
                     while(true)
                     {
                        §§push(input);
                        §§push("position");
                        §§push(headerPosition);
                        §§push(4);
                        if(_loc6_)
                        {
                           §§push(§§pop() + 1 + 97 - 14);
                        }
                        §§pop()[§§pop()] = §§pop() - §§pop() - signedDataLenght;
                        if(_loc6_)
                        {
                           §§goto(addr344);
                        }
                        §§goto(addr290);
                     }
                  }
                  if(!_loc6_)
                  {
                  }
                  §§goto(addr683);
               }
               catch(e:Error)
               {
                  if(!_loc6_)
                  {
                     trace(e.getStackTrace());
                  }
                  return false;
               }
               return true;
            }
            while(true)
            {
               cryptedData = null;
               if(!_loc7_)
               {
                  §§goto(addr191);
               }
               §§goto(addr199);
            }
         }
         while(true)
         {
            if(!_loc7_)
            {
               §§goto(addr135);
            }
            §§goto(addr154);
         }
      }
      
      public function verifySeparatedSignature(param1:IDataInput, param2:ByteArray, param3:ByteArray) : Boolean
      {
         var headerPosition:int = 0;
         var header:String = null;
         var signedDataLenght:int = 0;
         var cryptedData:ByteArray = null;
         var sigData:ByteArray = null;
         var tsDecrypt:uint = 0;
         var f:File = null;
         var fs:FileStream = null;
         var sigHeader:String = null;
         var sigVersion:uint = 0;
         var sigFileLenght:uint = 0;
         var hashType:uint = 0;
         var sigHash:String = null;
         var tsHash:uint = 0;
         var contentHash:String = null;
         var sigDate:Date = null;
         var swfContent:IDataInput = param1;
         var signatureFile:ByteArray = param2;
         var output:ByteArray = param3;
         if(!this._keyV2)
         {
            throw new SignatureError("No key for this signature version");
         }
         try
         {
            headerPosition = signatureFile.bytesAvailable - ANKAMA_SIGNED_FILE_HEADER.length;
            signatureFile["position"] = headerPosition;
            header = signatureFile.readUTFBytes(4);
            if(header != ANKAMA_SIGNED_FILE_HEADER)
            {
               return false;
            }
            signatureFile["position"] = headerPosition - 4;
            signedDataLenght = signatureFile.readShort();
            signatureFile["position"] = headerPosition - 4 - signedDataLenght;
            cryptedData = new ByteArray();
            signatureFile.readBytes(cryptedData,0,signedDataLenght);
            sigData = new ByteArray();
            tsDecrypt = getTimer();
            this._keyV2.verify(cryptedData,sigData,cryptedData.length);
            trace("Décryptage en " + (getTimer() - tsDecrypt) + " ms");
            f = new File(File.applicationDirectory.resolvePath("log.bin").nativePath);
            fs = new FileStream();
            fs.open(f,FileMode.WRITE);
            fs.writeBytes(sigData);
            fs.close();
            sigData.position = 0;
            sigHeader = sigData.readUTF();
            if(sigHeader != SIGNATURE_HEADER)
            {
               trace("Header crypté de signature incorrect, " + SIGNATURE_HEADER + " attendu, lu :" + sigHeader);
               return false;
            }
            sigVersion = sigData.readByte();
            sigData.readInt();
            sigData.readInt();
            sigFileLenght = sigData.readInt();
            if(sigFileLenght != (swfContent as ByteArray).length)
            {
               trace("Longueur de fichier incorrect, " + sigFileLenght + " attendu, lu :" + (swfContent as ByteArray).length);
               return false;
            }
            hashType = sigData.readByte();
            sigHash = sigData.readUTF();
            swfContent["position"] = 0;
            swfContent.readBytes(output,0,swfContent.bytesAvailable);
            tsHash = getTimer();
            switch(hashType)
            {
               case 0:
                  contentHash = MD5.hashBytes(output);
                  break;
               case 1:
                  contentHash = SHA256.hashBytes(output);
                  break;
               default:
                  return false;
            }
            output.position = 0;
            trace("Hash en " + (getTimer() - tsHash) + " ms");
            sigDate = new Date();
            sigDate.setTime(sigData.readDouble());
            trace(sigDate);
            if(sigHash != contentHash)
            {
               trace("Hash incorrect, " + sigHash + " attendu, lu :" + contentHash);
               return false;
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
            return false;
         }
         return true;
      }
      
      private function traceData(param1:ByteArray) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = true;
         §§push([]);
         if(!_loc4_)
         {
            §§push(§§pop());
         }
         var _loc2_:* = §§pop();
         §§push(0);
         if(!_loc5_)
         {
            §§push((-(§§pop() - 7) - 1 + 1 - 111) * 14 - 1);
         }
         var _loc3_:* = uint(§§pop());
         if(_loc5_)
         {
            while(_loc3_ < param1.length)
            {
               _loc2_[_loc3_] = param1[_loc3_];
               if(!_loc4_)
               {
                  §§push(_loc3_);
                  if(_loc5_)
                  {
                     §§push(uint(§§pop() + 1));
                  }
                  _loc3_ = §§pop();
               }
            }
            if(!_loc4_)
            {
               trace(_loc2_.join(","));
            }
         }
      }
   }
}
