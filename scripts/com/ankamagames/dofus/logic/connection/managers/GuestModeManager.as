package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAsGuestAction;
   import com.ankamagames.dofus.logic.game.common.frames.ExternalGameFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.RpcServiceCenter;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.enum.WebBrowserEnum;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.PKCS5;
   import flash.events.ErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class GuestModeManager implements IDestroyable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GuestModeManager));
      
      private static var _self:GuestModeManager;
       
      
      private var _forceGuestMode:Boolean;
      
      private var _domainExtension:String;
      
      private var _locale:String;
      
      public var isLoggingAsGuest:Boolean = false;
      
      public function GuestModeManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("GuestModeManager is a singleton and should not be instanciated directly.");
         }
         this._forceGuestMode = false;
         this._domainExtension = RpcServiceCenter.getInstance().apiDomain.split(".").pop() as String;
         this._locale = XmlConfig.getInstance().getEntry("config.lang.current");
         if(CommandLineArguments.getInstance().hasArgument("guest"))
         {
            this._forceGuestMode = CommandLineArguments.getInstance().getArgument("guest") == "true";
         }
      }
      
      public static function getInstance() : GuestModeManager
      {
         if(_self == null)
         {
            _self = new GuestModeManager();
         }
         return _self;
      }
      
      public function get forceGuestMode() : Boolean
      {
         return this._forceGuestMode;
      }
      
      public function set forceGuestMode(param1:Boolean) : void
      {
         this._forceGuestMode = param1;
      }
      
      public function logAsGuest() : void
      {
         var _loc2_:Array = null;
         var _loc1_:Object = this.getStoredCredentials();
         if(!_loc1_)
         {
            _loc2_ = [this._locale];
            if(CommandLineArguments.getInstance().hasArgument("webParams"))
            {
               _loc2_.push(CommandLineArguments.getInstance().getArgument("webParams"));
            }
            RpcServiceCenter.getInstance().makeRpcCall(RpcServiceCenter.getInstance().apiDomain + "/ankama/guest.json","json","1.0","Create",_loc2_,this.onGuestAccountCreated,true,false);
         }
         else
         {
            Kernel.getWorker().process(LoginValidationAsGuestAction.create(_loc1_.login,_loc1_.password));
         }
      }
      
      public function convertGuestAccount() : void
      {
         var _loc2_:Object = null;
         var _loc1_:ExternalGameFrame = Kernel.getWorker().getFrame(ExternalGameFrame) as ExternalGameFrame;
         if(_loc1_)
         {
            _loc1_.getIceToken(this.onIceTokenReceived);
         }
         else
         {
            _loc2_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            _loc2_.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.secureMode.error.default"),[I18n.getUiText("ui.common.ok")]);
         }
      }
      
      public function clearStoredCredentials() : void
      {
         var _loc1_:CustomSharedObject = CustomSharedObject.getLocal("Dofus_Guest");
         if(_loc1_ && _loc1_.data)
         {
            _loc1_.data = new Object();
            _loc1_.flush();
         }
      }
      
      public function hasGuestAccount() : Boolean
      {
         return this.getStoredCredentials() != null;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      private function storeCredentials(param1:String, param2:String) : void
      {
         var _loc10_:Boolean = true;
         §§push(MD5.hash(param1));
         if(_loc10_)
         {
            §§push(§§pop());
         }
         var _loc3_:* = §§pop();
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUTFBytes(_loc3_);
         var _loc5_:PKCS5 = new PKCS5();
         if(!_loc9_)
         {
            _loc5_.setBlockSize(_loc6_.getBlockSize());
         }
         var _loc7_:ByteArray = new ByteArray();
         _loc7_.writeUTFBytes(param2);
         if(!_loc9_)
         {
            _loc6_.encrypt(_loc7_);
         }
         if(_loc8_)
         {
            if(!_loc9_)
            {
               if(!_loc8_.data)
               {
                  if(_loc9_)
                  {
                  }
                  addr95:
                  while(_loc9_)
                  {
                  }
                  _loc8_.flush();
                  if(!_loc9_)
                  {
                  }
               }
               addr100:
               loop1:
               while(true)
               {
                  _loc8_.data.login = param1;
                  if(!_loc9_)
                  {
                     if(!_loc9_)
                     {
                        addr88:
                        while(true)
                        {
                           _loc8_.data.password = _loc7_;
                           if(_loc10_)
                           {
                              §§goto(addr95);
                           }
                           break loop1;
                        }
                     }
                     §§goto(addr115);
                  }
                  break;
               }
               §§goto(addr117);
            }
            _loc8_.data = new Object();
            if(!_loc9_)
            {
               if(!_loc10_)
               {
                  §§goto(addr88);
               }
               §§goto(addr100);
            }
            §§goto(addr95);
         }
      }
      
      private function getStoredCredentials() : Object
      {
         var _loc3_:ByteArray = null;
         var _loc6_:ByteArray = null;
         var _loc8_:* = null;
         var _loc1_:CustomSharedObject = CustomSharedObject.getLocal("Dofus_Guest");
         if(_loc10_)
         {
            §§push(_loc1_);
            if(_loc1_)
            {
               §§pop();
               if(!_loc11_)
               {
                  §§push(_loc1_.data);
               }
            }
            §§push(Boolean(§§pop()));
            if(_loc10_)
            {
               §§push(§§pop());
               if(_loc10_)
               {
                  if(§§pop())
                  {
                     if(_loc10_)
                     {
                        §§pop();
                        if(_loc10_)
                        {
                           §§push(Boolean(_loc1_.data.hasOwnProperty("login")));
                           if(!_loc10_)
                           {
                           }
                        }
                        addr84:
                        §§push(Boolean(_loc1_.data.hasOwnProperty("password")));
                     }
                  }
                  §§push(§§pop());
               }
               if(§§pop())
               {
                  if(!_loc11_)
                  {
                     §§pop();
                     if(_loc10_)
                     {
                        §§goto(addr84);
                     }
                  }
               }
            }
            if(§§pop())
            {
               if(_loc11_)
               {
               }
               addr101:
               if(!_loc10_)
               {
                  loop0:
                  while(true)
                  {
                     §§push(_loc7_);
                     §§push(0);
                     if(_loc11_)
                     {
                        §§push((§§pop() - 1 - 80) * 80);
                     }
                     §§pop().position = §§pop();
                     if(!_loc11_)
                     {
                        if(!_loc10_)
                        {
                           loop1:
                           while(true)
                           {
                              _loc6_ = _loc1_.data.password as ByteArray;
                              if(!_loc10_)
                              {
                                 break;
                              }
                              loop2:
                              while(true)
                              {
                                 new ByteArray().writeBytes(_loc6_);
                                 addr217:
                                 while(true)
                                 {
                                    if(!_loc10_)
                                    {
                                       loop4:
                                       while(true)
                                       {
                                          _loc3_.writeUTFBytes(_loc2_);
                                          if(_loc10_)
                                          {
                                             if(_loc10_)
                                             {
                                             }
                                             loop5:
                                             while(true)
                                             {
                                                if(!_loc10_)
                                                {
                                                   loop6:
                                                   while(true)
                                                   {
                                                      §§push(_loc7_.readUTFBytes(_loc7_.length));
                                                      if(!_loc11_)
                                                      {
                                                         if(_loc11_)
                                                         {
                                                         }
                                                      }
                                                      else
                                                      {
                                                         addr237:
                                                         while(true)
                                                         {
                                                            _loc8_ = §§pop();
                                                         }
                                                      }
                                                      while(true)
                                                      {
                                                         if(!_loc11_)
                                                         {
                                                            if(_loc10_)
                                                            {
                                                               continue loop6;
                                                            }
                                                         }
                                                         break loop6;
                                                      }
                                                   }
                                                   while(true)
                                                   {
                                                      if(!_loc11_)
                                                      {
                                                         continue loop0;
                                                      }
                                                   }
                                                }
                                                addr198:
                                                while(true)
                                                {
                                                   while(_loc10_)
                                                   {
                                                      _loc4_.setBlockSize(_loc5_.getBlockSize());
                                                      if(!_loc11_)
                                                      {
                                                         if(_loc11_)
                                                         {
                                                            continue loop5;
                                                         }
                                                         break loop5;
                                                      }
                                                   }
                                                   continue loop2;
                                                }
                                             }
                                             continue loop1;
                                          }
                                          addr262:
                                          while(true)
                                          {
                                             if(_loc11_)
                                             {
                                                break loop4;
                                             }
                                             continue loop4;
                                          }
                                       }
                                    }
                                    while(true)
                                    {
                                       _loc5_.decrypt(_loc7_);
                                       §§goto(addr249);
                                    }
                                 }
                              }
                           }
                           return {
                              "login":_loc8_,
                              "password":_loc9_
                           };
                        }
                        while(true)
                        {
                           §§goto(addr237);
                        }
                     }
                     while(true)
                     {
                        if(!_loc11_)
                        {
                           if(!_loc10_)
                           {
                              §§goto(addr198);
                           }
                           §§goto(addr142);
                        }
                        §§goto(addr217);
                     }
                  }
               }
               while(true)
               {
                  _loc3_ = new ByteArray();
                  §§goto(addr262);
               }
            }
            return null;
         }
         §§push(MD5.hash(_loc1_.data.login));
         if(!_loc11_)
         {
            §§push(§§pop());
         }
         §§goto(addr101);
      }
      
      private function onGuestAccountCreated(param1:Boolean, param2:*, param3:*) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = true;
         §§push(_log);
         §§push("onGuestAccountCreated - ");
         if(!_loc4_)
         {
            §§push(§§pop() + param1);
         }
         §§pop().debug(§§pop());
         §§push(param1);
         if(_loc5_)
         {
            if(§§pop())
            {
               if(param2.error)
               {
                  if(_loc5_)
                  {
                     this.onGuestAccountError(param2.error);
                  }
               }
               else
               {
                  this.storeCredentials(param2.login,param2.password);
                  §§push(AirScanner.isStreamingVersion());
                  if(_loc5_)
                  {
                     §§push(Boolean(§§pop()));
                     if(!_loc5_)
                     {
                     }
                     addr59:
                     §§pop();
                     §§push(Boolean(ExternalInterface.available));
                  }
                  addr63:
                  if(§§pop())
                  {
                     ExternalInterface.call("onGuestAccountCreated");
                  }
                  Kernel.getWorker().process(LoginValidationAsGuestAction.create(param2.login,param2.password));
               }
            }
            else
            {
               this.onGuestAccountError(param2);
            }
            return;
         }
         if(§§pop())
         {
            if(!_loc4_)
            {
               §§goto(addr59);
            }
         }
         §§goto(addr63);
      }
      
      private function onGuestAccountError(param1:*) : void
      {
         var _loc10_:Boolean = true;
         var _loc4_:Frame = null;
         if(!_loc9_)
         {
            _log.error(param1);
         }
         var _loc2_:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         §§push(param1 is ErrorEvent);
         §§push(param1 is ErrorEvent);
         if(!_loc9_)
         {
            if(§§pop())
            {
               §§pop();
               §§push(param1.type == IOErrorEvent.NETWORK_ERROR);
            }
            §§push(§§pop());
         }
         if(!§§pop())
         {
            §§pop();
            §§push(param1 is IOErrorEvent);
         }
         if(§§pop())
         {
            if(!_loc9_)
            {
               _loc2_.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.connection.guestAccountCreationTimedOut"),[I18n.getUiText("ui.common.ok")]);
               if(!_loc9_)
               {
                  addr131:
                  while(true)
                  {
                     §§push(KernelEventsManager.getInstance());
                     §§push(HookList.IdentificationFailed);
                     §§push(0);
                     if(!_loc10_)
                     {
                        §§push(-(§§pop() + 7) + 1 + 98);
                     }
                     §§pop().processCallback(§§pop(),§§pop());
                  }
               }
               addr182:
               _log.error("Oh oh ! ProtectPishingFrame is still here, it shoudln\'t be. Who else is in here ?");
               §§push(0);
               if(_loc9_)
               {
                  §§push(-(§§pop() + 60 - 1) + 1);
               }
               if(!_loc9_)
               {
                  if(_loc10_)
                  {
                     while(§§hasnext(Kernel.getWorker().framesList,_loc7_))
                     {
                        if(!_loc10_)
                        {
                           addr211:
                           while(true)
                           {
                              §§push(getQualifiedClassName(_loc4_));
                              if(!_loc9_)
                              {
                                 §§push(_loc5_);
                              }
                              if(_loc10_)
                              {
                                 if(!_loc9_)
                                 {
                                 }
                                 addr244:
                                 §§push(_log);
                                 §§push(" - ");
                                 if(_loc10_)
                                 {
                                    §§push(§§pop() + _loc6_[_loc6_.length - 1]);
                                 }
                                 §§pop().error(§§pop());
                                 break;
                              }
                              break;
                           }
                           if(!_loc9_)
                           {
                           }
                           continue;
                        }
                        while(true)
                        {
                           _loc4_ = §§nextvalue(_loc7_,_loc8_);
                           if(!_loc9_)
                           {
                              if(!_loc10_)
                              {
                                 §§goto(addr244);
                              }
                              else
                              {
                                 §§goto(addr211);
                              }
                           }
                           §§goto(addr256);
                        }
                     }
                  }
               }
               addr284:
               if(_loc10_)
               {
                  Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(ProtectPishingFrame));
                  if(!_loc9_)
                  {
                     addr278:
                     KernelEventsManager.getInstance().processCallback(HookList.AuthentificationStart,false);
                  }
               }
               return;
            }
            while(true)
            {
               if(!_loc9_)
               {
               }
               addr169:
               if(this._forceGuestMode)
               {
                  if(_loc10_)
                  {
                  }
                  this._forceGuestMode = false;
                  if(Kernel.getWorker().contains(ProtectPishingFrame))
                  {
                     §§goto(addr182);
                  }
                  §§goto(addr278);
               }
               §§goto(addr284);
            }
         }
         else if(param1 is String)
         {
            _loc2_.openPopup(I18n.getUiText("ui.common.error"),param1,[I18n.getUiText("ui.common.ok")]);
            §§goto(addr131);
         }
         else
         {
            §§push(I18n.getUiText("ui.secureMode.error.default"));
            if(_loc10_)
            {
               §§push(§§pop());
               if(_loc10_)
               {
                  if(param1 is ErrorEvent)
                  {
                     §§push(_loc3_);
                     if(!_loc10_)
                     {
                     }
                     addr124:
                     if(!_loc10_)
                     {
                        addr130:
                        while(true)
                        {
                           §§goto(addr131);
                        }
                        §§goto(addr169);
                     }
                  }
               }
            }
            §§push(" (#");
            if(!_loc9_)
            {
               §§push(§§pop() + (param1 as ErrorEvent).errorID);
               if(!_loc9_)
               {
                  §§push(§§pop() + ")");
               }
            }
            §§goto(addr124);
            §§push(§§pop() + §§pop());
         }
         while(true)
         {
            _loc2_.openPopup(I18n.getUiText("ui.common.error"),_loc3_,[I18n.getUiText("ui.common.ok")]);
            if(_loc10_)
            {
               §§goto(addr130);
            }
            §§goto(addr169);
         }
      }
      
      private function onIceTokenReceived(param1:String) : void
      {
         var _loc6_:Boolean = true;
         var _loc7_:Boolean = false;
         var _loc4_:Object = null;
         var _loc5_:URLRequest = null;
         if(!_loc7_)
         {
            if(param1)
            {
               §§push("http://go.ankama.");
               if(_loc6_)
               {
                  §§push(this._domainExtension);
                  if(_loc6_)
                  {
                     §§push(§§pop() + §§pop());
                     if(!_loc6_)
                     {
                     }
                     addr67:
                     var _loc3_:URLVariables = new URLVariables();
                     if(!_loc7_)
                     {
                        _loc3_.key = param1;
                        if(!_loc6_)
                        {
                        }
                        addr106:
                        addr116:
                        ExternalInterface.call("window.open",_loc2_ + "?" + _loc3_.toString(),"_blank");
                        return;
                     }
                     §§push(SystemManager.getSingleton().browser == WebBrowserEnum.CHROME);
                     if(_loc6_)
                     {
                        if(§§pop())
                        {
                           if(_loc7_)
                           {
                           }
                        }
                        addr103:
                        if(§§pop())
                        {
                           if(!_loc7_)
                           {
                              §§goto(addr106);
                           }
                           §§goto(addr116);
                        }
                        else
                        {
                           _loc5_ = new URLRequest(_loc2_);
                           _loc5_.method = URLRequestMethod.GET;
                           if(_loc6_)
                           {
                              if(!_loc6_)
                              {
                                 loop0:
                                 while(true)
                                 {
                                    navigateToURL(_loc5_,"_blank");
                                    if(_loc7_)
                                    {
                                    }
                                    addr153:
                                    while(true)
                                    {
                                       if(_loc7_)
                                       {
                                          break loop0;
                                       }
                                       continue loop0;
                                    }
                                 }
                              }
                              addr150:
                              while(true)
                              {
                                 _loc5_.data = _loc3_;
                                 §§goto(addr153);
                              }
                           }
                           while(true)
                           {
                              if(!_loc6_)
                              {
                                 §§goto(addr150);
                              }
                           }
                        }
                        §§goto(addr116);
                     }
                     §§pop();
                     if(!_loc7_)
                     {
                        §§goto(addr103);
                        §§push(Boolean(ExternalInterface.available));
                     }
                     §§goto(addr116);
                  }
                  addr62:
                  §§push(§§pop() + §§pop());
                  if(!_loc7_)
                  {
                     addr65:
                     §§push(§§pop() + "/go/dofus/complete-guest");
                  }
                  §§goto(addr67);
               }
               §§push("/");
               if(_loc6_)
               {
                  §§push(§§pop() + §§pop());
                  if(!_loc7_)
                  {
                     §§goto(addr62);
                     §§push(this._locale);
                  }
                  §§goto(addr65);
               }
               §§goto(addr65);
            }
         }
         _loc4_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         _loc4_.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.secureMode.error.default"),[I18n.getUiText("ui.common.ok")]);
      }
   }
}
