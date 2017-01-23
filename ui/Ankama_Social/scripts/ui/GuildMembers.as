package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.communication.Smiley;
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatusExtended;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.utils.PlayerGuildRights;
   import d2actions.GameFightSpectatePlayerRequest;
   import d2actions.GuildGetInformations;
   import d2actions.GuildKickRequest;
   import d2actions.MemberWarningSet;
   import d2enums.ComponentHookList;
   import d2enums.GuildInformationsTypeEnum;
   import d2enums.PlayerStateEnum;
   import d2enums.PlayerStatusEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.StrataEnum;
   import d2hooks.GuildInformationsMemberUpdate;
   import d2hooks.GuildInformationsMembers;
   import d2hooks.MemberWarningState;
   import flash.utils.Dictionary;
   
   public class GuildMembers
   {
      
      private static var _showOfflineMembers:Boolean = false;
      
      private static var _warnWhenMemberIsOnline:Boolean = false;
      
      public static var playerRights:uint;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _membersList:Object;
      
      private var _iconsPath:String;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _interactiveComponentsList:Dictionary;
      
      private var _memberIdWaitingForKick:Number;
      
      public var gd_list:Grid;
      
      public var btn_showOfflineMembers:ButtonContainer;
      
      public var btn_warnWhenMemberIsOnline:ButtonContainer;
      
      public var lbl_membersNumber:Label;
      
      public var lbl_membersLevel:Label;
      
      public var btn_tabBreed:ButtonContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabRank:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var btn_tabXP:ButtonContainer;
      
      public var btn_tabXPP:ButtonContainer;
      
      public var btn_tabAchievement:ButtonContainer;
      
      public var btn_tabState:ButtonContainer;
      
      public var tx_status:Texture;
      
      public function GuildMembers()
      {
         this._interactiveComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(GuildInformationsMembers,this.onGuildMembersUpdated);
         this.sysApi.addHook(MemberWarningState,this.onMemberWarningState);
         this.sysApi.addHook(GuildInformationsMemberUpdate,this.onGuildInformationsMemberUpdate);
         this.uiApi.addComponentHook(this.btn_showOfflineMembers,"onRelease");
         this.uiApi.addComponentHook(this.btn_warnWhenMemberIsOnline,"onRelease");
         this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_MEMBERS));
         this._iconsPath = this.uiApi.me().getConstant("icons_uri");
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this.btn_showOfflineMembers.selected = _showOfflineMembers;
         this.btn_warnWhenMemberIsOnline.selected = this.socialApi.getWarnOnMemberConnec();
      }
      
      public function unload() : void
      {
      }
      
      public function updateGuildMemberLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:* = false;
         var _loc7_:Smiley = null;
         if(!this._interactiveComponentsList[param2.btn_kick.name])
         {
            this.uiApi.addComponentHook(param2.btn_kick,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_kick,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_kick,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.btn_kick.name] = param1;
         if(!this._interactiveComponentsList[param2.btn_rights.name])
         {
            this.uiApi.addComponentHook(param2.btn_rights,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_rights,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_rights,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.btn_rights.name] = param1;
         if(!this._interactiveComponentsList[param2.lbl_playerName.name])
         {
            this.uiApi.addComponentHook(param2.lbl_playerName,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_playerName,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.lbl_playerName.name] = param1;
         if(!this._interactiveComponentsList[param2.tx_status.name])
         {
            this.uiApi.addComponentHook(param2.tx_status,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_status,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.tx_status.name] = param1;
         if(!this._interactiveComponentsList[param2.tx_state.name])
         {
            this.uiApi.addComponentHook(param2.tx_state,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_state,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.tx_state,ComponentHookList.ON_RELEASE);
         }
         this._interactiveComponentsList[param2.tx_state.name] = param1;
         if(!this._interactiveComponentsList[param2.tx_mood.name])
         {
            this.uiApi.addComponentHook(param2.tx_mood,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_mood,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.tx_mood,ComponentHookList.ON_RELEASE);
         }
         this._interactiveComponentsList[param2.tx_mood.name] = param1;
         if(!this._interactiveComponentsList[param2.tx_fight.name])
         {
            this.uiApi.addComponentHook(param2.tx_fight,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_fight,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.tx_fight,ComponentHookList.ON_RELEASE);
         }
         this._interactiveComponentsList[param2.tx_fight.name] = param1;
         if(param1 != null)
         {
            _loc4_ = param1.member;
            _loc5_ = param1.displayRightsMember || PlayerGuildRights.isBoss(playerRights) || PlayerGuildRights.manageGuildBoosts(playerRights) || PlayerGuildRights.manageRanks(playerRights) || PlayerGuildRights.manageRights(playerRights) || PlayerGuildRights.manageLightRights(playerRights) || PlayerGuildRights.manageXPContribution(playerRights);
            _loc6_ = this.playerApi.id() == _loc4_.id;
            param2.lbl_rank.text = param1.rankName;
            param2.lbl_XPP.text = _loc4_.experienceGivenPercent + "%";
            param2.lbl_XP.text = this.utilApi.kamasToString(_loc4_.givenExperience,"");
            param2.tx_mood.uri = null;
            param2.tx_fight.uri = null;
            param2.tx_status.uri = null;
            param2.tx_lvl.uri = null;
            if(_loc4_.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               param2.lbl_lvl.text = _loc4_.level - ProtocolConstantsEnum.MAX_LEVEL;
               param2.tx_lvl.uri = this._bgPrestigeUri;
            }
            else
            {
               param2.lbl_lvl.text = _loc4_.level;
               param2.tx_lvl.uri = this._bgLevelUri;
            }
            param2.tx_head.uri = this.uiApi.createUri(this.uiApi.me().getConstant("heads") + param1.breed + "" + param1.sex + ".png");
            if(param1.achievementPoints == -1)
            {
               param2.lbl_achievement.text = "-";
            }
            else
            {
               param2.lbl_achievement.text = param1.achievementPoints;
            }
            if(_loc4_.connected != PlayerStateEnum.NOT_CONNECTED && _loc4_.moodSmileyId != 0)
            {
               _loc7_ = this.dataApi.getSmiley(_loc4_.moodSmileyId);
               if(_loc7_)
               {
                  param2.tx_mood.uri = this.uiApi.createUri(this.uiApi.me().getConstant("smilies_uri") + _loc7_.gfxId);
               }
            }
            if(_loc4_.connected == PlayerStateEnum.NOT_CONNECTED)
            {
               param2.tx_state.uri = this.uiApi.createUri(this.uiApi.me().getConstant("offline_uri"));
               param2.lbl_playerName.text = _loc4_.name;
            }
            else if(_loc4_.connected == PlayerStateEnum.GAME_TYPE_ROLEPLAY)
            {
               param2.lbl_playerName.text = "{player," + _loc4_.name + "," + _loc4_.id + "::" + _loc4_.name + "}";
               param2.tx_state.uri = null;
            }
            else if(_loc4_.connected == PlayerStateEnum.GAME_TYPE_FIGHT)
            {
               param2.lbl_playerName.text = "{player," + _loc4_.name + "," + _loc4_.id + "::" + _loc4_.name + "}";
               if(_loc4_.moodSmileyId == 0)
               {
                  param2.tx_state.uri = this.uiApi.createUri(this.uiApi.me().getConstant("fight_uri"));
               }
               else
               {
                  param2.tx_state.uri = null;
                  param2.tx_fight.uri = this.uiApi.createUri(this.uiApi.me().getConstant("assets") + "Social_tx_fightState_small");
               }
            }
            else if(_loc4_.connected == PlayerStateEnum.UNKNOWN_STATE)
            {
               param2.lbl_playerName.text = _loc4_.name;
               param2.tx_state.uri = null;
            }
            else
            {
               param2.lbl_playerName.text = _loc4_.name;
               param2.tx_state.uri = null;
            }
            if(_loc4_.connected != PlayerStateEnum.NOT_CONNECTED)
            {
               if(_loc4_.status.statusId)
               {
                  switch(_loc4_.status.statusId)
                  {
                     case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                        param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "green.png");
                        break;
                     case PlayerStatusEnum.PLAYER_STATUS_AFK:
                     case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                        param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "yellow.png");
                        break;
                     case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                        param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "blue.png");
                        break;
                     case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                        param2.tx_status.uri = this.uiApi.createUri(this._iconsPath + "red.png");
                  }
               }
               else
               {
                  param2.tx_status.uri = null;
               }
            }
            if(param1.displayBanMember)
            {
               param2.btn_kick.visible = true;
            }
            else
            {
               param2.btn_kick.visible = _loc6_;
            }
            if(_loc5_)
            {
               param2.btn_rights.visible = true;
            }
            else
            {
               param2.btn_rights.visible = _loc6_;
            }
         }
         else
         {
            param2.lbl_playerName.text = "";
            param2.lbl_rank.text = "";
            param2.tx_lvl.uri = null;
            param2.lbl_lvl.text = "";
            param2.lbl_XPP.text = "";
            param2.lbl_XP.text = "";
            param2.tx_head.uri = null;
            param2.tx_state.uri = null;
            param2.tx_mood.uri = null;
            param2.tx_fight.uri = null;
            param2.btn_rights.visible = false;
            param2.btn_kick.visible = false;
            param2.tx_status.uri = null;
            param2.lbl_achievement.text = "";
         }
      }
      
      private function popupDeletePlayer(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.isBoss && !param1.isAlone)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.social.guildBossCantBeBann"),[this.uiApi.getText("ui.common.ok")]);
         }
         else
         {
            if(this.playerApi.id() == param1.member.id)
            {
               _loc2_ = this.uiApi.getText("ui.social.doUDeleteYou");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.social.doUDeleteMember",param1.member.name);
            }
            this._memberIdWaitingForKick = param1.member.id;
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc2_,[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmDeletePlayer,this.onCancelDeletePlayer],this.onConfirmDeletePlayer,this.onCancelDeletePlayer);
         }
      }
      
      private function onConfirmDeletePlayer() : void
      {
         this.sysApi.sendAction(new GuildKickRequest(this._memberIdWaitingForKick));
         this._memberIdWaitingForKick = 0;
      }
      
      private function onCancelDeletePlayer() : void
      {
         this._memberIdWaitingForKick = 0;
      }
      
      private function displayMemberRights(param1:Object) : void
      {
         if(this.uiApi.getUi("guildMemberRights") != null)
         {
            this.uiApi.unloadUi("guildMemberRights");
         }
         var _loc2_:Boolean = PlayerGuildRights.isBoss(playerRights) || PlayerGuildRights.manageGuildBoosts(playerRights) || PlayerGuildRights.manageRights(playerRights) || PlayerGuildRights.manageLightRights(playerRights);
         var _loc3_:Boolean = PlayerGuildRights.manageLightRights(playerRights) && !PlayerGuildRights.isBoss(playerRights) && !PlayerGuildRights.manageRights(playerRights);
         this.uiApi.loadUi("guildMemberRights","guildMemberRights",{
            "memberInfo":param1.member,
            "displayRightsMember":_loc2_,
            "allowToManageRank":param1.manageRanks,
            "manageXPContribution":param1.manageXPContribution,
            "manageMyXPContribution":param1.manageMyXPContribution,
            "selfPlayerItem":this.playerApi.id() == param1.member.id,
            "iamBoss":PlayerGuildRights.isBoss(playerRights),
            "rightsToChange":_loc3_
         },StrataEnum.STRATA_TOP);
      }
      
      private function onGuildMembersUpdated(param1:Object) : void
      {
         var _loc7_:GuildMember = null;
         this._membersList = param1;
         var _loc2_:Array = new Array();
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = this.socialApi.getGuild().manageXPContribution;
         for each(_loc7_ in this._membersList)
         {
            if(_loc7_.id == this.playerApi.id())
            {
               playerRights = _loc7_.rights;
            }
            _loc4_ = _loc4_ + _loc7_.level;
            if(_loc7_.connected || _showOfflineMembers)
            {
               _loc2_.push(this.createMemberObject(_loc7_,_loc3_ == 1));
               if(_loc7_.connected)
               {
                  _loc5_++;
               }
            }
         }
         _loc2_.sortOn("rankOrder",Array.NUMERIC);
         this.gd_list.dataProvider = _loc2_;
         this.lbl_membersLevel.text = this.uiApi.getText("ui.social.guildAvgMembersLevel") + this.uiApi.getText("ui.common.colon") + int(_loc4_ / _loc3_);
         this.lbl_membersNumber.text = this.uiApi.getText("ui.social.guildMembers") + this.uiApi.getText("ui.common.colon") + _loc5_ + " / " + _loc3_;
      }
      
      public function onGuildInformationsMemberUpdate(param1:Object) : void
      {
         var _loc2_:GuildMember = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc2_ in this._membersList)
         {
            if(_loc2_.id == param1.id)
            {
               _loc2_ = param1 as GuildMember;
               _loc3_ = 0;
               _loc4_ = 0;
               while(_loc4_ < this.gd_list.dataProvider.length)
               {
                  if(this.gd_list.dataProvider[_loc4_].id == param1.id)
                  {
                     _loc3_ = _loc4_;
                  }
                  _loc4_++;
               }
               this.gd_list.updateItem(_loc3_);
               return;
            }
         }
      }
      
      private function onMemberWarningState(param1:Boolean) : void
      {
         if(this.btn_warnWhenMemberIsOnline.selected != param1)
         {
            this.btn_warnWhenMemberIsOnline.selected = param1;
         }
      }
      
      private function createMemberObject(param1:Object, param2:Boolean) : Object
      {
         var _loc3_:Object = this.socialApi.getGuild();
         var _loc4_:Object = new Object();
         _loc4_.id = param1.id;
         _loc4_.member = param1;
         _loc4_.manageXPContribution = _loc3_.manageXPContribution;
         _loc4_.manageMyXPContribution = _loc3_.manageMyXpContribution;
         _loc4_.manageRanks = _loc3_.manageRanks;
         _loc4_.displayBanMember = _loc3_.banMembers;
         _loc4_.displayRightsMember = _loc3_.manageRights;
         _loc4_.displayLightRightsMember = _loc3_.manageLightRights;
         _loc4_.name = param1.name;
         _loc4_.breed = param1.breed;
         var _loc5_:Object = this.dataApi.getRankName(param1.rank);
         _loc4_.isBoss = param1.rank == 1;
         _loc4_.rankName = _loc5_.name;
         _loc4_.rankOrder = _loc5_.order;
         _loc4_.level = param1.level;
         _loc4_.XP = param1.givenExperience;
         _loc4_.XPP = param1.experienceGivenPercent;
         _loc4_.state = param1.connected;
         _loc4_.sex = !!param1.sex?1:0;
         _loc4_.isAlone = param2;
         _loc4_.achievementPoints = param1.achievementPoints;
         _loc4_.status = param1.status;
         return _loc4_;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == this.btn_showOfflineMembers)
         {
            _showOfflineMembers = this.btn_showOfflineMembers.selected;
            if(this._membersList != null)
            {
               this.onGuildMembersUpdated(this._membersList);
            }
         }
         else if(param1 == this.btn_warnWhenMemberIsOnline)
         {
            this.sysApi.sendAction(new MemberWarningSet(this.btn_warnWhenMemberIsOnline.selected));
         }
         else if(param1 == this.btn_tabBreed)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("breed",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("breed",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabName)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("name",Array.CASEINSENSITIVE);
            }
            else
            {
               this.gd_list.sortOn("name",Array.CASEINSENSITIVE | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabRank)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("rankOrder",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("rankOrder",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabLevel)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("level",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("level",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabXP)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("XP",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("XP",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabXPP)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("XPP",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("XPP",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabAchievement)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("achievementPoints",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("achievementPoints",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabState)
         {
            if(this._bDescendingSort)
            {
               this.gd_list.sortOn("state",Array.NUMERIC);
            }
            else
            {
               this.gd_list.sortOn("state",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1.name.indexOf("btn_rights") != -1)
         {
            _loc2_ = this._interactiveComponentsList[param1.name];
            this.displayMemberRights(_loc2_);
         }
         else if(param1.name.indexOf("btn_kick") != -1)
         {
            _loc3_ = this._interactiveComponentsList[param1.name];
            this.popupDeletePlayer(_loc3_);
         }
         else if(param1.name.indexOf("tx_state") != -1 || param1.name.indexOf("tx_mood") != -1 || param1.name.indexOf("tx_fight") != -1)
         {
            _loc2_ = this._interactiveComponentsList[param1.name];
            if(_loc2_.member.connected == PlayerStateEnum.GAME_TYPE_FIGHT)
            {
               this.sysApi.sendAction(new GameFightSpectatePlayerRequest(_loc2_.id));
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc3_:uint = 6;
         var _loc4_:uint = 0;
         if(param1.name.indexOf("btn_rights") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.social.guildManageRights");
         }
         else if(param1.name.indexOf("btn_kick") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.charsel.characterDelete");
         }
         else if(param1.name.indexOf("tx_state") != -1 || param1.name.indexOf("tx_mood") != -1 || param1.name.indexOf("tx_fight") != -1)
         {
            _loc5_ = this._interactiveComponentsList[param1.name];
            if(_loc5_.member.connected == PlayerStateEnum.GAME_TYPE_FIGHT)
            {
               _loc2_ = this.uiApi.getText("ui.spectator.clicToJoin");
            }
         }
         else if(param1.name.indexOf("lbl_playerName") != -1)
         {
            _loc5_ = this._interactiveComponentsList[param1.name];
            if(!_loc5_)
            {
               return;
            }
            _loc6_ = _loc5_.member;
            if(_loc6_ && _loc6_.connected == 0)
            {
               _loc7_ = Math.floor(_loc6_.hoursSinceLastConnection / 720);
               _loc8_ = (_loc6_.hoursSinceLastConnection - _loc7_ * 720) / 24;
               if(_loc7_ > 0)
               {
                  if(_loc8_ > 0)
                  {
                     _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.social.monthsAndDaysSinceLastConnection",_loc7_,_loc8_),"m",_loc8_ <= 1);
                  }
                  else
                  {
                     _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",_loc7_),"m",_loc7_ <= 1);
                  }
               }
               else if(_loc8_ > 0)
               {
                  _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.social.daysSinceLastConnection",_loc8_),"m",_loc8_ <= 1);
               }
               else
               {
                  _loc9_ = this.uiApi.getText("ui.social.lessThanADay");
               }
               _loc2_ = this.uiApi.getText("ui.social.lastConnection",_loc9_);
            }
         }
         else if(param1.name.indexOf("tx_status") != -1)
         {
            _loc10_ = this._interactiveComponentsList[param1.name];
            if(!_loc10_)
            {
               return;
            }
            _loc11_ = _loc10_.member;
            if(_loc11_ && _loc11_.connected != 0)
            {
               switch(_loc11_.status.statusId)
               {
                  case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.availiable");
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.idle");
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_AFK:
                     _loc2_ = this.uiApi.getText("ui.chat.status.away");
                     if(_loc11_.status is PlayerStatusExtended && PlayerStatusExtended(_loc11_.status).message != "")
                     {
                        _loc2_ = _loc2_ + (this.uiApi.getText("ui.common.colon") + PlayerStatusExtended(_loc11_.status).message);
                     }
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.private");
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                     _loc2_ = this.uiApi.getText("ui.chat.status.solo");
               }
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
