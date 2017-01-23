package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.communication.Smiley;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.AddEnemy;
   import d2actions.AddFriend;
   import d2actions.AddIgnored;
   import d2actions.FriendWarningSet;
   import d2actions.GameFightSpectatePlayerRequest;
   import d2actions.RemoveEnemy;
   import d2actions.RemoveFriend;
   import d2actions.RemoveIgnored;
   import d2enums.ComponentHookList;
   import d2enums.PlayerStateEnum;
   import d2enums.PlayerStatusEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.EnemiesListUpdated;
   import d2hooks.EnemyAdded;
   import d2hooks.EnemyRemoved;
   import d2hooks.FocusChange;
   import d2hooks.FriendAdded;
   import d2hooks.FriendRemoved;
   import d2hooks.FriendWarningState;
   import d2hooks.FriendsListUpdated;
   import d2hooks.IgnoredAdded;
   import d2hooks.IgnoredRemoved;
   import flash.utils.Dictionary;
   
   public class Friends
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var chatApi:ChatApi;
      
      public var utilApi:UtilApi;
      
      private var _friendsList:Object;
      
      private var _enemiesList:Object;
      
      private var _ignoredList:Object;
      
      private var _nCurrentTab:uint = 0;
      
      private var _bShowOfflineGuys:Boolean = false;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _interactiveComponentsList:Dictionary;
      
      private var _iconsPath:String;
      
      private var _friendIdWaitingForKick:int = -1;
      
      private var _enemyIdWaitingForKick:int = -1;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      public var btn_friend:ButtonContainer;
      
      public var btn_enemy:ButtonContainer;
      
      public var btn_ignored:ButtonContainer;
      
      public var inp_add:Input;
      
      public var lbl_add:Label;
      
      public var btn_add:ButtonContainer;
      
      public var gd_list:Grid;
      
      public var btn_showOfflineFriends:ButtonContainer;
      
      public var btn_warnWhenFriendIsOnline:ButtonContainer;
      
      public var btn_tabBreed:ButtonContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var btn_tabGuild:ButtonContainer;
      
      public var btn_tabAchievement:ButtonContainer;
      
      public var btn_tabState:ButtonContainer;
      
      public function Friends()
      {
         this._interactiveComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         this.btn_add.soundId = SoundEnum.SPEC_BUTTON;
         this.btn_friend.soundId = SoundEnum.TAB;
         this.btn_enemy.soundId = SoundEnum.TAB;
         this.btn_ignored.soundId = SoundEnum.TAB;
         this.sysApi.addHook(FriendsListUpdated,this.onFriendsUpdated);
         this.sysApi.addHook(EnemiesListUpdated,this.onEnemiesUpdated);
         this.sysApi.addHook(FriendAdded,this.onFriendAdded);
         this.sysApi.addHook(EnemyAdded,this.onEnemyAdded);
         this.sysApi.addHook(FriendRemoved,this.onFriendRemoved);
         this.sysApi.addHook(EnemyRemoved,this.onEnemyRemoved);
         this.sysApi.addHook(FriendWarningState,this.onFriendWarningState);
         this.sysApi.addHook(IgnoredAdded,this.onIgnoredAdded);
         this.sysApi.addHook(IgnoredRemoved,this.onIgnoredRemoved);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this.uiApi.addComponentHook(this.btn_add,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_showOfflineFriends,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_warnWhenFriendIsOnline,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_friend,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_enemy,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_ignored,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this._iconsPath = this.uiApi.me().getConstant("icons_uri");
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this._friendsList = this.socialApi.getFriendsList();
         this._enemiesList = this.socialApi.getEnemiesList();
         this._ignoredList = this.socialApi.getIgnoredList();
         var _loc2_:String = this.sysApi.getCurrentLanguage();
         var _loc3_:Boolean = this.sysApi.getPlayerManager().hasRights;
         if(!_loc3_)
         {
            switch(_loc2_)
            {
               case "ja":
                  this.inp_add.restrict = "[ァ-ヾぁ-ゞA-Za-z\\-]+";
                  break;
               case "fr":
               case "en":
               case "es":
               case "de":
               case "it":
               case "nl":
               case "pt":
               case "ru":
               default:
                  this.inp_add.restrict = "^ ";
            }
         }
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_friend,this.uiApi.me());
         this.btn_friend.selected = true;
         this.btn_showOfflineFriends.selected = false;
         this.btn_warnWhenFriendIsOnline.selected = this.socialApi.getWarnOnFriendConnec();
         this.displaySelectedTab(this._nCurrentTab);
      }
      
      public function unload() : void
      {
      }
      
      public function updateFriendLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:* = null;
         var _loc5_:EmblemSymbol = null;
         var _loc6_:Smiley = null;
         if(!this._interactiveComponentsList[param2.btn_delete.name])
         {
            this.uiApi.addComponentHook(param2.btn_delete,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_delete,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_delete,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.btn_delete.name] = param1;
         if(!this._interactiveComponentsList[param2.lbl_name.name])
         {
            this.uiApi.addComponentHook(param2.lbl_name,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_name,ComponentHookList.ON_ROLL_OUT);
         }
         this._interactiveComponentsList[param2.lbl_name.name] = param1;
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
         if(param1)
         {
            param2.lbl_name.text = "{account," + param1.name + "," + param1.accountId + "::" + param1.name + "}";
            param2.btn_delete.visible = true;
            param2.tx_mood.uri = null;
            param2.tx_fight.uri = null;
            param2.tx_status.uri = null;
            param2.tx_emblemBackGuild.uri = null;
            param2.tx_emblemUpGuild.uri = null;
            param2.tx_level.uri = null;
            if(param1.type == "Ignored")
            {
               param2.lbl_level.text = "";
               param2.lbl_guild.text = "";
               param2.lbl_achievement.text = "";
               param2.tx_state.uri = null;
               param2.tx_head.uri = null;
            }
            else if(!param1.online)
            {
               param2.lbl_level.text = "-";
               param2.lbl_guild.text = "-";
               param2.lbl_achievement.text = "-";
               param2.tx_state.uri = null;
               param2.tx_head.uri = null;
            }
            else
            {
               if(param1.playerId)
               {
                  _loc4_ = "{player," + param1.playerName + "," + param1.playerId + "::" + param1.name + " (" + param1.playerName + ")}";
               }
               else
               {
                  _loc4_ = "{player," + param1.playerName + "::" + param1.name + " (" + param1.playerName + ")}";
               }
               param2.lbl_name.text = _loc4_;
               param2.lbl_level.text = "?";
               param2.tx_head.uri = this.uiApi.createUri(this.uiApi.me().getConstant("heads") + param1.breed + "" + param1.sex + ".png");
               if(param1.type == "Enemy")
               {
                  param2.lbl_guild.text = "?";
                  param2.lbl_achievement.text = "?";
                  param2.tx_state.uri = null;
               }
               else
               {
                  if(param1.level > 0)
                  {
                     if(param1.level > ProtocolConstantsEnum.MAX_LEVEL)
                     {
                        param2.lbl_level.text = "" + (param1.level - ProtocolConstantsEnum.MAX_LEVEL);
                        param2.tx_level.uri = this._bgPrestigeUri;
                     }
                     else
                     {
                        param2.lbl_level.text = param1.level;
                        param2.tx_level.uri = this._bgLevelUri;
                     }
                  }
                  if(param1.realGuildName == "")
                  {
                     param2.lbl_guild.text = "";
                  }
                  else
                  {
                     param2.lbl_guild.text = this.chatApi.getGuildLink(param1,param1.guildName);
                  }
                  if(param1.guildBackEmblem && param1.guildBackEmblem.idEmblem != 0)
                  {
                     param2.tx_emblemBackGuild.uri = param1.guildBackEmblem.iconUri;
                     param2.tx_emblemUpGuild.uri = param1.guildUpEmblem.iconUri;
                     this.utilApi.changeColor(param2.tx_emblemBackGuild,param1.guildBackEmblem.color,1);
                     _loc5_ = this.dataApi.getEmblemSymbol(param1.guildUpEmblem.idEmblem);
                     if(_loc5_ && _loc5_.colorizable)
                     {
                        this.utilApi.changeColor(param2.tx_emblemUpGuild,param1.guildUpEmblem.color,0);
                     }
                     else
                     {
                        this.utilApi.changeColor(param2.tx_emblemUpGuild,param1.guildUpEmblem.color,0,true);
                     }
                  }
                  if(param1.achievementPoints == -1)
                  {
                     param2.lbl_achievement.text = "-";
                  }
                  else
                  {
                     param2.lbl_achievement.text = param1.achievementPoints;
                  }
                  if(param1.statusId)
                  {
                     switch(param1.statusId)
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
                  if(param1.moodSmileyId != 0)
                  {
                     _loc6_ = this.dataApi.getSmiley(param1.moodSmileyId);
                     if(_loc6_)
                     {
                        param2.tx_mood.uri = this.uiApi.createUri(this.uiApi.me().getConstant("smilies_uri") + _loc6_.gfxId);
                     }
                  }
                  if(param1.state == PlayerStateEnum.GAME_TYPE_FIGHT)
                  {
                     if(param1.moodSmileyId == 0)
                     {
                        param2.tx_state.uri = this.uiApi.createUri(this.uiApi.me().getConstant("assets") + "Social_tx_fightState");
                     }
                     else
                     {
                        param2.tx_state.uri = null;
                        param2.tx_fight.uri = this.uiApi.createUri(this.uiApi.me().getConstant("assets") + "Social_tx_fightState_small");
                     }
                  }
                  else
                  {
                     param2.tx_state.uri = null;
                  }
               }
            }
         }
         else
         {
            param2.lbl_name.text = "";
            param2.tx_level.uri = null;
            param2.lbl_level.text = "";
            param2.lbl_guild.text = "";
            param2.lbl_achievement.text = "";
            param2.tx_emblemBackGuild.uri = null;
            param2.tx_emblemUpGuild.uri = null;
            param2.tx_state.uri = null;
            param2.tx_fight.uri = null;
            param2.tx_mood.uri = null;
            param2.tx_head.uri = null;
            param2.btn_delete.visible = false;
            param2.tx_status.uri = null;
         }
      }
      
      private function displaySelectedTab(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               if(!this.btn_warnWhenFriendIsOnline.visible)
               {
                  this.btn_warnWhenFriendIsOnline.visible = true;
               }
               if(!this.btn_showOfflineFriends.visible)
               {
                  this.btn_showOfflineFriends.visible = true;
               }
               break;
            case 1:
               if(this.btn_warnWhenFriendIsOnline.visible)
               {
                  this.btn_warnWhenFriendIsOnline.visible = false;
               }
               if(!this.btn_showOfflineFriends.visible)
               {
                  this.btn_showOfflineFriends.visible = true;
               }
               break;
            case 2:
               if(this.btn_warnWhenFriendIsOnline.visible)
               {
                  this.btn_warnWhenFriendIsOnline.visible = false;
               }
               this.btn_showOfflineFriends.visible = false;
         }
         this.refreshGrid(param1);
      }
      
      private function refreshGrid(param1:int = -1) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         if(param1 == -1)
         {
            param1 = this._nCurrentTab;
         }
         if(param1 == this._nCurrentTab)
         {
            _loc2_ = new Object();
            switch(this._nCurrentTab)
            {
               case 0:
                  _loc2_ = this._friendsList;
                  break;
               case 1:
                  _loc2_ = this._enemiesList;
                  break;
               case 2:
                  _loc2_ = this._ignoredList;
            }
            if(!this._bShowOfflineGuys)
            {
               _loc3_ = new Array();
               for each(_loc4_ in _loc2_)
               {
                  if(_loc4_.online)
                  {
                     _loc3_.push(_loc4_);
                  }
               }
               this.gd_list.dataProvider = _loc3_;
            }
            else
            {
               this.gd_list.dataProvider = _loc2_;
            }
         }
      }
      
      private function onFriendsUpdated() : void
      {
         this._friendsList = this.socialApi.getFriendsList();
         this.refreshGrid(0);
      }
      
      private function onEnemiesUpdated() : void
      {
         this._enemiesList = this.socialApi.getEnemiesList();
         this.refreshGrid(1);
      }
      
      private function onFriendAdded(param1:Boolean) : void
      {
         this._friendsList = this.socialApi.getFriendsList();
         if(param1)
         {
            this.refreshGrid(0);
         }
      }
      
      private function onEnemyAdded(param1:Boolean) : void
      {
         this._enemiesList = this.socialApi.getEnemiesList();
         if(param1)
         {
            this.refreshGrid(1);
         }
      }
      
      private function onFriendRemoved(param1:Boolean) : void
      {
         this._friendsList = this.socialApi.getFriendsList();
         if(param1)
         {
            this.refreshGrid(0);
         }
      }
      
      private function onEnemyRemoved(param1:Boolean) : void
      {
         this._enemiesList = this.socialApi.getEnemiesList();
         if(param1)
         {
            this.refreshGrid(1);
         }
      }
      
      private function onFriendWarningState(param1:Boolean) : void
      {
         if(this.btn_warnWhenFriendIsOnline.selected != param1)
         {
            this.btn_warnWhenFriendIsOnline.selected = param1;
         }
      }
      
      private function onIgnoredAdded() : void
      {
         this._ignoredList = this.socialApi.getIgnoredList();
         this.refreshGrid(2);
      }
      
      private function onIgnoredRemoved() : void
      {
         this._ignoredList = this.socialApi.getIgnoredList();
         this.refreshGrid(2);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(this.inp_add.haveFocus && this.inp_add.text != "")
               {
                  switch(this._nCurrentTab)
                  {
                     case 0:
                        this.sysApi.sendAction(new AddFriend(this.inp_add.text));
                        break;
                     case 1:
                        this.sysApi.sendAction(new AddEnemy(this.inp_add.text));
                        break;
                     case 2:
                        this.sysApi.sendAction(new AddIgnored(this.inp_add.text));
                  }
                  this.inp_add.text = "";
                  return true;
               }
               break;
         }
         return false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         switch(param1)
         {
            case this.btn_add:
               switch(this._nCurrentTab)
               {
                  case 0:
                     if(this.inp_add.text)
                     {
                        this.sysApi.sendAction(new AddFriend(this.inp_add.text));
                     }
                     break;
                  case 1:
                     if(this.inp_add.text)
                     {
                        this.sysApi.sendAction(new AddEnemy(this.inp_add.text));
                     }
                     break;
                  case 2:
                     if(this.inp_add.text)
                     {
                        this.sysApi.sendAction(new AddIgnored(this.inp_add.text));
                     }
               }
               this.lbl_add.visible = true;
               this.inp_add.text = "";
               break;
            case this.btn_friend:
               if(this._nCurrentTab != 0)
               {
                  this._nCurrentTab = 0;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_enemy:
               if(this._nCurrentTab != 1)
               {
                  this._nCurrentTab = 1;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_ignored:
               if(this._nCurrentTab != 2)
               {
                  this._nCurrentTab = 2;
                  this.displaySelectedTab(this._nCurrentTab);
               }
               break;
            case this.btn_showOfflineFriends:
               this._bShowOfflineGuys = this.btn_showOfflineFriends.selected;
               this.refreshGrid(this._nCurrentTab);
               break;
            case this.btn_warnWhenFriendIsOnline:
               this.sysApi.sendAction(new FriendWarningSet(this.btn_warnWhenFriendIsOnline.selected));
               break;
            case this.btn_tabGuild:
               if(this._bDescendingSort)
               {
                  this.gd_list.sortOn("guildName",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_list.sortOn("guildName",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabName:
               if(this._bDescendingSort)
               {
                  this.gd_list.sortOn("name",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_list.sortOn("name",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabLevel:
               if(this._bDescendingSort)
               {
                  this.gd_list.sortOn("level",Array.NUMERIC);
               }
               else
               {
                  this.gd_list.sortOn("level",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabBreed:
               if(this._bDescendingSort)
               {
                  this.gd_list.sortOn("breed",Array.NUMERIC);
               }
               else
               {
                  this.gd_list.sortOn("breed",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabAchievement:
               if(this._bDescendingSort)
               {
                  this.gd_list.sortOn("achievementPoints",Array.NUMERIC);
               }
               else
               {
                  this.gd_list.sortOn("achievementPoints",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabState:
               if(this._bDescendingSort)
               {
                  this.gd_list.sortOn("state",Array.NUMERIC);
               }
               else
               {
                  this.gd_list.sortOn("state",Array.NUMERIC | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            default:
               if(param1.name.indexOf("btn_delete") != -1)
               {
                  _loc2_ = this._interactiveComponentsList[param1.name];
                  if(_loc2_.type == "Friend")
                  {
                     if(this._friendIdWaitingForKick == -1)
                     {
                        if(_loc2_.online)
                        {
                           _loc3_ = _loc2_.name + " ( " + _loc2_.playerName + " )";
                        }
                        else
                        {
                           _loc3_ = _loc2_.name;
                        }
                        this._friendIdWaitingForKick = _loc2_.accountId;
                        this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),[this.uiApi.getText("ui.social.doUDeleteFriend",_loc3_)],[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmDeleteFriend,this.onCancelDeleteFriend],this.onConfirmDeleteFriend,this.onCancelDeleteFriend);
                     }
                  }
                  else if(_loc2_.type == "Enemy")
                  {
                     if(this._enemyIdWaitingForKick == -1)
                     {
                        if(_loc2_.online)
                        {
                           _loc3_ = _loc2_.name + " ( " + _loc2_.playerName + " )";
                        }
                        else
                        {
                           _loc3_ = _loc2_.name;
                        }
                        this._enemyIdWaitingForKick = _loc2_.accountId;
                        this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),[this.uiApi.getText("ui.social.doUDeleteEnemy",_loc3_)],[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmDeleteEnemy,this.onCancelDeleteEnemy],this.onConfirmDeleteEnemy,this.onCancelDeleteEnemy);
                     }
                  }
                  else if(_loc2_.type == "Ignored")
                  {
                     this.sysApi.sendAction(new RemoveIgnored(_loc2_.accountId));
                  }
               }
               else if(param1.name.indexOf("tx_state") != -1 || param1.name.indexOf("tx_mood") != -1 || param1.name.indexOf("tx_fight") != -1)
               {
                  _loc2_ = this._interactiveComponentsList[param1.name];
                  if(_loc2_.state == PlayerStateEnum.GAME_TYPE_FIGHT)
                  {
                     this.sysApi.sendAction(new GameFightSpectatePlayerRequest(_loc2_.playerId));
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc3_:uint = 6;
         var _loc4_:uint = 2;
         if(param1.name.indexOf("btn_delete") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.charsel.characterDelete");
         }
         else if(param1.name.indexOf("tx_state") != -1 || param1.name.indexOf("tx_mood") != -1 || param1.name.indexOf("tx_fight") != -1)
         {
            _loc5_ = this._interactiveComponentsList[param1.name];
            if(_loc5_.state == PlayerStateEnum.GAME_TYPE_FIGHT)
            {
               _loc2_ = this.uiApi.getText("ui.spectator.clicToJoin");
            }
         }
         else if(param1.name.indexOf("lbl_name") != -1)
         {
            _loc5_ = this._interactiveComponentsList[param1.name];
            if(_loc5_ && !_loc5_.online)
            {
               if(_loc5_.lastConnection > 0)
               {
                  _loc6_ = Math.floor(_loc5_.lastConnection / 720);
                  _loc7_ = (_loc5_.lastConnection - _loc6_ * 720) / 24;
                  if(_loc6_ > 0)
                  {
                     if(_loc7_ > 0)
                     {
                        _loc8_ = this.uiApi.processText(this.uiApi.getText("ui.social.monthsAndDaysSinceLastConnection",_loc6_,_loc7_),"m",_loc7_ <= 1);
                     }
                     else
                     {
                        _loc8_ = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",_loc6_),"m",_loc6_ <= 1);
                     }
                  }
                  else if(_loc7_ > 0)
                  {
                     _loc8_ = this.uiApi.processText(this.uiApi.getText("ui.social.daysSinceLastConnection",_loc7_),"m",_loc7_ <= 1);
                  }
                  else
                  {
                     _loc8_ = this.uiApi.getText("ui.social.lessThanADay");
                  }
                  _loc2_ = this.uiApi.getText("ui.social.lastConnection",_loc8_);
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.social.unknownLastConnection");
               }
               _loc4_ = 0;
            }
         }
         else if(param1.name.indexOf("tx_status") != -1)
         {
            _loc9_ = this._interactiveComponentsList[param1.name];
            if(_loc9_ && _loc9_.online)
            {
               switch(_loc9_.statusId)
               {
                  case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.availiable");
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_AFK:
                     _loc2_ = this.uiApi.getText("ui.chat.status.away");
                     if(_loc9_.awayMessage != "")
                     {
                        _loc2_ = _loc2_ + (this.uiApi.getText("ui.common.colon") + _loc9_.awayMessage);
                     }
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.idle");
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
      
      public function onFocusChange(param1:Object) : void
      {
         if(param1 && param1 == this.inp_add)
         {
            this.lbl_add.visible = false;
         }
         else if(param1 != this.inp_add && this.inp_add.text == "")
         {
            this.lbl_add.visible = true;
         }
      }
      
      private function onConfirmDeleteFriend() : void
      {
         this.sysApi.sendAction(new RemoveFriend(this._friendIdWaitingForKick));
         this._friendIdWaitingForKick = -1;
      }
      
      private function onCancelDeleteFriend() : void
      {
         this._friendIdWaitingForKick = -1;
      }
      
      private function onConfirmDeleteEnemy() : void
      {
         this.sysApi.sendAction(new RemoveEnemy(this._enemyIdWaitingForKick));
         this._enemyIdWaitingForKick = -1;
      }
      
      private function onCancelDeleteEnemy() : void
      {
         this._enemyIdWaitingForKick = -1;
      }
   }
}
