package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.GuildChangeMemberParameters;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import flash.utils.Dictionary;
   
   public class GuildMemberRights
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      private var _rightsList:Array;
      
      private var _memberInfo:Object;
      
      private var _playerId:Number;
      
      private var _percentXP:int;
      
      private var _playerRank:uint;
      
      private var _rankIndex:int;
      
      private var _currentRankId:uint;
      
      private var _partChangeRights:Boolean;
      
      private var _rigthBtnList:Dictionary;
      
      public var cb_rank:ComboBox;
      
      public var bgcb_rank:TextureBitmap;
      
      public var gd_list:Grid;
      
      public var btn_modify:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_changeGuildXP:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var lbl_rank:Label;
      
      public var lbl_guildXP:Label;
      
      public function GuildMemberRights()
      {
         this._rigthBtnList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.btn_modify.soundId = SoundEnum.OK_BUTTON;
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this._memberInfo = param1.memberInfo;
         this._partChangeRights = param1.rightsToChange;
         var _loc2_:Boolean = param1.displayRightsMember;
         var _loc3_:Boolean = param1.allowToManageRank;
         this.uiApi.addComponentHook(this.btn_changeGuildXP,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.cb_rank,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_modify,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         var _loc4_:Number = this.playerApi.id();
         this._playerId = this._memberInfo.id;
         this._percentXP = this._memberInfo.experienceGivenPercent;
         this._playerRank = this._memberInfo.rank;
         this._currentRankId = this._playerRank;
         this.lbl_guildXP.text = this._percentXP + " %";
         if(this._memberInfo.level > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this.lbl_title.text = this._memberInfo.name + " - <font size=\'14\'>" + this.uiApi.getText("ui.common.short.prestige") + (this._memberInfo.level - ProtocolConstantsEnum.MAX_LEVEL) + "</font>";
         }
         else
         {
            this.lbl_title.text = this._memberInfo.name + " - <font size=\'14\'>" + this.uiApi.getText("ui.common.short.level") + this._memberInfo.level + "</font>";
         }
         if(!param1.manageXPContribution)
         {
            if(!(param1.manageMyXPContribution && param1.selfPlayerItem))
            {
               this.btn_changeGuildXP.disabled = true;
            }
         }
         this._rightsList = new Array();
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsAllRights"),
            "rightString":"manageRights",
            "selected":this.socialApi.hasGuildRight(this._playerId,"manageRights"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"manageRights")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsBoost"),
            "rightString":"manageGuildBoosts",
            "selected":this.socialApi.hasGuildRight(this._playerId,"manageGuildBoosts"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"manageGuildBoosts")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsRights"),
            "rightString":"manageLightRights",
            "selected":this.socialApi.hasGuildRight(this._playerId,"manageLightRights"),
            "disabled":!_loc2_ || this._partChangeRights
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsInvit"),
            "rightString":"inviteNewMembers",
            "selected":this.socialApi.hasGuildRight(this._playerId,"inviteNewMembers"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"inviteNewMembers")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsBann"),
            "rightString":"banMembers",
            "selected":this.socialApi.hasGuildRight(this._playerId,"banMembers"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"banMembers")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsPercentXP"),
            "rightString":"manageXPContribution",
            "selected":this.socialApi.hasGuildRight(this._playerId,"manageXPContribution"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"manageXPContribution")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightManageOwnXP"),
            "rightString":"manageMyXpContribution",
            "selected":this.socialApi.hasGuildRight(this._playerId,"manageMyXpContribution"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"manageMyXpContribution")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsRank"),
            "rightString":"manageRanks",
            "selected":this.socialApi.hasGuildRight(this._playerId,"manageRanks"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"manageRanks")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsPrioritizeMe"),
            "rightString":"prioritizeMeInDefense",
            "selected":this.socialApi.hasGuildRight(this._playerId,"prioritizeMeInDefense"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"prioritizeMeInDefense")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsHiretax"),
            "rightString":"hireTaxCollector",
            "selected":this.socialApi.hasGuildRight(this._playerId,"hireTaxCollector"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"hireTaxCollector")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsCollect"),
            "rightString":"collect",
            "selected":this.socialApi.hasGuildRight(this._playerId,"collect"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"collect")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsCollectMy"),
            "rightString":"collectMyTaxCollectors",
            "selected":this.socialApi.hasGuildRight(this._playerId,"collectMyTaxCollectors"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"collectMyTaxCollectors")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsMountParkUse"),
            "rightString":"useFarms",
            "selected":this.socialApi.hasGuildRight(this._playerId,"useFarms"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"useFarms")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsMountParkArrange"),
            "rightString":"organizeFarms",
            "selected":this.socialApi.hasGuildRight(this._playerId,"organizeFarms"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"organizeFarms")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsManageOtherMount"),
            "rightString":"takeOthersRidesInFarm",
            "selected":this.socialApi.hasGuildRight(this._playerId,"takeOthersRidesInFarm"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"takeOthersRidesInFarm")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsSetAlliancePrism"),
            "rightString":"setAlliancePrism",
            "selected":this.socialApi.hasGuildRight(this._playerId,"setAlliancePrism"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"setAlliancePrism")
         });
         this._rightsList.push({
            "drm":_loc2_,
            "name":this.uiApi.getText("ui.social.guildRightsTalkInAllianceChannel"),
            "rightString":"talkInAllianceChannel",
            "selected":this.socialApi.hasGuildRight(this._playerId,"talkInAllianceChannel"),
            "disabled":!_loc2_ || this._partChangeRights && !this.socialApi.hasGuildRight(_loc4_,"talkInAllianceChannel")
         });
         this.gd_list.dataProvider = this._rightsList;
         if(_loc3_ && (this._playerRank != 1 || param1.iamBoss))
         {
            _loc5_ = this.dataApi.getAllRankNames();
            _loc6_ = new Array();
            _loc7_ = _loc5_.length;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc10_ = _loc5_[_loc9_];
               _loc11_ = {
                  "order":_loc10_.order,
                  "label":_loc10_.name,
                  "rankId":_loc10_.id
               };
               if(_loc10_.id != 1 || param1.iamBoss)
               {
                  _loc6_.push(_loc11_);
               }
               if(_loc10_.id == this._playerRank)
               {
                  _loc8_ = _loc11_;
               }
               _loc9_++;
            }
            _loc6_.sortOn("order",Array.NUMERIC);
            this.cb_rank.dataProvider = _loc6_;
            this.cb_rank.value = _loc8_;
            this._rankIndex = this.cb_rank.selectedIndex;
            this.cb_rank.visible = true;
            this.bgcb_rank.visible = true;
            this.lbl_rank.visible = false;
         }
         else
         {
            this.cb_rank.visible = false;
            this.bgcb_rank.visible = false;
            this.lbl_rank.visible = true;
            this.lbl_rank.text = this.dataApi.getRankName(this._playerRank).name;
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
      }
      
      public function updateRightLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Boolean = false;
         if(!this._rigthBtnList[param2.lblcb_right.name])
         {
            this.uiApi.addComponentHook(param2.lblcb_right,"onRelease");
         }
         this._rigthBtnList[param2.lblcb_right.name] = param1;
         if(param1)
         {
            param2.btn_label_lblcb_right.text = param1.name;
            param2.lblcb_right.selected = param1.selected;
            param2.lblcb_right.visible = true;
            param2.lblcb_right.disabled = param1.disabled;
         }
         else
         {
            param2.lblcb_right.visible = false;
         }
      }
      
      private function rightsToArray() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._rightsList)
         {
            if(_loc2_.selected)
            {
               _loc1_.push(_loc2_.rightString);
            }
         }
         return _loc1_;
      }
      
      private function onConfirmNewBoss() : void
      {
         this._playerRank = 1;
         this._rankIndex = this.cb_rank.selectedIndex;
      }
      
      private function onCancelNewBoss() : void
      {
         this.cb_rank.selectedIndex = this._rankIndex;
      }
      
      private function onValidQty(param1:Number) : void
      {
         this._percentXP = param1;
         this.lbl_guildXP.text = param1 + " %";
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(param1.name.indexOf("lblcb_right") != -1)
         {
            for each(_loc2_ in this._rightsList)
            {
               if(_loc2_.rightString == this._rigthBtnList[param1.name].rightString)
               {
                  _loc2_.selected = !_loc2_.selected;
                  break;
               }
            }
            _loc3_ = this.gd_list.verticalScrollValue;
            this.gd_list.updateItems();
            this.gd_list.verticalScrollValue = _loc3_;
         }
         else if(param1 == this.btn_modify)
         {
            this.sysApi.sendAction(new GuildChangeMemberParameters(this._playerId,this._playerRank,this._percentXP,this.rightsToArray()));
            this.uiApi.unloadUi("guildMemberRights");
         }
         else if(param1 == this.btn_close)
         {
            this.uiApi.unloadUi("guildMemberRights");
         }
         else if(param1 == this.btn_changeGuildXP)
         {
            this.modCommon.openQuantityPopup(0,90,this._percentXP,this.onValidQty,null,true);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.cb_rank)
         {
            if(param3 && param2 != 2)
            {
               if(param1.value.rankId == 1 && this._currentRankId != 1)
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.social.doUGiveRights",this._memberInfo.name),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmNewBoss,this.onCancelNewBoss],this.onConfirmNewBoss,this.onCancelNewBoss);
               }
               else
               {
                  this._playerRank = param1.value.rankId;
                  this._rankIndex = param1.selectedIndex;
               }
            }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.sysApi.sendAction(new GuildChangeMemberParameters(this._playerId,this._playerRank,this._percentXP,this.rightsToArray()));
               this.uiApi.unloadUi("guildMemberRights");
               return true;
            case "closeUi":
               this.uiApi.unloadUi("guildMemberRights");
               return true;
            default:
               return false;
         }
      }
   }
}
