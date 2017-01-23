package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.AllianceInsiderInfoRequest;
   import d2actions.EnemiesListRequest;
   import d2actions.FriendsListRequest;
   import d2actions.GuildFightLeaveRequest;
   import d2actions.PrismFightJoinLeaveRequest;
   import d2actions.SpouseRequest;
   import d2enums.LocationEnum;
   import d2hooks.AllianceMembershipUpdated;
   import d2hooks.GuildMembershipUpdated;
   import d2hooks.SpouseUpdated;
   
   public class SocialBase
   {
      
      private static var _shortcutColor:String;
       
      
      public var bindsApi:BindsApi;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var socialApi:SocialApi;
      
      public var soundApi:SoundApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var configApi:ConfigApi;
      
      public var dataApi:DataApi;
      
      private var _currentTabUi:int = -1;
      
      private var _hasGuild:Boolean;
      
      private var _hasAlliance:Boolean;
      
      private var _hasSpouse:Boolean;
      
      private var _friendList:Object;
      
      public var uiCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_tabFriend:ButtonContainer;
      
      public var btn_tabGuild:ButtonContainer;
      
      public var btn_tabAlliance:ButtonContainer;
      
      public var btn_tabDirectory:ButtonContainer;
      
      public var btn_tabDare:ButtonContainer;
      
      public var lbl_btn_tabFriend:Label;
      
      public var lbl_btn_tabGuild:Label;
      
      public var lbl_btn_tabAlliance:Label;
      
      public var lbl_btn_tabDirectory:Label;
      
      public var lbl_btn_tabDare:Label;
      
      public function SocialBase()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this.soundApi.playSound(SoundTypeEnum.SOCIAL_OPEN);
         this.btn_tabFriend.soundId = SoundEnum.TAB;
         this.btn_tabGuild.soundId = SoundEnum.TAB;
         this.btn_tabAlliance.soundId = SoundEnum.TAB;
         this.btn_tabDirectory.soundId = SoundEnum.TAB;
         this.btn_tabDare.soundId = SoundEnum.TAB;
         this.sysApi.addHook(SpouseUpdated,this.onSpouseUpdated);
         this.sysApi.addHook(GuildMembershipUpdated,this.onGuildMembershipUpdated);
         this.sysApi.addHook(AllianceMembershipUpdated,this.onAllianceMembershipUpdated);
         this.uiApi.addComponentHook(this.btn_tabFriend,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabFriend,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabFriend,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabGuild,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabGuild,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabGuild,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabAlliance,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabAlliance,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabAlliance,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabDirectory,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabDirectory,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabDirectory,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabDare,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabDare,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabDare,"onRollOut");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialFriends",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialGuild",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialAlliance",this.onShortcut);
         this.uiApi.addShortcutHook("openSocialSpouse",this.onShortcut);
         var _loc2_:OptionalFeature = this.dataApi.getOptionalFeatureByKeyword("dares");
         if(_loc2_ && this.configApi.isOptionalFeatureActive(_loc2_.id))
         {
            this.btn_tabDare.visible = true;
         }
         else
         {
            this.btn_tabDare.visible = false;
         }
         this._hasGuild = this.socialApi.hasGuild();
         this._hasAlliance = this.socialApi.hasAlliance();
         this._hasSpouse = this.socialApi.hasSpouse();
         this.displayTabs();
         this._currentTabUi = -2;
         if(param1 && param1.hasOwnProperty("tab"))
         {
            if(param1.hasOwnProperty("subTab"))
            {
               _loc4_ = this.uiApi.me().restoreSnapshotAfterLoading;
               if(param1.hasOwnProperty("restoreSnapshotAfterLoading"))
               {
                  _loc4_ = param1.restoreSnapshotAfterLoading;
               }
               if(param1.hasOwnProperty("params") && param1.params != null)
               {
                  this.openTab(param1.tab,param1.subTab,param1.params,_loc4_);
               }
               else
               {
                  this.openTab(param1.tab,param1.subTab,null,_loc4_);
               }
            }
            else
            {
               this.openTab(param1.tab,0,null,false);
            }
         }
         else
         {
            this.openTab(-1);
         }
         if(!_shortcutColor)
         {
            _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
            _shortcutColor = _shortcutColor.replace("0x","#");
         }
         this.lbl_btn_tabFriend.text = this.uiApi.getText("ui.common.friends");
         _loc3_ = this.bindsApi.getShortcutBindStr("openSocialFriends");
         if(_loc3_ != "")
         {
            this.lbl_btn_tabFriend.text = this.lbl_btn_tabFriend.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc3_ + ")</font>");
         }
         this.lbl_btn_tabGuild.text = this.uiApi.getText("ui.common.guild");
         _loc3_ = this.bindsApi.getShortcutBindStr("openSocialGuild");
         if(_loc3_ != "")
         {
            this.lbl_btn_tabGuild.text = this.lbl_btn_tabGuild.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc3_ + ")</font>");
         }
         this.lbl_btn_tabAlliance.text = this.uiApi.getText("ui.common.alliance");
         _loc3_ = this.bindsApi.getShortcutBindStr("openSocialAlliance");
         if(_loc3_ != "")
         {
            this.lbl_btn_tabAlliance.text = this.lbl_btn_tabAlliance.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc3_ + ")</font>");
         }
         this.lbl_btn_tabDirectory.text = this.uiApi.getText("ui.common.directory");
         this.lbl_btn_tabDare.text = this.uiApi.getText("ui.dare.dare");
         _loc3_ = this.bindsApi.getShortcutBindStr("openDare");
         if(_loc3_ != "")
         {
            this.lbl_btn_tabDare.text = this.lbl_btn_tabDare.text + (" <font color=\'" + _shortcutColor + "\'>(" + _loc3_ + ")</font>");
         }
      }
      
      public function unload() : void
      {
         this.sysApi.sendAction(new GuildFightLeaveRequest(0,this.playerApi.id(),true));
         this.sysApi.sendAction(new PrismFightJoinLeaveRequest(0,false));
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
         this.closeTab(this._currentTabUi);
      }
      
      public function getTab() : int
      {
         return this._currentTabUi;
      }
      
      private function displayTabs() : void
      {
         if(this.btn_tabGuild.softDisabled == this._hasGuild)
         {
            this.btn_tabGuild.softDisabled = !this._hasGuild;
         }
         if(this.btn_tabAlliance.softDisabled == this._hasAlliance)
         {
            this.btn_tabAlliance.softDisabled = !this._hasAlliance;
         }
         if(this._currentTabUi == 1 && this.btn_tabGuild.softDisabled)
         {
            this.openTab(0);
         }
         if(this._currentTabUi == 2 && this.btn_tabAlliance.softDisabled)
         {
            this.openTab(0);
         }
      }
      
      public function openTab(param1:int = -1, param2:int = 0, param3:Object = null, param4:Boolean = true) : void
      {
         var _loc5_:uint = 0;
         if(param1 != -1 && (this._currentTabUi == param1 || this.getButtonByTab(param1).disabled || this.getButtonByTab(param1).softDisabled))
         {
            return;
         }
         if(this._currentTabUi > -1)
         {
            this.uiApi.unloadUi("subSocialUi");
         }
         if(param1 == -1)
         {
            _loc5_ = this.sysApi.getData("lastSocialTab");
            if(_loc5_ && !this.getButtonByTab(_loc5_).disabled)
            {
               this._currentTabUi = _loc5_;
            }
            else
            {
               this._currentTabUi = 0;
            }
         }
         else
         {
            this._currentTabUi = param1;
         }
         if(this._currentTabUi == 0)
         {
            this.sysApi.sendAction(new FriendsListRequest());
            this.sysApi.sendAction(new EnemiesListRequest());
         }
         else if(this._currentTabUi == 2)
         {
            this.sysApi.sendAction(new AllianceInsiderInfoRequest());
         }
         else if(this._currentTabUi == 3)
         {
            this.sysApi.sendAction(new SpouseRequest());
         }
         else if(this._currentTabUi != 4)
         {
            if(this._currentTabUi == 5)
            {
               this.sysApi.log(2,"Récupération de la liste complete des défis ?");
            }
         }
         this.sysApi.setData("lastSocialTab",this._currentTabUi);
         this.uiCtr.getUi().restoreSnapshotAfterLoading = param4;
         this.uiApi.loadUiInside(this.getUiNameByTab(this._currentTabUi),this.uiCtr,"subSocialUi",[param2,param3]);
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.getButtonByTab(this._currentTabUi),this.uiApi.me());
         this.getButtonByTab(this._currentTabUi).selected = true;
      }
      
      private function closeTab(param1:uint) : void
      {
         this.uiApi.unloadUi("subSocialUi");
      }
      
      private function getButtonByTab(param1:uint) : Object
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case 0:
               _loc2_ = this.btn_tabFriend;
               break;
            case 1:
               _loc2_ = this.btn_tabGuild;
               break;
            case 2:
               _loc2_ = this.btn_tabAlliance;
               break;
            case 4:
               _loc2_ = this.btn_tabDirectory;
               break;
            case 5:
               _loc2_ = this.btn_tabDare;
         }
         return _loc2_;
      }
      
      private function getUiNameByTab(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 0:
               _loc2_ = "friends";
               break;
            case 1:
               _loc2_ = "guild";
               break;
            case 2:
               _loc2_ = "alliance";
               break;
            case 3:
               _loc2_ = "spouse";
               break;
            case 4:
               _loc2_ = "directory";
               break;
            case 5:
               _loc2_ = "dare";
         }
         return _loc2_;
      }
      
      private function closeSocial() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      private function onGuildMembershipUpdated(param1:Boolean) : void
      {
         this._hasGuild = param1;
         this.displayTabs();
      }
      
      private function onAllianceMembershipUpdated(param1:Boolean) : void
      {
         this._hasAlliance = param1;
         this.displayTabs();
      }
      
      private function onSpouseUpdated() : void
      {
         this._hasSpouse = this.socialApi.hasSpouse();
         this.displayTabs();
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.closeSocial();
               break;
            case this.btn_tabFriend:
               this.openTab(0);
               break;
            case this.btn_tabGuild:
               this.openTab(1);
               break;
            case this.btn_tabAlliance:
               this.openTab(2);
               break;
            case this.btn_tabDirectory:
               this.openTab(4);
               break;
            case this.btn_tabDare:
               this.openTab(5);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "openSocialFriends":
               if(this._currentTabUi == 0)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(0);
               }
               return true;
            case "openSocialGuild":
               if(this._currentTabUi == 1)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(1);
               }
               return true;
            case "openSocialAlliance":
               if(this._currentTabUi == 2)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(2);
               }
               return true;
            case "openSocialSpouse":
               if(this._currentTabUi == 3)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
                  return true;
               }
               if(this.socialApi.getSpouse() != null)
               {
                  this.openTab(3);
                  return true;
               }
               return false;
            case "openDare":
               if(this._currentTabUi == 2)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this.openTab(5);
               }
               return true;
            case "closeUi":
               this.closeSocial();
               return true;
            default:
               return false;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:uint = LocationEnum.POINT_LEFT;
         var _loc3_:uint = LocationEnum.POINT_RIGHT;
         var _loc4_:String = "";
         var _loc5_:String = "";
         switch(param1)
         {
            case this.btn_tabGuild:
               _loc4_ = this.uiApi.getText("ui.banner.lockBtn.guild");
               break;
            case this.btn_tabAlliance:
               _loc4_ = this.uiApi.getText("ui.banner.lockBtn.alliance");
         }
         if(param1.softDisabled)
         {
            if(_loc4_)
            {
               _loc5_ = _loc4_;
            }
         }
         if(_loc5_ && _loc5_ != "")
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc5_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
