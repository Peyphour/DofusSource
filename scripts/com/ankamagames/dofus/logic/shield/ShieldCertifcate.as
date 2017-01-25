package com.ankamagames.dofus.logic.shield
{
   import by.blooddy.crypto.MD5;
   import by.blooddy.crypto.SHA256;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.hurlant.crypto.symmetric.AESKey;
   import com.hurlant.crypto.symmetric.ECBMode;
   import flash.filesystem.File;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.getQualifiedClassName;
   
   public class ShieldCertifcate
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ShieldCertifcate));
      
      public static const HEADER_BEGIN:String = "SV";
      
      public static const HEADER_V1:String = HEADER_BEGIN + "1";
      
      public static const HEADER_V2:String = HEADER_BEGIN + "2";
      
      public static const HEADER_V3:String = HEADER_BEGIN + "3";
       
      
      public var version:uint;
      
      public var id:uint;
      
      public var content:String;
      
      public var useBasicNetworkInfo:Boolean;
      
      public var useAdvancedNetworkInfo:Boolean;
      
      public var useBasicInfo:Boolean;
      
      public var useUserInfo:Boolean;
      
      public var filterVirtualNetwork:Boolean;
      
      public function ShieldCertifcate(param1:uint = 3)
      {
         super();
         switch(param1)
         {
            case 1:
               this.useAdvancedNetworkInfo = false;
               this.useBasicNetworkInfo = false;
               this.useBasicInfo = false;
               this.useUserInfo = false;
               this.filterVirtualNetwork = false;
               break;
            case 2:
               this.useAdvancedNetworkInfo = true;
               this.useBasicNetworkInfo = true;
               this.useBasicInfo = true;
               this.useUserInfo = true;
               this.filterVirtualNetwork = false;
               break;
            case 3:
               this.useAdvancedNetworkInfo = false;
               this.useBasicNetworkInfo = true;
               this.useBasicInfo = true;
               this.useUserInfo = true;
               this.filterVirtualNetwork = true;
         }
      }
      
      public static function fromRaw(param1:IDataInput, param2:ShieldCertifcate = null) : ShieldCertifcate
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc3_:ShieldCertifcate = !!param2?param2:new ShieldCertifcate();
         param1["position"] = 0;
         var _loc4_:String = param1.readUTFBytes(3);
         if(_loc4_.substr(0,2) != HEADER_BEGIN)
         {
            _loc4_ = HEADER_V1;
         }
         switch(_loc4_)
         {
            case HEADER_V1:
               _loc3_.version = 1;
               param1["position"] = 0;
               _loc3_.id = param1.readUnsignedInt();
               _loc3_.content = param1.readUTF();
               _loc3_.useAdvancedNetworkInfo = false;
               _loc3_.useBasicNetworkInfo = false;
               _loc3_.useBasicInfo = false;
               _loc3_.useUserInfo = false;
               _loc3_.filterVirtualNetwork = false;
               break;
            case HEADER_V2:
               _loc3_.version = 2;
               _loc3_.id = param1.readUnsignedInt();
               _loc3_.useAdvancedNetworkInfo = true;
               _loc3_.useBasicNetworkInfo = true;
               _loc3_.useBasicInfo = true;
               _loc3_.useUserInfo = true;
               _loc3_.filterVirtualNetwork = false;
               _loc3_.content = _loc3_.decrypt(param1);
               break;
            case HEADER_V3:
               _loc3_.version = 3;
               _loc3_.id = param1.readUnsignedInt();
               _loc5_ = param1.readShort();
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc3_[param1.readUTF()] = param1.readBoolean();
                  _loc6_++;
               }
               _loc3_.content = _loc3_.decrypt(param1);
         }
         return _loc3_;
      }
      
      public function set secureLevel(param1:uint) : void
      {
         switch(param1)
         {
            case ShieldSecureLevel.LOW:
               this.useAdvancedNetworkInfo = false;
               this.useBasicNetworkInfo = false;
               this.useBasicInfo = false;
               this.useUserInfo = false;
               this.filterVirtualNetwork = false;
               break;
            case ShieldSecureLevel.MEDIUM:
               this.useAdvancedNetworkInfo = false;
               this.useBasicNetworkInfo = false;
               this.useBasicInfo = true;
               this.useUserInfo = true;
               this.filterVirtualNetwork = false;
               break;
            case ShieldSecureLevel.MAX:
               this.useAdvancedNetworkInfo = true;
               this.useBasicNetworkInfo = true;
               this.useBasicInfo = true;
               this.useUserInfo = true;
               this.filterVirtualNetwork = true;
         }
      }
      
      public function get hash() : String
      {
         return this.getHash();
      }
      
      public function get reverseHash() : String
      {
         return this.getHash(true);
      }
      
      public function serialize() : ByteArray
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc1_:ByteArray = new ByteArray();
         switch(this.version)
         {
            case 1:
               throw new Error("No more supported");
            case 2:
               _loc1_.writeUTFBytes(HEADER_V2);
               _loc1_.writeUnsignedInt(this.id);
               _loc1_.writeUTFBytes(this.content);
               break;
            case 3:
               _loc1_.writeUTFBytes(HEADER_V3);
               _loc1_.writeUnsignedInt(this.id);
               _loc2_ = ["useBasicInfo","useBasicNetworkInfo","useAdvancedNetworkInfo","useUserInfo"];
               _loc1_.writeShort(_loc2_.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc1_.writeUTF(_loc2_[_loc3_]);
                  _loc1_.writeBoolean(this[_loc2_[_loc3_]]);
                  _loc3_++;
               }
               _loc1_.writeUTFBytes(this.content);
         }
         return _loc1_;
      }
      
      public function toNetwork() : TrustCertificate
      {
         var _loc1_:TrustCertificate = new TrustCertificate();
         var _loc2_:String = SHA256.hash(this.getHash() + this.content);
         _loc1_.initTrustCertificate(this.id,_loc2_);
         return _loc1_;
      }
      
      private function decrypt(param1:IDataInput) : String
      {
         var _loc4_:Boolean = false;
         var data:IDataInput = param1;
         if(_loc5_)
         {
            if(_loc4_)
            {
               addr28:
               while(true)
               {
                  key.writeUTFBytes(this.getHash(true));
                  if(!_loc4_)
                  {
                     if(_loc5_)
                     {
                     }
                     var aesKey:AESKey = new AESKey(key);
                     if(!_loc4_)
                     {
                     }
                     addr68:
                     var ecb:ECBMode = new ECBMode(aesKey);
                     break;
                  }
                  break;
               }
               if(_loc5_)
               {
               }
               var cryptedData:ByteArray = Base64.decodeToByteArray(data.readUTFBytes(data.bytesAvailable));
            }
            while(true)
            {
               var key:ByteArray = new ByteArray();
               if(_loc5_)
               {
                  if(!_loc4_)
                  {
                     §§goto(addr28);
                  }
                  §§goto(addr68);
               }
               break;
            }
         }
         if(!_loc4_)
         {
         }
         try
         {
            ecb.decrypt(cryptedData);
         }
         catch(e:Error)
         {
            if(_loc5_)
            {
               _log.error("Certificat V2 non valide (clef invalide)");
            }
            return null;
         }
         §§push(cryptedData);
         §§push(0);
         if(_loc4_)
         {
            §§push((§§pop() * 8 - 104 + 37 - 31) * 75 + 44);
         }
         §§pop().position = §§pop();
         return cryptedData.readUTFBytes(cryptedData.length);
      }
      
      private function getHash(param1:Boolean = false) : String
      {
         var virtualNetworkRegExpr:RegExp = null;
         if(_loc6_)
         {
            continue loop0;
         }
         continue loop3;
      }
      
      private function traceInfo(param1:*, param2:uint = 5, param3:String = "") : void
      {
         if(_loc5_)
         {
            _log.info("-----------");
            if(_loc4_)
            {
               loop0:
               while(true)
               {
                  §§push(_log);
                  §§push("displayName : ");
                  if(_loc5_)
                  {
                     §§push(§§pop() + param1.displayName);
                  }
                  §§pop().info(§§pop());
                  if(_loc4_)
                  {
                     addr37:
                     while(true)
                     {
                        §§push(_log);
                        §§push("hardwareAddress : ");
                        if(!_loc4_)
                        {
                           §§push(§§pop() + param1.hardwareAddress);
                        }
                        §§pop().info(§§pop());
                        if(!_loc4_)
                        {
                        }
                        break;
                     }
                     while(true)
                     {
                        §§push(_log);
                        §§push("name : ");
                        if(_loc5_)
                        {
                           §§push(§§pop() + param1.hardwareAddress);
                        }
                        §§pop().info(§§pop());
                        if(!_loc5_)
                        {
                           addr95:
                           §§push(Boolean(param1.parent));
                           if(!_loc4_)
                           {
                              if(§§pop())
                              {
                                 if(!_loc4_)
                                 {
                                    §§pop();
                                    if(_loc5_)
                                    {
                                    }
                                    §§push(Boolean(param2));
                                 }
                              }
                           }
                           addr128:
                           if(!§§pop())
                           {
                           }
                           return;
                        }
                        continue loop0;
                     }
                  }
                  while(true)
                  {
                     §§push(_log);
                     §§push("parent : ");
                     if(_loc5_)
                     {
                        §§push(§§pop() + param1.parent);
                     }
                     §§pop().info(§§pop());
                     if(_loc5_)
                     {
                     }
                     break;
                  }
                  §§goto(addr95);
               }
            }
            while(true)
            {
               §§push(_log);
               §§push("active : ");
               if(!_loc4_)
               {
                  §§push(§§pop() + param1.active);
               }
               §§pop().info(§§pop());
               if(_loc4_)
               {
                  §§goto(addr82);
               }
               §§goto(addr37);
            }
         }
         this.traceInfo(param1.parent,param2--,param3 + "...");
         §§goto(addr128);
      }
   }
}
