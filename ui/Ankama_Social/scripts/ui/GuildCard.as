package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.AllianceInvitation;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.OpenOneGuild;
   
   public class GuildCard
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var socialApi:SocialApi;
      
      public var timeApi:TimeApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var chatApi:ChatApi;
      
      private var _data:Object;
      
      private var _myGuild:GuildWrapper;
      
      private var _bgLevelUri:Object;
      
      private var _bgPrestigeUri:Object;
      
      public var lbl_title:Label;
      
      public var lbl_alliance:Label;
      
      public var lbl_level:Label;
      
      public var lbl_creationDate:Label;
      
      public var lbl_leader:Label;
      
      public var lbl_taxcollectors:Label;
      
      public var lbl_members:Label;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var tx_disabled:Texture;
      
      public var gd_members:Grid;
      
      public var btn_inviteInAlliance:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public function GuildCard()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(OpenOneGuild,this.onOpenOneGuild);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_inviteInAlliance,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_inviteInAlliance,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_inviteInAlliance,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_disabled,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_disabled,ComponentHookList.ON_ROLL_OUT);
         this.tx_emblemBack.dispatchMessages = true;
         this.tx_emblemUp.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_emblemBack,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_emblemUp,ComponentHookList.ON_TEXTURE_READY);
         this._bgLevelUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgLevel_uri"));
         this._bgPrestigeUri = this.uiApi.createUri(this.uiApi.me().getConstant("bgPrestige_uri"));
         this._data = rest[0].guild;
         this._myGuild = this.socialApi.getGuild();
         this.updateInformations();
      }
      
      public function unload() : void
      {
      }
      
      public function updateMemberLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1 != null)
         {
            param2.lbl_memberName.text = "{player," + param1.name + "," + param1.id + "::" + param1.name + "}";
            if(param1.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               param2.lbl_memberLvl.text = "" + (param1.level - ProtocolConstantsEnum.MAX_LEVEL);
               param2.tx_memberLvl.uri = this._bgPrestigeUri;
            }
            else
            {
               param2.lbl_memberLvl.text = param1.level;
               param2.tx_memberLvl.uri = this._bgLevelUri;
            }
         }
         else
         {
            param2.lbl_memberName.text = "";
            param2.lbl_memberLvl.text = "";
            param2.tx_memberLvl.uri = null;
         }
      }
      
      private function updateInformations() : void
      {
         var _loc1_:AllianceWrapper = null;
         var _loc2_:GuildFactSheetWrapper = null;
         this.lbl_title.text = this._data.guildName;
         this.btn_inviteInAlliance.visible = false;
         if(this._data.allianceId)
         {
            this.lbl_alliance.text = this.uiApi.getText("ui.common.alliance") + this.uiApi.getText("ui.common.colon") + this.chatApi.getAllianceLink(this._data,this._data.allianceName);
         }
         else
         {
            this.lbl_alliance.text = this.uiApi.getText("ui.alliance.noAllianceForThisGuild");
            if(this.socialApi.hasAlliance())
            {
               _loc1_ = this.socialApi.getAlliance();
               if(_loc1_ && _loc1_.guilds && _loc1_.guilds.length > 0)
               {
                  _loc2_ = _loc1_.guilds[0];
                  if(this._myGuild.guildId == _loc2_.guildId && this.socialApi.hasGuildRight(this.playerApi.id(),"isBoss"))
                  {
                     this.btn_inviteInAlliance.visible = true;
                  }
               }
            }
         }
         this.lbl_level.text = this._data.guildLevel;
         this.lbl_creationDate.text = this.timeApi.getDofusDate(this._data.creationDate * 1000);
         this.lbl_leader.text = "{player," + this._data.leaderName + "," + this._data.leaderId + "::" + this._data.leaderName + "}";
         this.lbl_members.text = this._data.nbMembers;
         this.lbl_taxcollectors.text = this.uiApi.processText(this.uiApi.getText("ui.guild.taxcollectorsCurrentlyCollecting",this._data.nbTaxCollectors),"n",this._data.nbTaxCollectors < 2);
         this.tx_emblemBack.uri = this._data.backEmblem.fullSizeIconUri;
         this.tx_emblemUp.uri = this._data.upEmblem.fullSizeIconUri;
         if(this._data.members && this._data.members.length)
         {
            this.gd_members.dataProvider = this._data.members;
         }
         else
         {
            this.gd_members.dataProvider = new Array();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_inviteInAlliance:
               this.sysApi.sendAction(new AllianceInvitation(this._data.leaderId));
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_inviteInAlliance:
               _loc2_ = this.uiApi.getText("ui.alliance.inviteLeader",this._data.leaderName);
               break;
            case this.tx_disabled:
               _loc2_ = this.uiApi.getText("ui.guild.disabled");
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
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         if(param1.name.indexOf("tx_emblemBack") != -1)
         {
            this.utilApi.changeColor(param1.getChildByName("back"),this._data.backEmblem.color,1);
         }
         else if(param1.name.indexOf("tx_emblemUp") != -1)
         {
            _loc2_ = this.dataApi.getEmblemSymbol(this._data.upEmblem.idEmblem);
            if(_loc2_.colorizable)
            {
               this.utilApi.changeColor(param1.getChildByName("up"),this._data.upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(param1.getChildByName("up"),this._data.upEmblem.color,0,true);
            }
         }
      }
      
      private function onOpenOneGuild(param1:Object) : void
      {
         this._data = param1;
         this.updateInformations();
      }
   }
}
