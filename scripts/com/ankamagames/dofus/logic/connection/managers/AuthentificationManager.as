package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ClientInstallTypeEnum;
   import com.ankamagames.dofus.network.enums.ClientTechnologyEnum;
   import com.ankamagames.dofus.network.messages.connection.IdentificationAccountForceMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationMessage;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.crypto.RSA;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.NullPad;
   import com.hurlant.util.der.PEM;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class AuthentificationManager implements IDestroyable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationManager));
      
      private static var _self:AuthentificationManager;
      
      private static const AES_KEY_LENGTH:uint = 32;
      
      private static const PUBLIC_KEY_V2:Class = AuthentificationManager_PUBLIC_KEY_V2;
       
      
      private var _publicKey:String;
      
      private var _salt:String;
      
      private var _lva:LoginValidationAction;
      
      private var _certificate:TrustCertificate;
      
      private var _AESKey:ByteArray;
      
      private var _verifyKey:Class;
      
      private var _gameServerTicket:String;
      
      public var ankamaPortalKey:String;
      
      public var username:String;
      
      public var nextToken:String;
      
      public var tokenMode:Boolean = false;
      
      public function AuthentificationManager()
      {
         this._verifyKey = AuthentificationManager__verifyKey;
         super();
         if(_self != null)
         {
            throw new SingletonError("AuthentificationManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : AuthentificationManager
      {
         if(_self == null)
         {
            _self = new AuthentificationManager();
         }
         return _self;
      }
      
      public function get gameServerTicket() : String
      {
         return this._gameServerTicket;
      }
      
      public function set gameServerTicket(param1:String) : void
      {
         this._gameServerTicket = param1;
      }
      
      public function get salt() : String
      {
         return this._salt;
      }
      
      public function initAESKey() : void
      {
         this._AESKey = this.generateRandomAESKey();
      }
      
      public function decodeWithAES(param1:*) : ByteArray
      {
         var _loc4_:int = 0;
         var _loc2_:ICipher = Crypto.getCipher("simple-aes256-cbc",this._AESKey,new NullPad());
         this._AESKey.position = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(this._AESKey,0,16);
         if(param1 is Vector.<int> || param1 is Vector.<uint>)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc3_.writeByte(param1[_loc4_]);
               _loc4_++;
            }
         }
         else if(param1 is ByteArray)
         {
            _loc3_.writeBytes(param1 as ByteArray);
         }
         else
         {
            throw new ArgumentError("Argument must be a bytearray or a vector of int/uint");
         }
         _loc2_.decrypt(_loc3_);
         return _loc3_;
      }
      
      public function setSalt(param1:String) : void
      {
         this._salt = param1;
         if(this._salt.length < 32)
         {
            _log.warn("Authentification salt size is lower than 32 ");
            while(this._salt.length < 32)
            {
               this._salt = this._salt + " ";
            }
         }
      }
      
      public function setPublicKey(param1:Vector.<int>) : void
      {
         var commonMod:Object = null;
         var publicKey:Vector.<int> = param1;
         var baSignedKey:ByteArray = new ByteArray();
         var i:int = 0;
         while(i < publicKey.length)
         {
            baSignedKey.writeByte(publicKey[i]);
            i++;
         }
         baSignedKey.position = 0;
         var key:ByteArray = new ByteArray();
         var readKey:RSAKey = PEM.readRSAPublicKey((new this._verifyKey() as ByteArray).readUTFBytes((new this._verifyKey() as ByteArray).length));
         try
         {
            readKey.verify(baSignedKey,key,baSignedKey.length);
         }
         catch(e:Error)
         {
            commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.server.authentificationImpossible"),[I18n.getUiText("ui.common.ok")]);
            return;
         }
         this._publicKey = "-----BEGIN PUBLIC KEY-----\n" + Base64.encodeByteArray(key) + "-----END PUBLIC KEY-----";
      }
      
      public function setValidationAction(param1:LoginValidationAction) : void
      {
         this.username = param1["username"];
         this._lva = param1;
         this._certificate = SecureModeManager.getInstance().retreiveCertificate();
         ProtectPishingFrame.setPasswordHash(MD5.hash(param1.password.toUpperCase()),param1.password.length);
      }
      
      public function get loginValidationAction() : LoginValidationAction
      {
         return this._lva;
      }
      
      public function get canAutoConnectWithToken() : Boolean
      {
         return this.nextToken != null;
      }
      
      public function get isLoggingWithTicket() : Boolean
      {
         return this._lva is LoginValidationWithTicketAction;
      }
      
      public function getIdentificationMessage() : IdentificationMessage
      {
         var _loc2_:IdentificationMessage = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:IdentificationAccountForceMessage = null;
         var _loc1_:uint = BuildInfos.BUILD_VERSION.buildType;
         if(AirScanner.isStreamingVersion() && BuildInfos.BUILD_VERSION.buildType == BuildTypeEnum.BETA)
         {
            _loc1_ = BuildTypeEnum.RELEASE;
         }
         if(this._lva.username.indexOf("|") == -1)
         {
            _loc2_ = new IdentificationMessage();
            if(this._lva is LoginValidationWithTicketAction || this.nextToken)
            {
               _loc3_ = !!this.nextToken?this.nextToken:LoginValidationWithTicketAction(this._lva).ticket;
               this.nextToken = null;
               this.ankamaPortalKey = this.cipherMd5String(_loc3_);
               _loc2_.initIdentificationMessage(_loc2_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this.cipherRsa("   ",_loc3_,this._certificate),this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,true);
            }
            else
            {
               this.ankamaPortalKey = this.cipherMd5String(this._lva.password);
               _loc2_.initIdentificationMessage(_loc2_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this.cipherRsa(this._lva.username,this._lva.password,this._certificate),this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,false);
            }
            _loc2_.version.initVersionExtended(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.release,BuildInfos.BUILD_REVISION,BuildInfos.BUILD_PATCH,_loc1_,!!AirScanner.isStreamingVersion()?uint(ClientInstallTypeEnum.CLIENT_STREAMING):uint(ClientInstallTypeEnum.CLIENT_BUNDLE),!!AirScanner.hasAir()?uint(ClientTechnologyEnum.CLIENT_AIR):uint(ClientTechnologyEnum.CLIENT_FLASH));
            return _loc2_;
         }
         this.ankamaPortalKey = this.cipherMd5String(this._lva.password);
         _loc4_ = this._lva.username.split("|");
         _loc5_ = new IdentificationAccountForceMessage();
         _loc5_.initIdentificationAccountForceMessage(_loc5_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this.cipherRsa(_loc4_[0],this._lva.password,this._certificate),this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,false,0,null,_loc4_[1]);
         _loc5_.version.initVersionExtended(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.release,BuildInfos.BUILD_REVISION,BuildInfos.BUILD_PATCH,_loc1_,!!AirScanner.isStreamingVersion()?uint(ClientInstallTypeEnum.CLIENT_STREAMING):uint(ClientInstallTypeEnum.CLIENT_BUNDLE),!!AirScanner.hasAir()?uint(ClientTechnologyEnum.CLIENT_AIR):uint(ClientTechnologyEnum.CLIENT_FLASH));
         return _loc5_;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      private function cipherMd5String(param1:String) : String
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = true;
         return MD5.hash(param1 + this._salt);
      }
      
      private function cipherRsa(param1:String, param2:String, param3:TrustCertificate) : Vector.<int>
      {
         if(_loc6_)
         {
            var baOut:ByteArray = null;
            if(!_loc7_)
            {
               if(!_loc7_)
               {
               }
               var debugOutput:ByteArray = null;
               if(!_loc6_)
               {
                  addr38:
                  while(true)
                  {
                     var certificate:TrustCertificate = param3;
                  }
               }
               while(true)
               {
                  §§push(_loc4_);
                  §§push(0);
                  if(_loc7_)
                  {
                     §§push(-(--(§§pop() * 51) * 87 + 1 + 1));
                  }
                  var /*UnknownSlot*/:* = §§pop();
                  if(!_loc6_)
                  {
                     addr110:
                     baIn.writeBytes(this._AESKey);
                  }
                  else
                  {
                     loop2:
                     while(true)
                     {
                        var login:String = param1;
                        if(_loc6_)
                        {
                           if(!_loc7_)
                           {
                           }
                           var pwd:String = param2;
                           if(!_loc7_)
                           {
                              §§goto(addr38);
                           }
                           addr81:
                           while(true)
                           {
                              var baIn:ByteArray = new ByteArray();
                              if(!_loc6_)
                              {
                                 break loop2;
                              }
                              addr47:
                              while(true)
                              {
                                 baIn.writeUTFBytes(this._salt);
                                 if(_loc6_)
                                 {
                                    if(_loc7_)
                                    {
                                       continue loop2;
                                    }
                                    §§goto(addr110);
                                 }
                                 break;
                              }
                              if(!_loc6_)
                              {
                                 addr142:
                                 while(true)
                                 {
                                    baIn.writeUTFBytes(login);
                                    if(_loc6_)
                                    {
                                    }
                                    break;
                                 }
                                 baIn.writeUTFBytes(pwd);
                                 if(_loc6_)
                                 {
                                 }
                                 try
                                 {
                                    §§push(Boolean(File.applicationDirectory.resolvePath("debug-login.txt")));
                                    if(_loc6_)
                                    {
                                       if(!§§pop())
                                       {
                                          if(_loc6_)
                                          {
                                             §§pop();
                                             if(_loc6_)
                                             {
                                             }
                                             §§push(Boolean(File.applicationDirectory.resolvePath("debuglogin.txt")));
                                          }
                                       }
                                    }
                                    if(§§pop())
                                    {
                                       _log.debug("login with certificate");
                                       if(!_loc7_)
                                       {
                                       }
                                       debugOutput = new ByteArray();
                                       if(!_loc7_)
                                       {
                                       }
                                       §§push(baIn);
                                       §§push(0);
                                       if(!_loc6_)
                                       {
                                          §§push((§§pop() - 114 - 1 - 92) * 115 * 118 - 104);
                                       }
                                       §§pop().position = §§pop();
                                       if(_loc7_)
                                       {
                                          addr239:
                                          while(true)
                                          {
                                             debugOutput = RSA.publicEncrypt((new PUBLIC_KEY_V2() as ByteArray).readUTFBytes((new PUBLIC_KEY_V2() as ByteArray).length),baIn);
                                             if(_loc6_)
                                             {
                                             }
                                             §§push(_log);
                                             §§push("Login info (RSA Encrypted, ");
                                             if(_loc6_)
                                             {
                                                §§push(§§pop() + debugOutput.length);
                                                if(!_loc7_)
                                                {
                                                   §§push(§§pop() + " bytes) : ");
                                                   if(_loc7_)
                                                   {
                                                   }
                                                }
                                                addr282:
                                                §§pop().debug(§§pop());
                                                if(_loc6_)
                                                {
                                                }
                                                break;
                                             }
                                             §§goto(addr282);
                                          }
                                       }
                                       while(true)
                                       {
                                          §§push(debugOutput);
                                          §§push(0);
                                          if(_loc7_)
                                          {
                                             §§push(-§§pop() * 88 - 34 + 24);
                                          }
                                          §§pop().position = §§pop();
                                          if(_loc6_)
                                          {
                                             §§goto(addr239);
                                          }
                                       }
                                    }
                                 }
                                 catch(e:Error)
                                 {
                                    if(_loc6_)
                                    {
                                       §§push(_log);
                                       §§push("Erreur lors du log des informations de login ");
                                       if(!_loc7_)
                                       {
                                          §§push(§§pop() + e.getStackTrace());
                                       }
                                       §§pop().error(§§pop());
                                    }
                                 }
                                 baOut = RSA.publicEncrypt(this._publicKey,baIn);
                                 if(!_loc7_)
                                 {
                                    if(!_loc6_)
                                    {
                                       loop4:
                                       while(true)
                                       {
                                          §§push(baOut);
                                          §§push(0);
                                          if(!_loc6_)
                                          {
                                             §§push(-(-§§pop() - 67) - 1 + 13 + 1);
                                          }
                                          §§pop().position = §§pop();
                                          if(_loc6_)
                                          {
                                             if(_loc6_)
                                             {
                                                if(!_loc7_)
                                                {
                                                }
                                                addr389:
                                                §§push(_loc4_);
                                                §§push(0);
                                                if(!_loc6_)
                                                {
                                                   §§push(§§pop() + 102 + 8 + 1);
                                                }
                                                var /*UnknownSlot*/:* = §§pop();
                                                if(_loc6_)
                                                {
                                                   break;
                                                }
                                             }
                                             addr384:
                                             while(true)
                                             {
                                                if(_loc7_)
                                                {
                                                   §§goto(addr389);
                                                }
                                                else
                                                {
                                                   continue loop4;
                                                }
                                             }
                                          }
                                          break;
                                       }
                                       if(_loc6_)
                                       {
                                       }
                                       while(true)
                                       {
                                          §§push(baOut.bytesAvailable);
                                          §§push(0);
                                          if(!_loc6_)
                                          {
                                             §§push(§§pop() * 37 + 1 + 5 - 99);
                                          }
                                          if(§§pop() == §§pop())
                                          {
                                             break;
                                          }
                                          if(!_loc6_)
                                          {
                                             loop6:
                                             while(true)
                                             {
                                                ret[i] = n;
                                                if(!_loc7_)
                                                {
                                                   if(!_loc7_)
                                                   {
                                                      if(_loc6_)
                                                      {
                                                      }
                                                      §§push(i);
                                                      if(_loc6_)
                                                      {
                                                         §§push(§§pop() + 1);
                                                      }
                                                      var i:int = §§pop();
                                                   }
                                                   addr448:
                                                   while(!_loc7_)
                                                   {
                                                      continue loop6;
                                                   }
                                                   break;
                                                }
                                                if(!_loc7_)
                                                {
                                                   break;
                                                }
                                             }
                                             continue;
                                          }
                                          while(true)
                                          {
                                             var n:int = baOut.readByte();
                                             §§goto(addr448);
                                          }
                                       }
                                    }
                                    while(true)
                                    {
                                       var ret:Vector.<int> = new Vector.<int>();
                                       §§goto(addr384);
                                    }
                                 }
                                 if(_loc6_)
                                 {
                                 }
                                 return ret;
                              }
                              while(true)
                              {
                                 baIn.writeByte(login.length);
                                 if(!_loc7_)
                                 {
                                    §§goto(addr142);
                                 }
                                 §§goto(addr164);
                              }
                           }
                        }
                     }
                     continue;
                  }
                  if(_loc6_)
                  {
                  }
                  if(!certificate)
                  {
                  }
                  §§goto(addr153);
               }
            }
            while(true)
            {
               if(!_loc6_)
               {
                  §§goto(addr47);
               }
               §§goto(addr81);
            }
         }
         baIn.writeUnsignedInt(certificate.id);
         if(_loc6_)
         {
         }
         baIn.writeUTFBytes(certificate.hash);
         §§goto(addr137);
      }
      
      private function generateRandomAESKey() : ByteArray
      {
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = false;
         var _loc1_:ByteArray = new ByteArray();
         §§push(0);
         if(!_loc3_)
         {
            §§push((-(§§pop() - 101) + 1) * 4);
         }
         var _loc2_:* = §§pop();
         if(_loc3_)
         {
            while(_loc2_ < AES_KEY_LENGTH)
            {
               §§push(_loc1_);
               §§push(_loc2_);
               §§push(Math);
               §§push(Math.random());
               §§push(256);
               if(_loc4_)
               {
                  §§push(-((§§pop() + 1 - 64) * 3 - 117 + 1) + 1);
               }
               §§pop()[§§pop()] = §§pop().floor(§§pop() * §§pop());
               if(_loc3_)
               {
                  _loc2_++;
               }
            }
         }
         return _loc1_;
      }
   }
}
