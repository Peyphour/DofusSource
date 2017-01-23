package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.GuildGetInformations;
   import d2actions.GuildMotdSetRequest;
   import d2enums.ComponentHookList;
   import d2enums.GuildInformationsTypeEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.GuildBulletin;
   import d2hooks.GuildInformationsGeneral;
   import d2hooks.GuildMotd;
   import d2hooks.OpenDareSearch;
   import flash.text.TextFieldAutoSize;
   
   public class Guild
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      private var _nCurrentTab:int = -1;
      
      private var _guild:GuildWrapper;
      
      private var guildInformationsAsked:Boolean = false;
      
      private var _expLevelFloor:Number = 0;
      
      private var _experience:Number = 0;
      
      private var _expNextLevelFloor:Number = 0;
      
      private var _level:uint = 0;
      
      private var _totalDares:uint = 0;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_name:Label;
      
      public var lbl_guildLevel:Label;
      
      public var pb_experience:ProgressBar;
      
      public var btn_availableDares:ButtonContainer;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var tx_paddockWarning:Texture;
      
      public var tx_bulletinWarning:Texture;
      
      public var ctr_motd:GraphicContainer;
      
      public var lbl_motd:Label;
      
      public var btn_motdEdit:ButtonContainer;
      
      public var ctr_editMotd:GraphicContainer;
      
      public var inp_motd:Input;
      
      public var btn_motdValid:ButtonContainer;
      
      public var btn_motdExit:ButtonContainer;
      
      public var btn_members:ButtonContainer;
      
      public var btn_bulletin:ButtonContainer;
      
      public var btn_customization:ButtonContainer;
      
      public var btn_taxCollector:ButtonContainer;
      
      public var btn_paddock:ButtonContainer;
      
      public var btn_houses:ButtonContainer;
      
      public function Guild()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.btn_members.soundId = SoundEnum.TAB;
         this.btn_bulletin.soundId = SoundEnum.TAB;
         this.btn_customization.soundId = SoundEnum.TAB;
         this.btn_taxCollector.soundId = SoundEnum.TAB;
         this.btn_paddock.soundId = SoundEnum.TAB;
         this.btn_houses.soundId = SoundEnum.TAB;
         this.sysApi.addHook(GuildInformationsGeneral,this.onGuildInformationsGeneral);
         this.sysApi.addHook(GuildMotd,this.onGuildMotd);
         this.sysApi.addHook(GuildBulletin,this.onGuildBulletin);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this._guild = this.socialApi.getGuild();
         this.lbl_name.text = this._guild.guildName;
         this.lbl_motd.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.lbl_motd.text = this._guild.formattedMotd;
         var _loc2_:Number = this.lbl_motd.textfield.height;
         this.lbl_motd.textfield.autoSize = TextFieldAutoSize.NONE;
         if(this.lbl_motd.textfield.numLines == 1)
         {
            this.lbl_motd.textfield.height = _loc2_ + 2;
         }
         else
         {
            this.lbl_motd.resizeText();
         }
         this.inp_motd.text = this._guild.motd;
         if(this._guild.lastNotifiedTimestamp > this.sysApi.getData("guildBulletinLastVisitTimestamp"))
         {
            this.tx_bulletinWarning.visible = true;
         }
         else
         {
            this.tx_bulletinWarning.visible = false;
         }
         this._totalDares = this.socialApi.getTotalGuildDares();
         this.btn_availableDares.visible = this._totalDares > 0;
         this.tx_emblemBack.dispatchMessages = true;
         this.tx_emblemUp.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_emblemBack,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_emblemUp,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.btn_members,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_bulletin,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_customization,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_taxCollector,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_paddock,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_houses,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.pb_experience,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.pb_experience,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_guildLevel,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_guildLevel,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_motd,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_motd,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_motdEdit,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_motdEdit,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_motdValid,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_motdValid,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_motdExit,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_motdExit,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_availableDares,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_availableDares,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_bulletinWarning,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_bulletinWarning,ComponentHookList.ON_ROLL_OUT);
         this.inp_motd.html = false;
         this.inp_motd.maxChars = ProtocolConstantsEnum.USER_MAX_MOTD_LEN;
         this.tx_emblemBack.uri = this._guild.backEmblem.fullSizeIconUri;
         this.tx_emblemUp.uri = this._guild.upEmblem.fullSizeIconUri;
         this.openSelectedTab(rest[0][0]);
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
         this.uiApi.unloadUi("subGuildUi");
      }
      
      private function openSelectedTab(param1:uint) : void
      {
         if(!this.guildInformationsAsked)
         {
            this.guildInformationsAsked = true;
            this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_GENERAL));
         }
         if(this._nCurrentTab == param1)
         {
            return;
         }
         switch(param1)
         {
            case 2:
               this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_TAX_COLLECTOR_GUILD_ONLY));
               break;
            case 4:
               this.sysApi.sendAction(new GuildGetInformations(GuildInformationsTypeEnum.INFO_HOUSES));
         }
         this.uiApi.unloadUi("subGuildUi");
         this.uiApi.loadUiInside(this.getUiNameByTab(param1),this.mainCtr,"subGuildUi",null);
         this.getButtonByTab(param1).selected = true;
         this._nCurrentTab = param1;
      }
      
      private function getUiNameByTab(param1:uint) : String
      {
         if(param1 == 0)
         {
            return "guildMembers";
         }
         if(param1 == 1)
         {
            return "guildPersonalization";
         }
         if(param1 == 2)
         {
            return "guildTaxCollector";
         }
         if(param1 == 3)
         {
            return "guildPaddock";
         }
         if(param1 == 4)
         {
            return "guildHouses";
         }
         if(param1 == 5)
         {
            return "socialBulletin";
         }
         return null;
      }
      
      private function getButtonByTab(param1:uint) : Object
      {
         if(param1 == 0)
         {
            return this.btn_members;
         }
         if(param1 == 1)
         {
            return this.btn_customization;
         }
         if(param1 == 2)
         {
            return this.btn_taxCollector;
         }
         if(param1 == 3)
         {
            return this.btn_paddock;
         }
         if(param1 == 4)
         {
            return this.btn_houses;
         }
         if(param1 == 5)
         {
            return this.btn_bulletin;
         }
         return null;
      }
      
      private function switchMotdEditMode(param1:Boolean) : void
      {
         if(param1)
         {
            this.inp_motd.text = this._guild.motd;
            this.inp_motd.focus();
            this.inp_motd.setSelection(8388607,8388607);
            this.ctr_editMotd.visible = true;
            this.ctr_motd.visible = false;
         }
         else
         {
            this.ctr_editMotd.visible = false;
            this.ctr_motd.visible = true;
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         switch(param1)
         {
            case this.tx_emblemBack:
               this.utilApi.changeColor(this.tx_emblemBack.getChildByName("back"),this._guild.backEmblem.color,1);
               break;
            case this.tx_emblemUp:
               _loc2_ = this.dataApi.getEmblemSymbol(this._guild.upEmblem.idEmblem);
               if(_loc2_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._guild.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._guild.upEmblem.color,0,true);
               }
         }
      }
      
      private function onGuildInformationsGeneral(param1:Number, param2:Number, param3:Number, param4:uint, param5:uint, param6:Boolean, param7:int, param8:int) : void
      {
         this._expLevelFloor = param1;
         this._experience = param2;
         this._expNextLevelFloor = param3;
         this._level = param4;
         this.lbl_guildLevel.text = this.uiApi.getText("ui.common.short.level") + " " + param4.toString();
         if(this._level < ProtocolConstantsEnum.MAX_GUILD_LEVEL)
         {
            this.pb_experience.value = (param2 - param1) / (param3 - param1);
         }
         else
         {
            this.pb_experience.value = 1;
         }
         if(param6)
         {
            this.tx_paddockWarning.visible = true;
         }
         else
         {
            this.tx_paddockWarning.visible = false;
         }
      }
      
      private function onGuildMotd() : void
      {
         this._guild = this.socialApi.getGuild();
         this.lbl_motd.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.lbl_motd.text = this._guild.formattedMotd;
         var _loc1_:Number = this.lbl_motd.textfield.height;
         this.lbl_motd.textfield.autoSize = TextFieldAutoSize.NONE;
         if(this.lbl_motd.textfield.numLines == 1)
         {
            this.lbl_motd.textfield.height = _loc1_ + 2;
         }
         else
         {
            this.lbl_motd.resizeText();
         }
         this.inp_motd.text = this._guild.motd;
      }
      
      private function onGuildBulletin() : void
      {
         if(this._nCurrentTab == 5)
         {
            return;
         }
         this._guild = this.socialApi.getGuild();
         if(this._guild.lastNotifiedTimestamp > this.sysApi.getData("guildBulletinLastVisitTimestamp"))
         {
            this.tx_bulletinWarning.visible = true;
         }
         else
         {
            this.tx_bulletinWarning.visible = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.btn_members)
         {
            this.openSelectedTab(0);
         }
         else if(param1 == this.btn_bulletin)
         {
            this.tx_bulletinWarning.visible = false;
            this.openSelectedTab(5);
         }
         else if(param1 == this.btn_customization)
         {
            this.openSelectedTab(1);
         }
         else if(param1 == this.btn_taxCollector)
         {
            this.openSelectedTab(2);
         }
         else if(param1 == this.btn_paddock)
         {
            this.tx_paddockWarning.visible = false;
            this.openSelectedTab(3);
         }
         else if(param1 == this.btn_houses)
         {
            this.openSelectedTab(4);
         }
         else if(param1 == this.btn_motdEdit)
         {
            this.switchMotdEditMode(true);
         }
         else if(param1 == this.btn_motdExit)
         {
            this.switchMotdEditMode(false);
         }
         else if(param1 == this.btn_motdValid)
         {
            if(this.inp_motd.text != this._guild.motd)
            {
               _loc2_ = this.inp_motd.text;
               this.sysApi.sendAction(new GuildMotdSetRequest(_loc2_));
            }
            this.switchMotdEditMode(false);
         }
         else if(param1 == this.btn_availableDares)
         {
            this.sysApi.dispatchHook(OpenDareSearch,this._guild.guildName,"searchFilterGuild");
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc5_:Number = NaN;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.pb_experience:
               _loc2_ = this.utilApi.kamasToString(this._experience,"") + " / " + this.utilApi.kamasToString(this._expNextLevelFloor,"");
               break;
            case this.lbl_guildLevel:
               _loc2_ = this.uiApi.getText("ui.common.creationDate") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDate(this._guild.creationDate * 1000) + " " + this.timeApi.getClock(this._guild.creationDate * 1000);
               break;
            case this.btn_motdEdit:
               _loc2_ = this.uiApi.getText("ui.motd.edit");
               break;
            case this.btn_motdValid:
               _loc2_ = this.uiApi.getText("ui.common.validation");
               break;
            case this.btn_motdExit:
               _loc2_ = this.uiApi.getText("ui.common.cancel");
               break;
            case this.tx_bulletinWarning:
               _loc2_ = this.uiApi.getText("ui.motd.bulletinUpdated");
               break;
            case this.lbl_motd:
               _loc2_ = "";
               if(this.lbl_motd.hasTooltipExtension)
               {
                  _loc2_ = _loc2_ + this.lbl_motd.text;
               }
               if(this._guild.motdWriterName != "")
               {
                  if(_loc2_ != "")
                  {
                     _loc2_ = _loc2_ + "\n";
                  }
                  _loc5_ = this._guild.motdTimestamp * 1000;
                  _loc2_ = _loc2_ + this.uiApi.getText("ui.motd.lastModification",this.timeApi.getDate(_loc5_,true) + " " + this.timeApi.getClock(_loc5_,true,true),this._guild.motdWriterName);
               }
               break;
            case this.btn_availableDares:
               _loc2_ = this.uiApi.processText(this.uiApi.getText("ui.social.dare.totalAvailable",this._totalDares),"",this._totalDares == 1);
               break;
            case this.tx_paddockWarning:
               _loc2_ = this.uiApi.getText("ui.mount.paddocksAbandonned");
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
         var _loc2_:String = null;
         switch(param1)
         {
            case "validUi":
               if(this.inp_motd.visible && this.inp_motd.haveFocus)
               {
                  if(this.inp_motd.text != this._guild.motd)
                  {
                     _loc2_ = this.inp_motd.text;
                     this.sysApi.sendAction(new GuildMotdSetRequest(_loc2_));
                  }
                  this.switchMotdEditMode(false);
                  return true;
               }
               return false;
            case "closeUi":
               if(this.inp_motd.visible && this.inp_motd.haveFocus)
               {
                  this.switchMotdEditMode(false);
                  return true;
               }
               this.uiApi.unloadUi("socialBase");
               return true;
            default:
               return false;
         }
      }
   }
}
