package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.jerakine.json.JSONDecoder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.desktop.NativeApplication;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class SteamManager
   {
      
      public static const WEB_API_PUBLISHER_KEY:String = "A6D1A5AD5FA365B530D230A8557D61A9";
      
      private static var _self:SteamManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SteamManager));
       
      
      private var _steamWorks;
      
      private var _appId:uint;
      
      private var _serviceBaseUrl:String;
      
      public var steamUserId:String;
      
      public var steamUserCountry:String;
      
      public var steamUserCurrency:String;
      
      private var _steamEmbed:Boolean = false;
      
      private var _leaderboard:String;
      
      private var _scoreDetails:int = 0;
      
      private var _authHandle:uint = 0;
      
      private var _publishedFile:String;
      
      private var _id:String;
      
      private var _ugcHandle:String;
      
      private var _authTicket:ByteArray = null;
      
      public function SteamManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._steamWorks = new (getDefinitionByName("com.amanitadesign.steam::FRESteamWorks") as Class)();
      }
      
      public static function getInstance() : SteamManager
      {
         if(!_self)
         {
            _self = new SteamManager();
         }
         return _self;
      }
      
      public static function hasSteamApi() : Boolean
      {
         return ApplicationDomain.currentDomain.hasDefinition("com.amanitadesign.steam::FRESteamWorks");
      }
      
      public function init() : void
      {
         if(!this._steamWorks.init())
         {
            _log.error("Steamwork Failed to init");
            return;
         }
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.onShutdown);
         this._steamEmbed = true;
         this._steamWorks.addEventListener(getDefinitionByName("com.amanitadesign.steam::SteamEvent").STEAM_RESPONSE,this.onSteamResponse);
         _log.debug("getEnv(\'HOME\') == " + this._steamWorks.getEnv("HOME"));
         this.steamUserId = this._steamWorks.getUserID();
         _log.debug("Steam User Id : " + this.steamUserId);
         this._appId = this._steamWorks.getAppID();
         this._serviceBaseUrl = "https://api.steampowered.com/ISteamMicroTxn/GetUserInfo/V0001/";
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onUserInfos);
         var _loc2_:URLRequest = new URLRequest(this._serviceBaseUrl);
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.key = WEB_API_PUBLISHER_KEY;
         _loc3_.steamid = this.steamUserId;
         _loc2_.method = URLRequestMethod.GET;
         _loc2_.data = _loc3_;
         _loc1_.load(_loc2_);
      }
      
      public function addOverlayWorkaround(param1:Stage) : void
      {
         this._steamWorks.addOverlayWorkaround(param1,true);
      }
      
      public function onShutdown(param1:Event) : void
      {
         this._steamWorks.dispose();
      }
      
      public function isSteamEmbed() : Boolean
      {
         return this._steamEmbed;
      }
      
      public function get authTicket() : ByteArray
      {
         return this._authTicket;
      }
      
      public function get appId() : uint
      {
         return this._appId;
      }
      
      private function getAuthSessionTicket(param1:Event = null) : void
      {
         var _loc2_:Boolean = false;
         if(!_loc2_)
         {
            if(!this._steamWorks.isReady)
            {
               if(!_loc2_)
               {
                  return;
               }
               addr53:
               while(true)
               {
                  if(!_loc3_)
                  {
                     addr58:
                     while(true)
                     {
                        §§push(_log);
                        §§push("getAuthSessionTicket(ticket) == ");
                        if(_loc3_)
                        {
                           §§push(§§pop() + this._authHandle);
                        }
                        §§pop().debug(§§pop());
                     }
                  }
                  addr77:
                  while(true)
                  {
                     this._authHandle = this._steamWorks.getAuthSessionTicket(this._authTicket);
                     addr84:
                     while(true)
                     {
                        if(_loc2_)
                        {
                           break;
                        }
                        §§goto(addr58);
                     }
                     return;
                  }
               }
            }
            addr47:
            while(true)
            {
               this._authTicket = new ByteArray();
               if(!_loc2_)
               {
                  §§goto(addr53);
               }
               §§goto(addr84);
            }
         }
         while(true)
         {
            if(_loc2_)
            {
               §§goto(addr77);
            }
            else
            {
               this.logTicket(this._authTicket);
               if(_loc3_)
               {
                  if(_loc3_)
                  {
                     if(_loc2_)
                     {
                        §§goto(addr47);
                     }
                     §§goto(addr89);
                  }
               }
               else
               {
                  continue;
               }
            }
            §§goto(addr84);
         }
      }
      
      private function getUserScore(param1:Event = null) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(_loc2_)
         {
            §§push(this);
            §§push(param1);
            §§push(0);
            if(!_loc2_)
            {
               §§push(((§§pop() + 50) * 103 - 1) * 107 + 42);
            }
            §§pop().getScoresAroundUser(§§pop(),§§pop(),§§pop());
         }
      }
      
      private function getScoresAroundUser(param1:Event = null, param2:int = -4, param3:int = 5) : void
      {
         var _loc4_:Boolean = true;
         if(!_loc5_)
         {
            if(!this._steamWorks.isReady)
            {
               if(!_loc4_)
               {
               }
            }
            else
            {
               if(!this._leaderboard)
               {
                  if(_loc4_)
                  {
                     _log.error("No Leaderboard handle set");
                     if(_loc4_)
                     {
                        if(!_loc5_)
                        {
                        }
                        addr69:
                        return;
                     }
                  }
               }
               §§push(_log);
               §§push("downloadLeaderboardEntries(...) == ");
               if(!_loc5_)
               {
                  §§push(§§pop() + this._steamWorks.downloadLeaderboardEntries(this._leaderboard,getDefinitionByName("com.amanitadesign.steam::UserStatsConstants").DATAREQUEST_GlobalAroundUser,param2,param3));
               }
               §§pop().debug(§§pop());
            }
            if(_loc5_)
            {
               §§goto(addr69);
            }
            else
            {
               return;
            }
         }
      }
      
      private function activateOverlay(param1:String) : void
      {
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = false;
         if(!_loc4_)
         {
            var service:String = param1;
            if(_loc4_)
            {
            }
            addr57:
            return;
         }
         if(!this._steamWorks.isReady)
         {
            if(!_loc4_)
            {
               return;
            }
         }
         else
         {
            §§push();
            §§push(function():void
            {
               var _loc1_:Boolean = true;
               var _loc2_:Boolean = false;
            });
            §§push(1000);
            if(_loc4_)
            {
               §§push(-(-((§§pop() - 57) * 12 - 83 - 52) * 28));
            }
            §§pop().setTimeout(§§pop(),§§pop());
         }
         §§goto(addr57);
      }
      
      private function logTicket(param1:ByteArray) : void
      {
         var _loc5_:Boolean = true;
         var _loc6_:Boolean = false;
         var _loc4_:* = null;
         var _loc2_:* = "";
         §§push(0);
         if(_loc6_)
         {
            §§push(§§pop() * 61 + 66 + 21 + 14 - 1 + 61);
         }
         var _loc3_:* = §§pop();
         if(_loc5_)
         {
            while(_loc3_ < param1.length)
            {
               §§push(param1[_loc3_]);
               §§push(16);
               if(_loc6_)
               {
                  §§push(-(§§pop() + 1) - 63 - 1);
               }
               §§push(§§pop().toString(§§pop()));
               if(_loc5_)
               {
                  _loc4_ = §§pop();
                  if(_loc5_)
                  {
                     §§push(_loc2_);
                     if(!_loc6_)
                     {
                        §§push(_loc4_.length);
                        §§push(2);
                        if(!_loc5_)
                        {
                           §§push(-((§§pop() - 32) * 7 + 100));
                        }
                        if(§§pop() < §§pop())
                        {
                           if(_loc5_)
                           {
                              §§push("0");
                              if(!_loc6_)
                              {
                                 §§push(§§pop());
                              }
                              addr86:
                              §§push(§§pop() + (§§pop() + _loc4_));
                           }
                        }
                        else
                        {
                           §§push("");
                        }
                        §§goto(addr86);
                        §§push(§§pop());
                     }
                  }
                  else
                  {
                     continue;
                  }
               }
               _loc2_ = §§pop();
               if(_loc5_)
               {
                  _loc3_++;
               }
            }
            if(_loc6_)
            {
            }
            return;
         }
         §§push(_log);
         §§push("Ticket: ");
         if(!_loc6_)
         {
            §§push(§§pop() + param1.bytesAvailable);
            if(!_loc6_)
            {
               §§push("//");
               if(!_loc6_)
               {
                  §§push(§§pop() + §§pop());
                  if(_loc6_)
                  {
                  }
               }
               addr128:
               §§push(§§pop() + §§pop());
               if(_loc6_)
               {
               }
               addr134:
               §§pop().debug(§§pop());
               §§goto(addr135);
            }
            addr132:
            §§goto(addr134);
            §§push(§§pop() + _loc2_);
         }
         §§push(§§pop() + param1.length);
         if(!_loc6_)
         {
            §§goto(addr128);
            §§push("\n");
         }
         §§goto(addr132);
      }
      
      private function onUserInfos(param1:Event) : void
      {
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = false;
         var _loc2_:JSONDecoder = new JSONDecoder(param1.target.data,true);
         var _loc3_:* = _loc2_.getValue();
         if(_loc4_)
         {
            this.steamUserCountry = _loc3_.response.params.country;
            if(!_loc5_)
            {
               this.steamUserCurrency = _loc3_.response.params.currency;
            }
         }
      }
      
      private function onSteamResponse(param1:*) : void
      {
         if(_loc5_)
         {
            §§push(_loc2_);
            §§push(0);
            if(_loc4_)
            {
               §§push(-(--(§§pop() * 88) - 17 + 1) - 1);
            }
            var /*UnknownSlot*/:* = §§pop();
            if(!_loc5_)
            {
               break loop2;
            }
            continue loop26;
         }
         continue loop27;
      }
   }
}
