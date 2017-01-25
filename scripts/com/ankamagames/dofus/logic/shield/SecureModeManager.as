package com.ankamagames.dofus.logic.shield
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.RpcServiceManager;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.dofus.types.events.RpcEvent;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class SecureModeManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SecureModeManager));
      
      private static const VALIDATECODE_CODEEXPIRE:String = "CODEEXPIRE";
      
      private static const VALIDATECODE_CODEBADCODE:String = "CODEBADCODE";
      
      private static const VALIDATECODE_CODENOTFOUND:String = "CODENOTFOUND";
      
      private static const VALIDATECODE_SECURITY:String = "SECURITY";
      
      private static const VALIDATECODE_TOOMANYCERTIFICATE:String = "TOOMANYCERTIFICATE";
      
      private static const VALIDATECODE_NOTAVAILABLE:String = "NOTAVAILABLE";
      
      private static const ACCOUNT_AUTHENTIFICATION_FAILED:String = "ACCOUNT_AUTHENTIFICATION_FAILED";
      
      private static var RPC_URL:String;
      
      private static const RPC_METHOD_SECURITY_CODE:String = "SecurityCode";
      
      private static const RPC_METHOD_VALIDATE_CODE:String = "ValidateCode";
      
      private static const RPC_METHOD_MIGRATE:String = "Migrate";
      
      private static var _self:SecureModeManager;
       
      
      private var _timeout:Timer;
      
      private var _active:Boolean;
      
      private var _computerName:String;
      
      private var _methodsCallback:Dictionary;
      
      private var _hasV1Certif:Boolean;
      
      private var _rpcManager:RpcServiceManager;
      
      public var shieldLevel:uint;
      
      public function SecureModeManager()
      {
         this._timeout = new Timer(30000);
         this._methodsCallback = new Dictionary();
         this.shieldLevel = StoreDataManager.getInstance().getSetData(Constants.DATASTORE_COMPUTER_OPTIONS,"shieldLevel",ShieldSecureLevel.MEDIUM);
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.initRPC();
      }
      
      public static function getInstance() : SecureModeManager
      {
         if(!_self)
         {
            _self = new SecureModeManager();
         }
         return _self;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         KernelEventsManager.getInstance().processCallback(HookList.SecureModeChange,param1);
      }
      
      public function get computerName() : String
      {
         return this._computerName;
      }
      
      public function set computerName(param1:String) : void
      {
         this._computerName = param1;
      }
      
      public function get certificate() : TrustCertificate
      {
         return this.retreiveCertificate();
      }
      
      public function askCode(param1:Function) : void
      {
         this._methodsCallback[RPC_METHOD_SECURITY_CODE] = param1;
         this._rpcManager.callMethod(RPC_METHOD_SECURITY_CODE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1]);
      }
      
      public function sendCode(param1:String, param2:Function) : void
      {
         var _loc3_:ShieldCertifcate = new ShieldCertifcate();
         _loc3_.secureLevel = this.shieldLevel;
         this._methodsCallback[RPC_METHOD_VALIDATE_CODE] = param2;
         this._rpcManager.callMethod(RPC_METHOD_VALIDATE_CODE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1,param1.toUpperCase(),_loc3_.hash,_loc3_.reverseHash,!!this._computerName?true:false,!!this._computerName?this._computerName:""]);
      }
      
      private function initRPC() : void
      {
         var _loc2_:Boolean = false;
         §§push(BuildInfos.BUILD_TYPE);
         if(!_loc2_)
         {
            §§push(BuildTypeEnum.DEBUG);
            if(!_loc2_)
            {
               §§push(§§pop() == §§pop());
               if(_loc1_)
               {
                  if(!§§pop())
                  {
                     if(_loc2_)
                     {
                     }
                  }
                  addr42:
                  if(§§pop())
                  {
                     if(_loc1_)
                     {
                        RPC_URL = "http://api.ankama.tst/ankama/shield.json";
                     }
                     addr100:
                     while(true)
                     {
                        this._rpcManager = new RpcServiceManager(RPC_URL,"json");
                        if(!_loc2_)
                        {
                           loop1:
                           while(true)
                           {
                              this._rpcManager.addEventListener(RpcEvent.EVENT_DATA,this.onRpcData);
                              if(_loc2_)
                              {
                                 break;
                              }
                              addr70:
                              while(true)
                              {
                                 this._rpcManager.addEventListener(RpcEvent.EVENT_ERROR,this.onRpcData);
                                 if(!_loc1_)
                                 {
                                    continue loop1;
                                 }
                              }
                           }
                           continue;
                        }
                        return;
                     }
                  }
                  else
                  {
                     addr55:
                     §§push(BuildInfos.BUILD_TYPE);
                     §§push(BuildTypeEnum.TESTING);
                  }
                  addr65:
                  if(_loc2_)
                  {
                     §§goto(addr70);
                  }
                  §§goto(addr100);
               }
               §§pop();
               §§push(BuildInfos.BUILD_TYPE);
               if(_loc2_)
               {
               }
               §§goto(addr55);
            }
            addr57:
            if(§§pop() == §§pop())
            {
               RPC_URL = "http://api.ankama.lan/ankama/shield.json";
            }
            else
            {
               RPC_URL = "https://api.ankama.com/ankama/shield.json";
               §§goto(addr65);
            }
            §§goto(addr100);
         }
         §§push(BuildTypeEnum.INTERNAL);
         if(_loc1_)
         {
            §§goto(addr42);
            §§push(§§pop() == §§pop());
         }
         §§goto(addr57);
      }
      
      private function getUsername() : String
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = true;
         §§push(AuthentificationManager.getInstance().username.toLowerCase().split("|"));
         §§push(0);
         if(!_loc2_)
         {
            §§push(§§pop() + 77 + 1 + 36);
         }
         return §§pop()[§§pop()];
      }
      
      private function parseRpcValidateResponse(param1:Object, param2:String) : Object
      {
         if(_loc7_)
         {
            _loc3_.error = param1.error;
            if(!_loc6_)
            {
               if(_loc6_)
               {
                  addr33:
                  while(true)
                  {
                     _loc3_.retry = false;
                     if(_loc7_)
                     {
                        if(_loc7_)
                        {
                        }
                        addr54:
                        _loc3_.text = "";
                        if(_loc7_)
                        {
                           break;
                        }
                     }
                     break;
                  }
               }
               while(true)
               {
                  _loc3_.fatal = false;
                  if(_loc7_)
                  {
                     if(!_loc6_)
                     {
                        §§goto(addr33);
                     }
                     §§goto(addr54);
                  }
               }
            }
            if(!_loc6_)
            {
            }
            if(!_loc6_)
            {
               if(VALIDATECODE_CODEEXPIRE === _loc5_)
               {
                  §§push(0);
                  if(!_loc7_)
                  {
                     §§push(-§§pop() + 1 + 1 - 1);
                  }
               }
               else if(VALIDATECODE_CODEBADCODE === _loc5_)
               {
                  §§push(1);
                  if(!_loc7_)
                  {
                     §§push((§§pop() - 1) * 82 * 6 + 99);
                  }
                  if(!_loc7_)
                  {
                     addr360:
                  }
               }
               else if(VALIDATECODE_CODENOTFOUND !== _loc5_)
               {
                  if(VALIDATECODE_SECURITY === _loc5_)
                  {
                     §§push(3);
                     if(_loc6_)
                     {
                        §§push(-(-(§§pop() - 34) - 1) - 1 - 1);
                     }
                  }
                  else if(VALIDATECODE_TOOMANYCERTIFICATE === _loc5_)
                  {
                     §§push(4);
                     if(_loc6_)
                     {
                        §§push((§§pop() + 15) * 39 + 1);
                     }
                     §§goto(addr360);
                  }
                  else
                  {
                     §§push(VALIDATECODE_NOTAVAILABLE);
                     if(!_loc6_)
                     {
                        if(§§pop() === _loc5_)
                        {
                           §§push(5);
                           if(!_loc7_)
                           {
                              §§push(--(§§pop() - 81));
                           }
                        }
                        else
                        {
                           §§push(ACCOUNT_AUTHENTIFICATION_FAILED);
                        }
                     }
                     if(§§pop() === _loc5_)
                     {
                        §§push(6);
                        if(!_loc7_)
                        {
                           §§push(---(§§pop() - 1 - 76));
                        }
                        if(!_loc7_)
                        {
                        }
                     }
                     else
                     {
                        §§push(7);
                        if(_loc6_)
                        {
                           §§push(-((§§pop() - 36) * 49 - 1 + 50 + 1 - 1));
                        }
                     }
                  }
               }
               addr407:
               loop16:
               switch(§§pop())
               {
                  case 0:
                     if(!_loc7_)
                     {
                        addr69:
                        while(true)
                        {
                           _loc3_.fatal = true;
                           if(_loc7_)
                           {
                           }
                           break;
                        }
                        §§push(Boolean(param1.certificate));
                        if(!_loc6_)
                        {
                           §§push(§§pop());
                           if(_loc7_)
                           {
                              if(§§pop())
                              {
                                 if(!_loc6_)
                                 {
                                    §§pop();
                                    §§push(Boolean(param1.id));
                                    if(!_loc7_)
                                    {
                                    }
                                 }
                                 addr446:
                                 §§push(§§pop());
                              }
                              if(§§pop())
                              {
                                 §§push(this.addCertificate(param1.id,param1.certificate,this.shieldLevel));
                                 if(!_loc6_)
                                 {
                                    §§push(Boolean(§§pop()));
                                    if(_loc6_)
                                    {
                                    }
                                 }
                                 §§goto(addr446);
                              }
                              addr457:
                              return _loc3_;
                           }
                        }
                        if(!§§pop())
                        {
                           _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.202.fatal");
                           _loc3_.fatal = true;
                        }
                        §§goto(addr457);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
                        if(_loc7_)
                        {
                           §§goto(addr69);
                        }
                        §§goto(addr88);
                     }
                  case 1:
                     if(!_loc7_)
                     {
                        addr97:
                        while(true)
                        {
                           _loc3_.retry = true;
                           if(_loc7_)
                           {
                           }
                           break;
                        }
                        §§goto(addr88);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.403");
                        if(_loc7_)
                        {
                           §§goto(addr97);
                        }
                        §§goto(addr116);
                     }
                  case 2:
                     if(!_loc7_)
                     {
                        addr125:
                        while(true)
                        {
                           _loc3_.fatal = true;
                           if(!_loc6_)
                           {
                           }
                           break;
                        }
                        §§goto(addr88);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (1)";
                        if(!_loc6_)
                        {
                           §§goto(addr125);
                        }
                        §§goto(addr146);
                     }
                  case 3:
                     if(!_loc7_)
                     {
                        addr155:
                        while(true)
                        {
                           _loc3_.fatal = true;
                           if(_loc7_)
                           {
                           }
                           break;
                        }
                        §§goto(addr88);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.security");
                        if(!_loc6_)
                        {
                           §§goto(addr155);
                        }
                        §§goto(addr174);
                     }
                  case 4:
                     if(_loc6_)
                     {
                        addr183:
                        while(true)
                        {
                           _loc3_.fatal = true;
                           if(_loc7_)
                           {
                           }
                           break;
                        }
                        §§goto(addr88);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.413");
                        if(!_loc6_)
                        {
                           §§goto(addr183);
                        }
                        §§goto(addr202);
                     }
                  case 5:
                     if(_loc6_)
                     {
                        addr211:
                        while(true)
                        {
                           _loc3_.fatal = true;
                           if(_loc7_)
                           {
                           }
                           break;
                        }
                        §§goto(addr88);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.202");
                        if(_loc7_)
                        {
                           if(_loc7_)
                           {
                              §§goto(addr211);
                           }
                           §§goto(addr236);
                        }
                        else
                        {
                           break loop16;
                        }
                     }
                     §§goto(addr88);
                  case 6:
                     if(!_loc7_)
                     {
                        addr245:
                        while(true)
                        {
                           _loc3_.fatal = true;
                           if(!_loc6_)
                           {
                           }
                           break;
                        }
                        §§goto(addr88);
                     }
                     while(true)
                     {
                        _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (2)";
                        if(_loc7_)
                        {
                           §§goto(addr245);
                        }
                        §§goto(addr266);
                     }
                  default:
                     _loc3_.text = !!param1.error?param1.error:I18n.getUiText("ui.secureMode.error.default");
               }
               _loc3_.fatal = true;
            }
            §§push(2);
            if(!_loc7_)
            {
               §§push(-(-((§§pop() + 1) * 4 + 1) - 1) + 98);
            }
            §§goto(addr407);
         }
         §§goto(addr88);
      }
      
      private function parseRpcASkCodeResponse(param1:Object, param2:String) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.error = !_loc3_.error;
         if(!_loc6_)
         {
            if(_loc6_)
            {
               addr29:
               while(true)
               {
                  _loc3_.retry = false;
               }
            }
            addr38:
            while(true)
            {
               _loc3_.fatal = false;
               if(_loc6_)
               {
                  break;
               }
               §§goto(addr29);
            }
            _loc3_.text = "";
            if(_loc5_)
            {
            }
            if(!param1.error)
            {
               _loc3_.domain = param1.domain;
               if(_loc5_)
               {
                  _loc3_.error = false;
               }
            }
            else
            {
               if(_loc5_)
               {
                  §§push(ACCOUNT_AUTHENTIFICATION_FAILED);
                  if(_loc5_)
                  {
                     if(§§pop() === _loc4_)
                     {
                        if(_loc5_)
                        {
                           §§push(0);
                           if(!_loc5_)
                           {
                              §§push((-(§§pop() * 83 + 1) - 28 - 97) * 77);
                           }
                        }
                        addr229:
                        loop12:
                        switch(§§pop())
                        {
                           case 0:
                              if(!_loc5_)
                              {
                                 addr72:
                                 while(true)
                                 {
                                    _loc3_.fatal = true;
                                    if(_loc5_)
                                    {
                                       if(!_loc6_)
                                       {
                                       }
                                       break;
                                    }
                                    break loop12;
                                 }
                                 return _loc3_;
                              }
                              while(true)
                              {
                                 _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (3)";
                                 if(!_loc6_)
                                 {
                                    if(_loc5_)
                                    {
                                       §§goto(addr72);
                                    }
                                    §§goto(addr98);
                                 }
                                 break;
                              }
                              loop5:
                              while(true)
                              {
                                 if(_loc6_)
                                 {
                                    addr134:
                                    break;
                                 }
                                 addr107:
                                 while(true)
                                 {
                                    _loc3_.fatal = true;
                                    if(!_loc6_)
                                    {
                                       if(!_loc6_)
                                       {
                                          break loop12;
                                       }
                                       continue loop5;
                                    }
                                    loop6:
                                    while(true)
                                    {
                                       if(!_loc6_)
                                       {
                                          addr143:
                                          while(true)
                                          {
                                             _loc3_.fatal = true;
                                             if(!_loc6_)
                                             {
                                                if(!_loc5_)
                                                {
                                                   addr154:
                                                   while(true)
                                                   {
                                                      _loc3_.text = I18n.getUiText("ui.secureMode.error.default");
                                                      continue loop6;
                                                   }
                                                }
                                                else
                                                {
                                                   break loop6;
                                                }
                                             }
                                             else
                                             {
                                                continue loop6;
                                             }
                                          }
                                       }
                                       break;
                                    }
                                    break loop5;
                                 }
                              }
                              §§goto(addr98);
                           case 1:
                              if(_loc6_)
                              {
                                 §§goto(addr107);
                              }
                              addr124:
                              while(true)
                              {
                                 _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
                                 §§goto(addr129);
                              }
                           default:
                              if(_loc6_)
                              {
                                 §§goto(addr143);
                              }
                              §§goto(addr154);
                        }
                        while(_loc6_)
                        {
                           §§goto(addr124);
                        }
                        §§goto(addr134);
                     }
                     else
                     {
                        §§push(VALIDATECODE_CODEEXPIRE);
                     }
                  }
                  if(§§pop() !== _loc4_)
                  {
                     §§push(2);
                     if(_loc6_)
                     {
                        §§push(-(§§pop() - 1) + 34);
                     }
                  }
                  §§goto(addr229);
               }
               §§push(1);
               if(_loc6_)
               {
                  §§push(--(§§pop() + 1 + 61 - 55 - 98));
               }
               if(!_loc5_)
               {
               }
               §§goto(addr229);
            }
            §§goto(addr98);
         }
         while(true)
         {
            if(!_loc5_)
            {
               §§goto(addr38);
            }
            §§goto(addr46);
         }
      }
      
      private function getCertifFolder(param1:uint, param2:Boolean = false) : File
      {
         var _loc6_:Boolean = true;
         var _loc7_:Boolean = false;
         var _loc3_:File = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(!param2)
         {
            §§push(File.applicationStorageDirectory.nativePath.split(File.separator));
            if(_loc6_)
            {
               _loc4_ = §§pop();
               §§push(_loc4_);
               if(!_loc7_)
               {
                  §§pop().pop();
                  §§push(_loc4_);
                  if(_loc7_)
                  {
                  }
                  addr44:
                  §§push(§§pop().join(File.separator));
                  addr63:
                  if(_loc6_)
                  {
                     _loc5_ = §§pop();
                  }
                  §§push(param1);
                  if(_loc6_)
                  {
                     §§push(1);
                     if(!_loc6_)
                     {
                        §§push((§§pop() - 1) * 102 * 5 + 42);
                     }
                     if(!_loc7_)
                     {
                        if(§§pop() == §§pop())
                        {
                           if(!_loc7_)
                           {
                              _loc3_ = new File(_loc5_ + File.separator + "AnkamaCertificates/");
                           }
                           addr110:
                           addr120:
                           _loc3_ = new File(_loc5_ + File.separator + "AnkamaCertificates/v2-RELEASE");
                           _loc3_.createDirectory();
                           return _loc3_;
                        }
                        §§push(param1);
                     }
                     addr109:
                     if(§§pop() == §§pop())
                     {
                        §§goto(addr110);
                     }
                     §§goto(addr120);
                  }
                  §§push(2);
                  if(_loc7_)
                  {
                     §§push(§§pop() + 69 + 1 - 1 - 1 + 49 - 113);
                  }
                  §§goto(addr109);
               }
            }
            §§pop().pop();
            §§goto(addr44);
            §§push(_loc4_);
         }
         else
         {
            §§push(CustomSharedObject.getCustomSharedObjectDirectory());
            if(!_loc7_)
            {
               §§push(§§pop());
            }
         }
         _loc5_ = §§pop();
         §§goto(addr63);
      }
      
      private function addCertificate(param1:uint, param2:String, param3:uint = 2) : Boolean
      {
         var cert:ShieldCertifcate = null;
         if(_loc8_)
         {
            if(_loc7_)
            {
               loop0:
               while(true)
               {
                  var id:uint = param1;
                  if(!_loc7_)
                  {
                  }
                  loop1:
                  while(true)
                  {
                     var content:String = param2;
                     if(!_loc8_)
                     {
                        addr63:
                        loop2:
                        while(true)
                        {
                           cert.id = id;
                           if(_loc8_)
                           {
                           }
                           §§push(cert);
                           §§push(3);
                           if(!_loc8_)
                           {
                              §§push(-(§§pop() - 26) - 116 + 1);
                           }
                           §§pop().version = §§pop();
                           if(_loc7_)
                           {
                              addr91:
                              while(true)
                              {
                                 var fs:FileStream = null;
                                 if(_loc8_)
                                 {
                                    break loop2;
                                 }
                              }
                           }
                           while(true)
                           {
                              cert.content = content;
                              if(_loc7_)
                              {
                                 break loop1;
                              }
                              addr120:
                              cert.secureLevel = secureLevel;
                              if(_loc8_)
                              {
                              }
                              try
                              {
                                 §§push(_loc4_);
                                 §§push(this);
                                 §§push(2);
                                 if(!_loc8_)
                                 {
                                    §§push(-((§§pop() - 39 - 1) * 28) - 19 - 24);
                                 }
                                 var /*UnknownSlot*/:* = §§pop().getCertifFolder(§§pop());
                                 if(_loc8_)
                                 {
                                    var f:File = f.resolvePath(MD5.hash(this.getUsername()));
                                    if(_loc8_)
                                    {
                                       if(!_loc7_)
                                       {
                                          loop15:
                                          while(true)
                                          {
                                             fs = new FileStream();
                                             if(!_loc7_)
                                             {
                                                if(_loc7_)
                                                {
                                                   addr217:
                                                   while(true)
                                                   {
                                                      fs.writeBytes(cert.serialize());
                                                   }
                                                }
                                                else
                                                {
                                                   fs.open(f,FileMode.WRITE);
                                                   if(_loc7_)
                                                   {
                                                   }
                                                }
                                                addr199:
                                                while(true)
                                                {
                                                   if(!_loc8_)
                                                   {
                                                      continue loop15;
                                                   }
                                                   break loop15;
                                                }
                                             }
                                          }
                                       }
                                       return true;
                                    }
                                    while(!_loc7_)
                                    {
                                       while(true)
                                       {
                                          fs.close();
                                          if(!_loc7_)
                                          {
                                             §§goto(addr199);
                                          }
                                          else
                                          {
                                             break;
                                          }
                                       }
                                    }
                                 }
                                 while(true)
                                 {
                                    if(!_loc8_)
                                    {
                                       §§goto(addr192);
                                    }
                                    §§goto(addr217);
                                 }
                              }
                              catch(e:Error)
                              {
                                 try
                                 {
                                    §§push(_loc4_);
                                    §§push();
                                    §§push(2);
                                    if(_loc7_)
                                    {
                                       §§push(-(§§pop() - 61 + 1 + 1));
                                    }
                                    var /*UnknownSlot*/:* = §§pop().getCertifFolder(§§pop(),true);
                                    if(!_loc7_)
                                    {
                                       f = f.resolvePath(MD5.hash(getUsername()));
                                       if(_loc8_)
                                       {
                                          if(_loc7_)
                                          {
                                             addr277:
                                             loop9:
                                             while(true)
                                             {
                                                fs.open(f,FileMode.WRITE);
                                                if(_loc7_)
                                                {
                                                }
                                                addr311:
                                                while(true)
                                                {
                                                   if(_loc8_)
                                                   {
                                                   }
                                                   break loop9;
                                                }
                                             }
                                             return true;
                                          }
                                          while(true)
                                          {
                                             fs = new FileStream();
                                             addr321:
                                             while(true)
                                             {
                                                if(!_loc7_)
                                                {
                                                   §§goto(addr277);
                                                }
                                                §§goto(addr326);
                                             }
                                          }
                                       }
                                       addr303:
                                       while(true)
                                       {
                                          if(!_loc7_)
                                          {
                                          }
                                          fs.close();
                                          §§goto(addr311);
                                       }
                                    }
                                    while(true)
                                    {
                                       if(!_loc7_)
                                       {
                                       }
                                       fs.writeBytes(cert.serialize());
                                       if(_loc8_)
                                       {
                                          if(!_loc7_)
                                          {
                                             §§goto(addr303);
                                          }
                                          §§goto(addr321);
                                       }
                                       §§goto(addr311);
                                    }
                                 }
                                 catch(e:Error)
                                 {
                                    if(_loc8_)
                                    {
                                       §§push(ErrorManager);
                                       §§push("Error writing certificate file at ");
                                       if(_loc8_)
                                       {
                                          §§push(§§pop() + f.nativePath);
                                       }
                                       §§pop().addError(§§pop(),e);
                                    }
                                 }
                              }
                              return false;
                           }
                        }
                        continue loop0;
                     }
                     addr46:
                     while(true)
                     {
                        var secureLevel:uint = param3;
                        if(_loc7_)
                        {
                           continue loop1;
                        }
                        break loop1;
                     }
                  }
                  while(true)
                  {
                     cert = new ShieldCertifcate();
                  }
               }
            }
            while(true)
            {
               f = null;
               if(!_loc8_)
               {
                  §§goto(addr46);
               }
               §§goto(addr91);
            }
         }
         while(true)
         {
            if(!_loc7_)
            {
               §§goto(addr63);
            }
            §§goto(addr120);
         }
      }
      
      public function checkMigrate() : void
      {
         if(!this._hasV1Certif)
         {
            return;
         }
         var _loc1_:TrustCertificate = this.retreiveCertificate();
         this.migrate(_loc1_.id,_loc1_.hash);
      }
      
      private function getCertificateFile() : File
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = true;
         if(_loc4_)
         {
            var userName:String = null;
            if(!_loc4_)
            {
            }
            try
            {
               addr31:
               §§push(_loc1_);
               §§push(this.getUsername());
               if(_loc4_)
               {
                  §§push(§§pop());
               }
               var /*UnknownSlot*/:* = §§pop();
               §§push(_loc1_);
               §§push(this);
               §§push(2);
               if(!_loc4_)
               {
                  §§push(-(§§pop() - 90) - 1 + 1 + 1 + 1);
               }
               var /*UnknownSlot*/:* = §§pop().getCertifFolder(§§pop()).resolvePath(MD5.hash(userName));
               if(!f.exists)
               {
                  §§push(_loc1_);
                  §§push(this);
                  §§push(1);
                  if(_loc3_)
                  {
                     §§push(--(§§pop() + 1 + 18 - 2 + 23));
                  }
                  var /*UnknownSlot*/:* = §§pop().getCertifFolder(§§pop()).resolvePath(MD5.hash(userName));
               }
               if(!f.exists)
               {
                  §§push(_loc1_);
                  §§push(this);
                  §§push(2);
                  if(!_loc4_)
                  {
                     §§push((§§pop() * 112 + 57) * 52);
                  }
                  var /*UnknownSlot*/:* = §§pop().getCertifFolder(§§pop(),true).resolvePath(MD5.hash(userName));
               }
               if(f.exists)
               {
                  return f;
               }
            }
            catch(e:Error)
            {
               if(!_loc3_)
               {
                  §§push(_log);
                  §§push("Erreur lors de la recherche du certifcat : ");
                  if(_loc4_)
                  {
                     §§push(§§pop() + e.message);
                  }
                  §§pop().error(§§pop());
               }
            }
            return null;
         }
         var f:File = null;
         §§goto(addr31);
      }
      
      public function retreiveCertificate() : TrustCertificate
      {
         var f:File = null;
         var fs:FileStream = null;
         var certif:ShieldCertifcate = null;
         try
         {
            this._hasV1Certif = false;
            f = this.getCertificateFile();
            if(f)
            {
               fs = new FileStream();
               fs.open(f,FileMode.READ);
               certif = ShieldCertifcate.fromRaw(fs);
               fs.close();
               if(certif.id == 0)
               {
                  _log.error("Certificat invalide (id=0)");
                  return null;
               }
               return certif.toNetwork();
            }
         }
         catch(e:Error)
         {
            ErrorManager.addError("Impossible de lire le fichier de certificat.",e);
         }
         return null;
      }
      
      private function onRpcData(param1:RpcEvent) : void
      {
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = false;
         if(_loc3_)
         {
            §§push(param1.type == RpcEvent.EVENT_ERROR);
            if(!_loc4_)
            {
               if(§§pop())
               {
                  if(!_loc3_)
                  {
                  }
               }
               addr31:
               if(§§pop())
               {
                  this._methodsCallback[param1.method]({
                     "error":true,
                     "fatal":true,
                     "text":I18n.getUiText("ui.secureMode.error.checkCode.503")
                  });
                  return;
               }
               §§push(param1.method);
               if(!_loc4_)
               {
                  §§push(RPC_METHOD_SECURITY_CODE);
                  if(_loc3_)
                  {
                     if(§§pop() == §§pop())
                     {
                        this._methodsCallback[param1.method](this.parseRpcASkCodeResponse(param1.result,param1.method));
                     }
                     §§push(param1.method);
                     if(!_loc3_)
                     {
                     }
                     addr110:
                     if(§§pop() == RPC_METHOD_MIGRATE)
                     {
                        if(param1.result.success)
                        {
                           this.migrationSuccess(param1.result);
                        }
                        else
                        {
                           §§push(_log);
                           §§push("Impossible de migrer le certificat : ");
                           if(_loc3_)
                           {
                              §§push(§§pop() + param1.result.error);
                           }
                           §§pop().error(§§pop());
                        }
                     }
                  }
                  addr90:
                  if(§§pop() == §§pop())
                  {
                     this._methodsCallback[param1.method](this.parseRpcValidateResponse(param1.result,param1.method));
                  }
                  §§goto(addr110);
                  §§push(param1.method);
               }
               §§push(RPC_METHOD_VALIDATE_CODE);
               if(!_loc4_)
               {
                  §§goto(addr90);
               }
               §§goto(addr110);
            }
            §§pop();
            §§goto(addr31);
            §§push(!param1.result);
         }
      }
      
      private function migrate(param1:uint, param2:String) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = true;
         var _loc3_:ShieldCertifcate = new ShieldCertifcate();
         if(!_loc4_)
         {
            _loc3_.secureLevel = this.shieldLevel;
            if(_loc4_)
            {
            }
            addr61:
            return;
         }
         §§push(this._rpcManager);
         §§push(RPC_METHOD_MIGRATE);
         §§push(this.getUsername());
         §§push(AuthentificationManager.getInstance().ankamaPortalKey);
         §§push(1);
         if(_loc4_)
         {
            §§push(§§pop() * 89 - 85 - 1 - 1);
         }
         §§pop().callMethod(§§pop(),null);
         §§goto(addr61);
      }
      
      private function migrationSuccess(param1:Object) : void
      {
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = false;
         var _loc2_:File = this.getCertificateFile();
         if(!_loc4_)
         {
            if(_loc2_.exists)
            {
               if(!_loc3_)
               {
               }
               addr29:
               return;
            }
         }
         this.addCertificate(param1.id,param1.certificate);
         §§goto(addr29);
      }
   }
}
