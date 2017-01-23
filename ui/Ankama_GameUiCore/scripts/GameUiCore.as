package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.misc.Pack;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.PresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.ExternalNotificationApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.AddIgnored;
   import d2actions.GameRolePlayFreeSoulRequest;
   import d2actions.ObjectDrop;
   import d2actions.ObjectSetPosition;
   import d2actions.PlayerFightFriendlyAnswer;
   import d2enums.DataStoreEnum;
   import d2enums.StrataEnum;
   import d2hooks.AreaFightModificatorUpdate;
   import d2hooks.DareRewardVisible;
   import d2hooks.EnabledChannels;
   import d2hooks.FoldAll;
   import d2hooks.GameRolePlayPlayerLifeStatus;
   import d2hooks.GameStart;
   import d2hooks.GiftsWaitingAllocation;
   import d2hooks.GuestLimitationPopup;
   import d2hooks.GuestMode;
   import d2hooks.InactivityNotification;
   import d2hooks.NonSubscriberPopup;
   import d2hooks.OpenMainMenu;
   import d2hooks.OpenOfflineSales;
   import d2hooks.OpenReport;
   import d2hooks.PackRestrictedSubArea;
   import d2hooks.PlayerFightFriendlyAnswered;
   import d2hooks.PlayerFightFriendlyRequested;
   import d2hooks.PlayerFightRequestSent;
   import d2hooks.RewardableAchievementsVisible;
   import d2hooks.RoleplayBuffViewContent;
   import d2hooks.SlotDropedOnWorld;
   import d2hooks.SmileysStart;
   import d2hooks.SubscriptionZone;
   import d2hooks.TextInformation;
   import d2hooks.WorldMouseWheel;
   import d2hooks.WorldRightClick;
   import flash.display.Sprite;
   import managers.ExternalNotificationManager;
   import ui.ActionBar;
   import ui.Banner;
   import ui.BannerMenu;
   import ui.BuffUi;
   import ui.Chat;
   import ui.Cinematic;
   import ui.ExternalActionBar;
   import ui.ExternalNotification;
   import ui.FightModificatorUi;
   import ui.HardcoreDeath;
   import ui.MainMenu;
   import ui.MapInfo;
   import ui.OfflineSales;
   import ui.PayZone;
   import ui.Proto;
   import ui.Report;
   import ui.RewardsAndGiftsUi;
   import ui.Smileys;
   import ui.Zoom;
   
   public class GameUiCore extends Sprite
   {
      
      private static var _self:GameUiCore;
       
      
      protected var banner:Banner;
      
      protected var bannerMenu:BannerMenu;
      
      protected var actionBar:ActionBar;
      
      protected var externalActionBar:ExternalActionBar;
      
      protected var chat:Chat;
      
      protected var smileys:Smileys;
      
      protected var mapInfo:MapInfo;
      
      protected var mainMenu:MainMenu;
      
      protected var payZone:PayZone;
      
      protected var hardcoreDeath:HardcoreDeath;
      
      protected var buffUi:BuffUi;
      
      protected var fightModificatorUi:FightModificatorUi;
      
      protected var rewardsAndGiftsUi:RewardsAndGiftsUi;
      
      protected var report:Report;
      
      protected var zoom:Zoom;
      
      protected var cinematic:ui.Cinematic;
      
      protected var externalnotification:ExternalNotification;
      
      protected var offlineSales:OfflineSales;
      
      protected var proto:Proto;
      
      public const MILLISECONDS_IN_DAY:Number = 86400000;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var configApi:ConfigApi;
      
      public var menuApi:ContextMenuApi;
      
      public var timeApi:TimeApi;
      
      public var extNotifApi:ExternalNotificationApi;
      
      public var fightApi:FightApi;
      
      public var chatApi:ChatApi;
      
      public var utilApi:UtilApi;
      
      public var highlight:HighlightApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Cartography")]
      public var modCartography:Object;
      
      private var _channels:Object;
      
      private var _currentPopupName:String;
      
      private var _waitingObject:Object;
      
      private var _waitingObjectName:String;
      
      private var _waitingObjectQuantity:int;
      
      private var _folded:Boolean = false;
      
      private var _ignoreName:String;
      
      private var _aTextInfos:Array;
      
      private var _inactivityPopup:String = null;
      
      public var areAchRewardsRequired:Boolean;
      
      public var areGiftsRequired:Boolean;
      
      public var areDareRewardRequired:Boolean;
      
      public function GameUiCore()
      {
         this._aTextInfos = new Array();
         super();
      }
      
      public static function getInstance() : GameUiCore
      {
         return _self;
      }
      
      public function main() : void
      {
         Api.system = this.sysApi;
         Api.ui = this.uiApi;
         Api.extNotif = this.extNotifApi;
         Api.social = this.socialApi;
         Api.fight = this.fightApi;
         Api.player = this.playerApi;
         Api.data = this.dataApi;
         Api.chat = this.chatApi;
         Api.util = this.utilApi;
         Api.highlight = this.highlight;
         if(this.sysApi.hasAir())
         {
            ExternalNotificationManager.getInstance();
         }
         this.sysApi.createHook("FoldAll");
         this.sysApi.addHook(GameStart,this.onGameStart);
         this.sysApi.addHook(SmileysStart,this.onSmileysStart);
         this.sysApi.addHook(EnabledChannels,this.onEnabledChannels);
         this.sysApi.addHook(TextInformation,this.onTextInformation);
         this.sysApi.addHook(PlayerFightRequestSent,this.onPlayerFightRequestSent);
         this.sysApi.addHook(PlayerFightFriendlyRequested,this.onPlayerFightFriendlyRequested);
         this.sysApi.addHook(PlayerFightFriendlyAnswered,this.onPlayerFightFriendlyAnswered);
         this.sysApi.addHook(GameRolePlayPlayerLifeStatus,this.onGameRolePlayPlayerLifeStatus);
         this.sysApi.addHook(SubscriptionZone,this.onSubscriptionZone);
         this.sysApi.addHook(NonSubscriberPopup,this.onNonSubscriberPopup);
         this.sysApi.addHook(GuestLimitationPopup,this.onGuestLimitationPopup);
         this.sysApi.addHook(GuestMode,this.onGuestMode);
         this.sysApi.addHook(SlotDropedOnWorld,this.onSlotDropedOnWorld);
         this.sysApi.addHook(RoleplayBuffViewContent,this.onRoleplayBuffViewContent);
         this.sysApi.addHook(RewardableAchievementsVisible,this.onRewardableAchievementsVisible);
         this.sysApi.addHook(GiftsWaitingAllocation,this.onGiftsWaitingAllocation);
         this.sysApi.addHook(DareRewardVisible,this.onDareRewardVisible);
         this.sysApi.addHook(OpenReport,this.onReportOpen);
         this.sysApi.addHook(WorldRightClick,this.onWorldRightClick);
         this.sysApi.addHook(WorldMouseWheel,this.onWorldMouseWheel);
         this.sysApi.addHook(d2hooks.Cinematic,this.onCinematic);
         this.sysApi.addHook(PackRestrictedSubArea,this.onPackRestrictedSubArea);
         this.sysApi.addHook(InactivityNotification,this.onInactivityNotification);
         this.sysApi.addHook(AreaFightModificatorUpdate,this.onAreaFightModificatorUpdate);
         this.sysApi.addHook(OpenOfflineSales,this.onOpenOfflineSales);
         this.sysApi.addHook(OpenMainMenu,this.onOpenMainMenu);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("transparancyMode",this.onShortcut);
         this.uiApi.addShortcutHook("showGrid",this.onShortcut);
         this.uiApi.addShortcutHook("foldAll",this.onShortcut);
         this.uiApi.addShortcutHook("cellSelectionOnly",this.onShortcut);
         this.uiApi.addShortcutHook("showCoord",this.onShortcut);
         _self = this;
      }
      
      public function getTooltipFightPlacer() : Object
      {
         var _loc1_:Object = null;
         if(this.uiApi.getUi(UIEnum.BANNER))
         {
            _loc1_ = this.uiApi.getUi(UIEnum.BANNER).getElement("tooltipFightPlacer");
         }
         return _loc1_;
      }
      
      private function onShortcut(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         switch(param1)
         {
            case "closeUi":
               if(this.uiApi.getUi("cartographyUi"))
               {
                  this.uiApi.unloadUi("cartographyUi");
               }
               else
               {
                  this.onOpenMainMenu();
               }
               return true;
            case "transparancyMode":
               _loc2_ = this.configApi.getConfigProperty("atouin","transparentOverlayMode");
               this.configApi.setConfigProperty("atouin","transparentOverlayMode",!_loc2_);
               return true;
            case "showGrid":
               _loc2_ = this.configApi.getConfigProperty("atouin","alwaysShowGrid");
               this.configApi.setConfigProperty("atouin","alwaysShowGrid",!_loc2_);
               return true;
            case "showCoord":
               _loc2_ = this.configApi.getConfigProperty("dofus","mapCoordinates");
               this.configApi.setConfigProperty("dofus","mapCoordinates",!_loc2_);
               return true;
            case "foldAll":
               this._folded = !this._folded;
               this.sysApi.dispatchHook(FoldAll,this._folded);
               return true;
            case "cellSelectionOnly":
               _loc2_ = this.configApi.getConfigProperty("dofus","cellSelectionOnly");
               this.configApi.setConfigProperty("dofus","cellSelectionOnly",!_loc2_);
               return true;
            default:
               return false;
         }
      }
      
      private function onGameStart() : void
      {
         this.uiApi.loadUi(UIEnum.MAP_INFO_UI,null,null,StrataEnum.STRATA_LOW);
         this.modCartography.openBannerMap();
         this.uiApi.loadUi(UIEnum.BANNER,null,null,StrataEnum.STRATA_HIGH);
         if(!this.uiApi.getUi(UIEnum.CHAT_UI))
         {
            this.uiApi.loadUi(UIEnum.CHAT_UI,UIEnum.CHAT_UI,[this._channels,this._aTextInfos]);
         }
         this.uiApi.loadUi("bannerMenu");
      }
      
      private function onSmileysStart(param1:uint, param2:String = "") : void
      {
         if(!this.uiApi.getUi(UIEnum.SMILEY_UI))
         {
            this.uiApi.loadUi(UIEnum.SMILEY_UI,UIEnum.SMILEY_UI,[param1],StrataEnum.STRATA_TOP);
         }
      }
      
      private function onEnabledChannels(param1:Object) : void
      {
         if(!this.uiApi.getUi(UIEnum.CHAT_UI))
         {
            this._channels = param1;
         }
      }
      
      private function onTextInformation(param1:String = "", param2:int = 0, param3:Number = 0, param4:Boolean = true, param5:Boolean = false) : void
      {
         if(!this.uiApi.getUi(UIEnum.CHAT_UI))
         {
            this._aTextInfos.push({
               "content":param1,
               "channel":param2,
               "timestamp":param3,
               "saveMsg":param4
            });
         }
      }
      
      private function onPlayerFightRequestSent(param1:String, param2:Boolean) : void
      {
         if(param2)
         {
            this._currentPopupName = this.modCommon.openPopup(this.uiApi.getText("ui.fight.challenge"),this.uiApi.getText("ui.fight.youChallenge",param1),[this.uiApi.getText("ui.charcrea.undo")],[this.onFightFriendlyRefused],null,this.onFightFriendlyRefused);
         }
      }
      
      private function onPlayerFightFriendlyRequested(param1:String) : void
      {
         this._ignoreName = param1;
         this._currentPopupName = this.modCommon.openPopup(this.uiApi.getText("ui.fight.challenge"),this.uiApi.getText("ui.fight.aChallengeYou",param1),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no"),this.uiApi.getText("ui.common.ignore")],[this.onFightFriendlyAccepted,this.onFightFriendlyRefused,this.onFightFriendlyIgnore],this.onFightFriendlyAccepted,this.onFightFriendlyRefused);
      }
      
      private function onFightFriendlyAccepted() : void
      {
         this.sysApi.sendAction(new PlayerFightFriendlyAnswer(true));
      }
      
      private function onFightFriendlyRefused() : void
      {
         this.sysApi.sendAction(new PlayerFightFriendlyAnswer(false));
      }
      
      private function onFightFriendlyIgnore() : void
      {
         this.sysApi.sendAction(new PlayerFightFriendlyAnswer(false));
         this.sysApi.sendAction(new AddIgnored(this._ignoreName));
      }
      
      private function onPlayerFightFriendlyAnswered(param1:Boolean) : void
      {
         this.uiApi.unloadUi(this._currentPopupName);
         this._currentPopupName = null;
      }
      
      private function onWorldRightClick() : void
      {
         var _loc1_:Object = null;
         if(this.playerApi.isInFight())
         {
            _loc1_ = this.menuApi.create(null,"fightWorld");
         }
         else
         {
            _loc1_ = this.menuApi.create(null,"world");
         }
         this.modContextMenu.createContextMenu(_loc1_);
      }
      
      private function onWorldMouseWheel(param1:Boolean) : void
      {
         if(this.sysApi.getOption("zoomOnMouseWheel","dofus"))
         {
            Api.system.mouseZoom(param1);
         }
      }
      
      private function onGameRolePlayPlayerLifeStatus(param1:uint, param2:uint) : void
      {
         if(param2 == 0)
         {
            switch(param1)
            {
               case 0:
                  break;
               case 1:
                  this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),this.uiApi.getText("ui.gameuicore.playerDied") + "\n\n" + this.uiApi.getText("ui.gameuicore.freeSoul"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onFreePlayerSoulAccepted,this.onFreePlayerSoulRefused],null,this.onFreePlayerSoulRefused,this.uiApi.createUri(this.sysApi.getConfigEntry("config.content.path") + "gfx/illusUi/gravestone.png"));
                  break;
               case 2:
                  this.modCommon.openPopup(this.uiApi.getText("ui.login.news"),this.uiApi.getText("ui.gameuicore.soulsWorld"),[this.uiApi.getText("ui.common.ok")]);
            }
         }
         else if(!this.uiApi.getUi("hardcoreDeath"))
         {
            this.uiApi.loadUi("hardcoreDeath");
         }
      }
      
      private function onFreePlayerSoulAccepted() : void
      {
         this.sysApi.sendAction(new GameRolePlayFreeSoulRequest());
      }
      
      private function onFreePlayerSoulRefused() : void
      {
      }
      
      private function onSubscriptionZone(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this.uiApi.getUi("payZone"))
            {
               this.uiApi.loadUi("payZone","payZone",[0,false]);
            }
         }
         else if(this.uiApi.getUi("payZone"))
         {
            this.uiApi.unloadUi("payZone");
         }
      }
      
      private function onNonSubscriberPopup() : void
      {
         if(!this.uiApi.getUi("payZone"))
         {
            this.uiApi.loadUi("payZone","payZone",[0,true]);
         }
      }
      
      public function onGuestLimitationPopup() : void
      {
         if(!this.uiApi.getUi("payZone"))
         {
            this.uiApi.loadUi("payZone","payZone",[1,true],StrataEnum.STRATA_TOP);
         }
      }
      
      private function onGuestMode(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this.uiApi.getUi("payZone"))
            {
               this.uiApi.loadUi("payZone","payZone",[1,false],StrataEnum.STRATA_TOP);
            }
         }
         else if(this.uiApi.getUi("payZone"))
         {
            this.uiApi.unloadUi("payZone");
         }
      }
      
      private function onAreaFightModificatorUpdate(param1:int) : void
      {
         if(!this.uiApi.getUi("fightModificatorUi") && param1 > -1)
         {
            this.uiApi.loadUi("fightModificatorUi","fightModificatorUi",{"pairId":param1});
         }
      }
      
      private function onRoleplayBuffViewContent(param1:Object) : void
      {
         if(!this.uiApi.getUi(UIEnum.BUFF_UI))
         {
            this.uiApi.loadUi(UIEnum.BUFF_UI,UIEnum.BUFF_UI,{"buffs":param1});
         }
      }
      
      public function removeFromBanner(param1:Object) : void
      {
         if(this.uiApi.keyIsDown(16))
         {
            if(param1.hasOwnProperty("objectUID"))
            {
               this.sysApi.sendAction(new ObjectSetPosition(param1.objectUID,63));
            }
         }
      }
      
      public function onSlotDropedOnWorld(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         switch(true)
         {
            case param1.data is SpellWrapper:
            case param1.data is PresetWrapper:
               break;
            case param1.data is ItemWrapper:
               if(param1.data.position > 63 && param1.data.position < 318)
               {
                  this.removeFromBanner(param1.data);
               }
               for each(_loc3_ in param1.data.effects)
               {
                  if(_loc3_.effectId == 981 || _loc3_.effectId == 982 || _loc3_.effectId == 983)
                  {
                     this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.objectError.CannotDrop"),10,this.timeApi.getTimestamp());
                     return;
                  }
               }
               if(this.playerApi.isInExchange())
               {
                  return;
               }
               this._waitingObject = param1.data;
               this._waitingObjectName = this.dataApi.getItemName(this._waitingObject.objectGID);
               if(this._waitingObject.quantity > 1)
               {
                  this.modCommon.openQuantityPopup(1,this._waitingObject.quantity,this._waitingObject.quantity,this.onValidQtyDrop);
               }
               else
               {
                  this.sysApi.sendAction(new ObjectDrop(this._waitingObject.objectUID,this._waitingObject.objectGID,1));
               }
               break;
         }
      }
      
      private function onValidQtyDrop(param1:int) : void
      {
         this._waitingObjectQuantity = param1;
         this.sysApi.sendAction(new ObjectDrop(this._waitingObject.objectUID,this._waitingObject.objectGID,this._waitingObjectQuantity));
      }
      
      private function onReportOpen(param1:Number, param2:String, param3:Object = null) : void
      {
         this.uiApi.unloadUi("report");
         this.uiApi.loadUi("report","report",{
            "playerID":param1,
            "playerName":param2,
            "context":param3
         });
      }
      
      public function onCinematic(param1:int) : void
      {
         var _loc2_:Date = new Date();
         var _loc3_:Number = this.sysApi.getData("lastPlay_" + param1,DataStoreEnum.BIND_COMPUTER);
         if(_loc3_ > 0 && _loc2_.getTime() < _loc3_ + 7 * this.MILLISECONDS_IN_DAY)
         {
            return;
         }
         this.sysApi.setData("lastPlay_" + param1,_loc2_.getTime(),DataStoreEnum.BIND_COMPUTER);
         if(!this.uiApi.getUi(UIEnum.CHAT_UI))
         {
            this.uiApi.loadUi(UIEnum.CHAT_UI,UIEnum.CHAT_UI,[this._channels,this._aTextInfos],StrataEnum.STRATA_TOP);
         }
         var _loc4_:String = "" + param1;
         if(param1 == 10)
         {
            _loc4_ = this.sysApi.getCurrentLanguage() + "/" + _loc4_;
         }
         if(param1 > 100)
         {
            if(this.sysApi.getData("trailer1Viewed"))
            {
               return;
            }
            this.sysApi.setData("trailer1Viewed",true);
         }
         this.uiApi.loadUi("cinematic","cinematic",{"cinematicId":_loc4_},StrataEnum.STRATA_TOP);
      }
      
      public function onPackRestrictedSubArea(param1:int) : void
      {
         var _loc2_:SubArea = this.dataApi.getSubArea(param1);
         var _loc3_:Pack = this.dataApi.getPack(_loc2_.packId);
         if(this.sysApi.hasPart(_loc3_.name) && this.sysApi.isDownloadFinished())
         {
            this.displayRebootPopup();
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.split.PackRestrictedSubAreaError",[]),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function displayRebootPopup() : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.split.rebootConfirm",[]),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmRestart,null],this.onConfirmRestart);
      }
      
      private function onConfirmRestart() : void
      {
         this.sysApi.reset();
      }
      
      private function onInactivityNotification(param1:Boolean) : void
      {
         if(param1 && !this._inactivityPopup)
         {
            this._inactivityPopup = this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.common.inactivityWarning"),[this.uiApi.getText("ui.common.ok")],[this.inactivityPopupClosed],this.inactivityPopupClosed,this.inactivityPopupClosed);
         }
      }
      
      private function inactivityPopupClosed() : void
      {
         this._inactivityPopup = null;
      }
      
      private function onRewardableAchievementsVisible(param1:Boolean) : void
      {
         this.areAchRewardsRequired = param1;
      }
      
      private function onGiftsWaitingAllocation(param1:Boolean) : void
      {
         this.areGiftsRequired = param1;
      }
      
      private function onDareRewardVisible(param1:Boolean) : void
      {
         this.areDareRewardRequired = param1;
      }
      
      private function onOpenOfflineSales(param1:uint, param2:Object, param3:Object) : void
      {
         this.uiApi.loadUi("offlineSales",null,{
            "tab":param1,
            "sales":param2,
            "unsoldItems":param3
         },1,null,true,false,false);
      }
      
      public function onOpenMainMenu() : void
      {
         if(!this.uiApi.getUi("mainMenu"))
         {
            this.uiApi.loadUi("mainMenu",null,null,StrataEnum.STRATA_TOP);
         }
         else
         {
            this.uiApi.unloadUi("mainMenu");
         }
      }
   }
}
