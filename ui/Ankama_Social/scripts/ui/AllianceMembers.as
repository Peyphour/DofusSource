package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.AllianceChangeGuildRights;
   import d2actions.AllianceKickRequest;
   import d2actions.SetEnableAVARequest;
   import d2enums.AggressableStatusEnum;
   import d2enums.ComponentHookList;
   import d2hooks.AllianceUpdateInformations;
   import d2hooks.PvpAvaStateChange;
   import flash.utils.Dictionary;
   
   public class AllianceMembers
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var chatApi:ChatApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _guildsList:Array;
      
      private var _emblemsPath:String;
      
      private var _myGuild:GuildWrapper;
      
      private var _myAlliance:AllianceWrapper;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _compsLblName:Dictionary;
      
      private var _compsBtnLeader:Dictionary;
      
      private var _compsBtnKick:Dictionary;
      
      private var _compsTxEmblem:Dictionary;
      
      private var _guildIdWaitingForKick:int;
      
      private var _guildIdWaitingForLeader:int;
      
      private var _avaEnabled:Boolean = false;
      
      public var gd_guilds:Grid;
      
      public var btn_ava:ButtonContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var btn_tabMembers:ButtonContainer;
      
      public var lbl_members:Label;
      
      public function AllianceMembers()
      {
         this._compsLblName = new Dictionary(true);
         this._compsBtnLeader = new Dictionary(true);
         this._compsBtnKick = new Dictionary(true);
         this._compsTxEmblem = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         this.sysApi.addHook(AllianceUpdateInformations,this.onAllianceUpdateInformations);
         this.sysApi.addHook(PvpAvaStateChange,this.onPvpAvaStateChange);
         this.uiApi.addComponentHook(this.btn_ava,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_ava,ComponentHookList.ON_ROLL_OUT);
         this._emblemsPath = this.uiApi.me().getConstant("emblems_uri");
         this._myGuild = this.socialApi.getGuild();
         this._myAlliance = this.socialApi.getAlliance();
         this._avaEnabled = false;
         if(this.playerApi.getPlayedCharacterInfo().level >= 50)
         {
            _loc4_ = this.playerApi.characteristics().alignmentInfos;
            if(_loc4_.aggressable == AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE || _loc4_.aggressable == AggressableStatusEnum.AvA_ENABLED_NON_AGGRESSABLE || _loc4_.aggressable == AggressableStatusEnum.AvA_DISQUALIFIED || _loc4_.aggressable == AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE)
            {
               this._avaEnabled = true;
            }
         }
         else
         {
            this.btn_ava.softDisabled = true;
         }
         if(this._avaEnabled)
         {
            this.btn_ava.selected = true;
         }
         else
         {
            this.btn_ava.selected = false;
         }
         var _loc2_:Object = this.socialApi.getAllianceGuilds();
         this._guildsList = new Array();
         for each(_loc3_ in _loc2_)
         {
            this._guildsList.push(_loc3_);
         }
         this.gd_guilds.dataProvider = this._guildsList;
         this.lbl_members.text = this.uiApi.processText(this.uiApi.getText("ui.alliance.membersInGuilds",this._myAlliance.nbMembers,this._myAlliance.nbGuilds),"n",this._myAlliance.nbGuilds < 2);
      }
      
      public function unload() : void
      {
      }
      
      public function updateGuildLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:EmblemSymbol = null;
         if(!this._compsBtnKick[param2.btn_kick.name])
         {
            this.uiApi.addComponentHook(param2.btn_kick,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_kick,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_kick,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsBtnKick[param2.btn_kick.name] = param1;
         if(!this._compsBtnLeader[param2.btn_giveLeadership.name])
         {
            this.uiApi.addComponentHook(param2.btn_giveLeadership,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_giveLeadership,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_giveLeadership,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsBtnLeader[param2.btn_giveLeadership.name] = param1;
         if(!this._compsLblName[param2.lbl_guildName.name])
         {
            this.uiApi.addComponentHook(param2.lbl_guildName,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_guildName,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsLblName[param2.lbl_guildName.name] = param1;
         if(!this._compsLblName[param2.lbl_members.name])
         {
            this.uiApi.addComponentHook(param2.lbl_members,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_members,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsLblName[param2.lbl_members.name] = param1;
         if(!this._compsLblName[param2.tx_leader.name])
         {
            this.uiApi.addComponentHook(param2.tx_leader,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_leader,ComponentHookList.ON_ROLL_OUT);
         }
         this._compsLblName[param2.tx_leader.name] = true;
         this._compsTxEmblem[param2.tx_emblemBack.name] = param1;
         this._compsTxEmblem[param2.tx_emblemUp.name] = param1;
         if(param1 != null)
         {
            param2.lbl_guildName.text = this.chatApi.getGuildLink(param1,param1.guildName);
            param2.lbl_leaderName.text = this.uiApi.getText("ui.guild.leadBy","{player," + param1.leaderName + "," + param1.leaderId + "::" + param1.leaderName + "}");
            param2.lbl_lvl.text = param1.guildLevel;
            param2.lbl_perco.text = param1.nbTaxCollectors + " " + this.uiApi.getText("ui.social.guildTaxCollectors").toLowerCase();
            param2.lbl_members.text = this.uiApi.getText("ui.guild.onlineMembers",param1.nbConnectedMembers,param1.nbMembers);
            param2.tx_emblemBack.uri = param1.backEmblem.iconUri;
            param2.tx_emblemUp.uri = param1.upEmblem.iconUri;
            this.utilApi.changeColor(param2.tx_emblemBack,param1.backEmblem.color,1);
            _loc4_ = this.dataApi.getEmblemSymbol(param1.upEmblem.idEmblem);
            if(_loc4_.colorizable)
            {
               this.utilApi.changeColor(param2.tx_emblemUp,param1.upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(param2.tx_emblemUp,param1.upEmblem.color,0,true);
            }
            if(param1.allianceLeader)
            {
               param2.tx_leader.visible = true;
            }
            else
            {
               param2.tx_leader.visible = false;
            }
            if(this._myGuild.guildId == this._myAlliance.leaderGuildId && this.socialApi.hasGuildRight(this.playerApi.id(),"isBoss"))
            {
               param2.btn_kick.visible = true;
               if(this._myGuild.guildId == param1.guildId)
               {
                  param2.btn_giveLeadership.visible = false;
               }
               else
               {
                  param2.btn_giveLeadership.visible = true;
               }
            }
            else
            {
               param2.btn_giveLeadership.visible = false;
               if(this._myGuild.guildId == param1.guildId && this.socialApi.hasGuildRight(this.playerApi.id(),"isBoss"))
               {
                  param2.btn_kick.visible = true;
               }
               else
               {
                  param2.btn_kick.visible = false;
               }
            }
         }
         else
         {
            param2.lbl_guildName.text = "";
            param2.lbl_leaderName.text = "";
            param2.lbl_lvl.text = "";
            param2.lbl_perco.text = "";
            param2.lbl_members.text = "";
            param2.tx_emblemBack.uri = null;
            param2.tx_emblemUp.uri = null;
            param2.tx_leader.visible = false;
            param2.btn_giveLeadership.visible = false;
            param2.btn_kick.visible = false;
         }
      }
      
      private function popupDeleteGuild(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.guildId == this._myAlliance.leaderGuildId && this._guildsList.length > 1)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.alliance.guildLeaderCantBeBanned"),[this.uiApi.getText("ui.common.ok")]);
         }
         else
         {
            if(this._myGuild.guildId == param1.guildId)
            {
               _loc2_ = this.uiApi.getText("ui.alliance.quitConfirm");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.alliance.kickConfirm",param1.guildName);
            }
            this._guildIdWaitingForKick = param1.guildId;
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc2_,[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmDeleteGuild,this.onCancelDeleteGuild],this.onConfirmDeleteGuild,this.onCancelDeleteGuild);
         }
      }
      
      private function onConfirmDeleteGuild() : void
      {
         this.sysApi.sendAction(new AllianceKickRequest(this._guildIdWaitingForKick));
         this._guildIdWaitingForKick = 0;
      }
      
      private function onCancelDeleteGuild() : void
      {
         this._guildIdWaitingForKick = 0;
      }
      
      private function popupLeaderGuild(param1:Object) : void
      {
         var _loc2_:String = this.uiApi.getText("ui.alliance.giveLeadershipConfirm",param1.guildName);
         this._guildIdWaitingForLeader = param1.guildId;
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc2_,[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmLeaderGuild,this.onCancelLeaderGuild],this.onConfirmLeaderGuild,this.onCancelLeaderGuild);
      }
      
      private function onConfirmLeaderGuild() : void
      {
         this.sysApi.sendAction(new AllianceChangeGuildRights(this._guildIdWaitingForLeader,1));
         this._guildIdWaitingForLeader = 0;
      }
      
      private function onCancelLeaderGuild() : void
      {
         this._guildIdWaitingForLeader = 0;
      }
      
      private function onAllianceUpdateInformations() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.socialApi.getAllianceGuilds();
         this._guildsList = new Array();
         for each(_loc2_ in _loc1_)
         {
            this._guildsList.push(_loc2_);
         }
         this.gd_guilds.dataProvider = this._guildsList;
      }
      
      private function onPvpAvaStateChange(param1:int, param2:uint) : void
      {
         if(param1 == AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE || param1 == AggressableStatusEnum.AvA_ENABLED_NON_AGGRESSABLE || param1 == AggressableStatusEnum.AvA_DISQUALIFIED || param1 == AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE)
         {
            this._avaEnabled = true;
            this.btn_ava.selected = true;
         }
         else
         {
            this._avaEnabled = false;
            this.btn_ava.selected = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == this.btn_ava && this.btn_ava.softDisabled == false)
         {
            this.sysApi.sendAction(new SetEnableAVARequest(!this._avaEnabled));
         }
         if(param1 == this.btn_tabName)
         {
            if(this._bDescendingSort)
            {
               this.gd_guilds.sortOn("guildName",Array.CASEINSENSITIVE);
            }
            else
            {
               this.gd_guilds.sortOn("guildName",Array.CASEINSENSITIVE | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabLevel)
         {
            if(this._bDescendingSort)
            {
               this.gd_guilds.sortOn("guildLevel",Array.NUMERIC);
            }
            else
            {
               this.gd_guilds.sortOn("guildLevel",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1 == this.btn_tabMembers)
         {
            if(this._bDescendingSort)
            {
               this.gd_guilds.sortOn("nbConnectedMembers",Array.NUMERIC);
            }
            else
            {
               this.gd_guilds.sortOn("nbConnectedMembers",Array.NUMERIC | Array.DESCENDING);
            }
            this._bDescendingSort = !this._bDescendingSort;
         }
         else if(param1.name.indexOf("btn_giveLeadership") != -1)
         {
            _loc2_ = this._compsBtnLeader[param1.name];
            this.popupLeaderGuild(_loc2_);
         }
         else if(param1.name.indexOf("btn_kick") != -1)
         {
            _loc3_ = this._compsBtnKick[param1.name];
            this.popupDeleteGuild(_loc3_);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc3_:uint = 6;
         var _loc4_:uint = 0;
         if(param1.name.indexOf("btn_giveLeadership") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.alliance.giveLeadership");
         }
         else if(param1.name.indexOf("btn_kick") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.alliance.kickGuild");
         }
         else if(param1.name.indexOf("btn_ava") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.alliance.enableAvATooltip");
            if(this.playerApi.getPlayedCharacterInfo().level < 50)
            {
               _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.spell.requiredLevel") + " 50");
            }
         }
         else if(param1.name.indexOf("tx_leader") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.guild.right.leader");
         }
         else if(param1.name.indexOf("lbl_members") != -1)
         {
            _loc5_ = this._compsLblName[param1.name];
            if(!_loc5_)
            {
               return;
            }
            this.sysApi.log(2,"guild " + _loc5_.guildName + "    hoursSinceLastConnection " + _loc5_.hoursSinceLastConnection);
            if(_loc5_.nbConnectedMembers == 0 && _loc5_.hoursSinceLastConnection > 0)
            {
               _loc6_ = Math.floor(_loc5_.hoursSinceLastConnection / 720);
               _loc7_ = (_loc5_.hoursSinceLastConnection - _loc6_ * 720) / 24;
               _loc8_ = _loc5_.hoursSinceLastConnection - _loc7_ * 24 - _loc6_ * 720;
               if(_loc6_ > 0)
               {
                  if(_loc7_ > 0)
                  {
                     _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.social.monthsAndDaysSinceLastConnection",_loc6_,_loc7_),"m",_loc7_ <= 1);
                  }
                  else
                  {
                     _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",_loc6_),"m",_loc6_ <= 1);
                  }
               }
               else if(_loc7_ > 0)
               {
                  _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.social.daysSinceLastConnection",_loc7_),"m",_loc7_ <= 1);
               }
               else
               {
                  _loc9_ = this.uiApi.getText("ui.social.lessThanADay");
               }
               _loc2_ = this.uiApi.getText("ui.social.lastConnection",_loc9_);
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
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         if(param1.name.indexOf("tx_emblemBack") != -1)
         {
            this.utilApi.changeColor(param1.getChildByName("back"),this._compsTxEmblem[param1.name].backEmblem.color,1);
         }
         else if(param1.name.indexOf("tx_emblemUp") != -1)
         {
            _loc2_ = this.dataApi.getEmblemSymbol(this._compsTxEmblem[param1.name].upEmblem.idEmblem);
            if(_loc2_.colorizable)
            {
               this.utilApi.changeColor(param1.getChildByName("up"),this._compsTxEmblem[param1.name].upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(param1.getChildByName("up"),this._compsTxEmblem[param1.name].upEmblem.color,0,true);
            }
         }
      }
   }
}
