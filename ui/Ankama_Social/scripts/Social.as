package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.AllianceInvitationAnswer;
   import d2actions.GuildInvitationAnswer;
   import d2actions.PlayerFightRequest;
   import d2actions.SpouseRequest;
   import d2hooks.AllianceCreationStarted;
   import d2hooks.AllianceInvitationStateRecruted;
   import d2hooks.AllianceInvitationStateRecruter;
   import d2hooks.AllianceInvited;
   import d2hooks.AttackPlayer;
   import d2hooks.ClientUIOpened;
   import d2hooks.ContextChanged;
   import d2hooks.DishonourChanged;
   import d2hooks.GuildCreationStarted;
   import d2hooks.GuildInvitationStateRecruted;
   import d2hooks.GuildInvitationStateRecruter;
   import d2hooks.GuildInvited;
   import d2hooks.OpenDareSearch;
   import d2hooks.OpenOneAlliance;
   import d2hooks.OpenOneGuild;
   import d2hooks.OpenSocial;
   import d2hooks.ShowCollectedTaxCollector;
   import d2hooks.ShowTopTaxCollectors;
   import flash.display.Sprite;
   import ui.Alliance;
   import ui.AllianceAreas;
   import ui.AllianceCard;
   import ui.AllianceCreator;
   import ui.AllianceFights;
   import ui.AllianceMembers;
   import ui.CollectedTaxCollector;
   import ui.Dare;
   import ui.DareCreation;
   import ui.DareList;
   import ui.Directory;
   import ui.Friends;
   import ui.Guild;
   import ui.GuildCard;
   import ui.GuildCreator;
   import ui.GuildHouses;
   import ui.GuildMemberRights;
   import ui.GuildMembers;
   import ui.GuildPaddock;
   import ui.GuildPersonalization;
   import ui.GuildTaxCollector;
   import ui.SocialBase;
   import ui.SocialBulletin;
   import ui.Spouse;
   import ui.TopTaxCollectors;
   import ui.items.AllianceFightXmlItem;
   import ui.items.PonyXmlItem;
   
   public class Social extends Sprite
   {
      
      private static var _self:Social;
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      protected var socialBase:SocialBase;
      
      protected var friends:Friends;
      
      protected var spouse:Spouse;
      
      protected var guild:Guild;
      
      protected var alliance:Alliance;
      
      protected var directory:Directory;
      
      protected var guildCard:GuildCard;
      
      protected var allianceCard:AllianceCard;
      
      protected var ponyXmlItem:PonyXmlItem;
      
      protected var allianceFightXmlItem:AllianceFightXmlItem;
      
      protected var guildHouses:GuildHouses;
      
      protected var guildMembers:GuildMembers;
      
      protected var guildMemberRights:GuildMemberRights;
      
      protected var guildPaddock:GuildPaddock;
      
      protected var guildPersonalization:GuildPersonalization;
      
      protected var guildTaxCollector:GuildTaxCollector;
      
      protected var guildCreator:GuildCreator;
      
      protected var allianceMembers:AllianceMembers;
      
      protected var allianceAreas:AllianceAreas;
      
      protected var allianceFights:AllianceFights;
      
      protected var allianceCreator:AllianceCreator;
      
      protected var collectedTaxCollector:CollectedTaxCollector;
      
      protected var topTaxCollectors:TopTaxCollectors;
      
      protected var socialBulletin:SocialBulletin;
      
      protected var dare:Dare;
      
      protected var dareList:DareList;
      
      protected var dareCreation:DareCreation;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _firstTime:Boolean = true;
      
      private var _ava:Boolean;
      
      private var _targetId:Number;
      
      private var _cellId:int;
      
      private var _popupName:String = null;
      
      private var _popupAllianceName:String = null;
      
      private var _dareCreationStatus:Object;
      
      public function Social()
      {
         super();
      }
      
      public static function getInstance() : Social
      {
         return _self;
      }
      
      public function main() : void
      {
         Api.system = this.sysApi;
         Api.social = this.socialApi;
         Api.ui = this.uiApi;
         Api.player = this.playerApi;
         _self = this;
         this.sysApi.addHook(OpenSocial,this.onOpenSocial);
         this.sysApi.addHook(ClientUIOpened,this.onClientUIOpened);
         this.sysApi.addHook(ContextChanged,this.onContextChanged);
         this.sysApi.addHook(GuildCreationStarted,this.onCreateGuild);
         this.sysApi.addHook(GuildInvited,this.onGuildInvited);
         this.sysApi.addHook(GuildInvitationStateRecruter,this.onGuildInvitationStateRecruter);
         this.sysApi.addHook(GuildInvitationStateRecruted,this.onGuildInvitationStateRecruted);
         this.sysApi.addHook(AllianceCreationStarted,this.onCreateAlliance);
         this.sysApi.addHook(AllianceInvited,this.onAllianceInvited);
         this.sysApi.addHook(AllianceInvitationStateRecruter,this.onAllianceInvitationStateRecruter);
         this.sysApi.addHook(AllianceInvitationStateRecruted,this.onAllianceInvitationStateRecruted);
         this.sysApi.addHook(AttackPlayer,this.onAttackPlayer);
         this.sysApi.addHook(DishonourChanged,this.onDishonourChanged);
         this.sysApi.addHook(OpenOneAlliance,this.onOpenOneAlliance);
         this.sysApi.addHook(OpenOneGuild,this.onOpenOneGuild);
         this.sysApi.addHook(OpenDareSearch,this.onOpenDareSearch);
         this.sysApi.addHook(ShowCollectedTaxCollector,this.onShowCollectedTaxCollector);
         this.sysApi.addHook(ShowTopTaxCollectors,this.onShowTopTaxCollectors);
         if(!this.sysApi.getData("guildBulletinLastVisitTimestamp"))
         {
            this.sysApi.setData("guildBulletinLastVisitTimestamp",0);
         }
         if(!this.sysApi.getData("allianceBulletinLastVisitTimestamp"))
         {
            this.sysApi.setData("allianceBulletinLastVisitTimestamp",0);
         }
      }
      
      public function get dareCreationStatus() : Object
      {
         return this._dareCreationStatus;
      }
      
      public function set dareCreationStatus(param1:Object) : void
      {
         this._dareCreationStatus = param1;
      }
      
      private function onCreateGuild(param1:Boolean, param2:Boolean) : void
      {
         this.uiApi.loadUi("guildCreator","guildCreator",[param1,param2]);
      }
      
      private function onCreateAlliance(param1:Boolean, param2:Boolean) : void
      {
         this.uiApi.loadUi("allianceCreator","allianceCreator",[param1,param2]);
      }
      
      private function onOpenOneGuild(param1:Object) : void
      {
         this.uiApi.unloadUi("allianceCard");
         if(!this.uiApi.getUi("guildCard"))
         {
            this.uiApi.loadUi("guildCard","guildCard",{"guild":param1});
         }
      }
      
      private function onOpenOneAlliance(param1:Object) : void
      {
         this.uiApi.unloadUi("guildCard");
         if(!this.uiApi.getUi("allianceCard"))
         {
            this.uiApi.loadUi("allianceCard","allianceCard",{"alliance":param1});
         }
      }
      
      private function onOpenDareSearch(param1:String, param2:String = null, param3:Boolean = true) : void
      {
         var _loc4_:Object = null;
         if(!this.uiApi.getUi("socialBase"))
         {
            _loc4_ = new Object();
            _loc4_.tab = 5;
            _loc4_.subTab = 0;
            _loc4_.params = !!param2?[param1,param2]:[param1];
            _loc4_.restoreSnapshotAfterLoading = false;
            this.uiApi.loadUi("socialBase","socialBase",_loc4_);
         }
         else
         {
            this.uiApi.getUi("socialBase").uiClass.openTab(5,0,!!param2?[param1,param2]:[param1]);
         }
      }
      
      private function onOpenSocial(param1:int = -1, param2:int = -1, param3:Object = null) : void
      {
         var _loc4_:Object = null;
         this.sysApi.log(2,"onOpenSocial " + param1 + ", " + param2 + ", " + param3);
         if(param1 == 2 && !this.playerApi.characteristics())
         {
            return;
         }
         if(param1 == 3)
         {
            if(!this.uiApi.getUi("spouse"))
            {
               this.sysApi.sendAction(new SpouseRequest());
               this.uiApi.loadUi("spouse");
            }
            else
            {
               this.uiApi.unloadUi("spouse");
            }
            return;
         }
         if(!this.uiApi.getUi("socialBase"))
         {
            if(param1 == 3 && this.socialApi.getSpouse() == null)
            {
               return;
            }
            _loc4_ = new Object();
            if(param1 != -1)
            {
               _loc4_.tab = param1;
            }
            if(param2 != -1)
            {
               _loc4_.subTab = param2;
            }
            if(param3 != null && param3.length > 0)
            {
               _loc4_.params = param3;
            }
            if(param2 == -1)
            {
               this.uiApi.loadUi("socialBase","socialBase",_loc4_);
            }
            else
            {
               this.uiApi.loadUi("socialBase","socialBase",_loc4_,1,null,false,false,false);
            }
         }
         else
         {
            this.sysApi.log(2,"uiApi.getUi(\'socialBase\').uiClass.getTab() " + this.uiApi.getUi("socialBase").uiClass.getTab() + " != tab " + param1);
            if(this.uiApi.getUi("socialBase").uiClass.getTab() != param1)
            {
               if(param2 == -1)
               {
                  this.uiApi.getUi("socialBase").uiClass.openTab(param1);
               }
               else if(param3 == null)
               {
                  this.uiApi.getUi("socialBase").uiClass.openTab(param1,param2,null,false);
               }
               else
               {
                  this.uiApi.getUi("socialBase").uiClass.openTab(param1,param2,param3,false);
               }
            }
            else
            {
               this.uiApi.unloadUi("socialBase");
            }
         }
      }
      
      private function onContextChanged(param1:uint) : void
      {
         if(param1 == 2)
         {
            this.uiApi.unloadUi("socialBase");
         }
      }
      
      private function onClientUIOpened(param1:uint, param2:uint) : void
      {
         if(this.socialApi.hasGuild())
         {
            if(!this.uiApi.getUi("socialBase"))
            {
               switch(param1)
               {
                  case 0:
                     this.sysApi.log(16,"Error : wrong UI type to open.");
                     break;
                  case 1:
                     this.uiApi.loadUi("socialBase","socialBase",{
                        "tab":1,
                        "subTab":4
                     },1,null,false,false,false);
                     break;
                  case 2:
                     this.uiApi.loadUi("socialBase","socialBase",{
                        "tab":1,
                        "subTab":3
                     },1,null,false,false,false);
                     break;
                  case 4:
                     this.uiApi.loadUi("socialBase","socialBase",{
                        "tab":1,
                        "subTab":2
                     },1,null,false,false,false);
               }
            }
            else if(this.uiApi.getUi("socialBase").uiClass.getTab() != 1)
            {
               switch(param1)
               {
                  case 1:
                     this.uiApi.getUi("socialBase").uiClass.openTab(1,4,null,false);
                     break;
                  case 2:
                     this.uiApi.getUi("socialBase").uiClass.openTab(1,3,null,false);
                     break;
                  case 4:
                     this.uiApi.getUi("socialBase").uiClass.openTab(1,2,null,false);
               }
            }
            else
            {
               this.sysApi.log(16,"Error : Social UI is already open.");
            }
         }
      }
      
      private function onDishonourChanged(param1:int) : void
      {
         var _loc2_:int = param1;
         if(_loc2_ > 9)
         {
            _loc2_ = 9;
         }
         var _loc3_:String = this.uiApi.processText(this.uiApi.getText("ui.social.disgraceSanction",param1),"n",param1 < 2);
         _loc3_ = _loc3_ + ("\n\n" + this.uiApi.getText("ui.disgrace.sanction.1"));
         this.modCommon.openPopup(this.uiApi.getText("ui.common.informations"),_loc3_,[this.uiApi.getText("ui.common.ok")]);
      }
      
      private function onAttackPlayer(param1:Number, param2:Boolean, param3:String, param4:int, param5:int) : void
      {
         var _loc6_:String = null;
         this._targetId = param1;
         this._cellId = param5;
         this._ava = param2;
         if(param2 || param4 == 0)
         {
            _loc6_ = this.uiApi.getText("ui.pvp.doUAttack",param3);
         }
         else if(param4 == 2)
         {
            _loc6_ = this.uiApi.getText("ui.pvp.doUAttackNeutral");
         }
         else if(param4 == -1)
         {
            _loc6_ = this.uiApi.getText("ui.pvp.doUAttackNoGain",param3);
         }
         else if(param4 == 1)
         {
            _loc6_ = this.uiApi.getText("ui.pvp.doUAttackBonusGain",param3);
         }
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc6_,[this.uiApi.getText("ui.common.attack"),this.uiApi.getText("ui.common.cancel")],[this.onConfirmAttack,null],this.onConfirmAttack);
      }
      
      private function onConfirmAttack() : void
      {
         this.sysApi.sendAction(new PlayerFightRequest(this._targetId,this._ava,false,true));
      }
      
      private function onGuildInvited(param1:String, param2:Number, param3:String) : void
      {
         this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.invitation"),this.uiApi.getText("ui.social.aInvitYouInGuild",param3,param1),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmJoinGuild,this.onCancelJoinGuild],this.onConfirmJoinGuild,this.onCancelJoinGuild);
      }
      
      private function onConfirmJoinGuild() : void
      {
         this.sysApi.sendAction(new GuildInvitationAnswer(true));
      }
      
      private function onCancelJoinGuild() : void
      {
         this.sysApi.sendAction(new GuildInvitationAnswer(false));
      }
      
      private function onGuildInvitationStateRecruter(param1:uint, param2:String) : void
      {
         switch(param1)
         {
            case 1:
               this._popupName = this.modCommon.openPopup(this.uiApi.getText("ui.common.invitation"),this.uiApi.getText("ui.craft.waitForCraftClient",param2),[this.uiApi.getText("ui.common.cancel")],[this.onCancelJoinGuild],null,this.onCancelJoinGuild);
               break;
            case 2:
            case 3:
               if(this._popupName && this.uiApi.getUi(this._popupName))
               {
                  this.uiApi.unloadUi(this._popupName);
                  this._popupName = null;
               }
         }
      }
      
      private function onGuildInvitationStateRecruted(param1:uint) : void
      {
         switch(param1)
         {
            case 1:
               break;
            case 2:
            case 3:
               if(this._popupName && this.uiApi.getUi(this._popupName))
               {
                  this.uiApi.unloadUi(this._popupName);
                  this._popupName = null;
               }
         }
      }
      
      private function onAllianceInvited(param1:String, param2:Number, param3:String) : void
      {
         this._popupAllianceName = this.modCommon.openPopup(this.uiApi.getText("ui.common.invitation"),this.uiApi.getText("ui.alliance.youAreInvited",param3,param1),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmJoinAlliance,this.onCancelJoinAlliance],this.onConfirmJoinAlliance,this.onCancelJoinAlliance);
      }
      
      private function onConfirmJoinAlliance() : void
      {
         this.sysApi.sendAction(new AllianceInvitationAnswer(true));
      }
      
      private function onCancelJoinAlliance() : void
      {
         this.sysApi.sendAction(new AllianceInvitationAnswer(false));
      }
      
      private function onAllianceInvitationStateRecruter(param1:uint, param2:String) : void
      {
         switch(param1)
         {
            case 1:
               this._popupAllianceName = this.modCommon.openPopup(this.uiApi.getText("ui.common.invitation"),this.uiApi.getText("ui.craft.waitForCraftClient",param2),[this.uiApi.getText("ui.common.cancel")],[this.onCancelJoinAlliance],null,this.onCancelJoinAlliance);
               break;
            case 2:
            case 3:
               if(this._popupAllianceName && this.uiApi.getUi(this._popupAllianceName))
               {
                  this.uiApi.unloadUi(this._popupAllianceName);
                  this._popupAllianceName = null;
               }
         }
      }
      
      private function onAllianceInvitationStateRecruted(param1:uint) : void
      {
         switch(param1)
         {
            case 1:
               break;
            case 2:
            case 3:
               if(this._popupAllianceName && this.uiApi.getUi(this._popupAllianceName))
               {
                  this.uiApi.unloadUi(this._popupAllianceName);
                  this._popupAllianceName = null;
               }
         }
      }
      
      private function onShowCollectedTaxCollector(param1:TaxCollectorWrapper) : void
      {
         this.uiApi.loadUi("collectedTaxCollector",null,param1,1,null,true);
      }
      
      private function onShowTopTaxCollectors(param1:Object, param2:Object) : void
      {
         this.uiApi.loadUi("topTaxCollectors",null,{
            "dungeonTopTaxCollectors":param1,
            "topTaxCollectors":param2
         },1,null,true);
      }
   }
}
