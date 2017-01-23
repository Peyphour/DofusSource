package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.AllianceMotdSetRequest;
   import d2actions.PrismsListRegister;
   import d2enums.ComponentHookList;
   import d2enums.PrismListenEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.AllianceBulletin;
   import d2hooks.AllianceMotd;
   import d2hooks.AllianceUpdateInformations;
   import d2hooks.OpenDareSearch;
   import flash.text.TextFieldAutoSize;
   
   public class Alliance
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var chatApi:ChatApi;
      
      private var _nCurrentTab:int = -1;
      
      private var _alliance:Object;
      
      private var _totalDares:uint = 0;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_name:Label;
      
      public var btn_availableDares:ButtonContainer;
      
      public var lbl_tag:Label;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var tx_bulletinWarning:Texture;
      
      public var btn_members:ButtonContainer;
      
      public var btn_bulletin:ButtonContainer;
      
      public var btn_areas:ButtonContainer;
      
      public var btn_fights:ButtonContainer;
      
      public var ctr_motd:GraphicContainer;
      
      public var lbl_motd:Label;
      
      public var btn_motdEdit:ButtonContainer;
      
      public var ctr_editMotd:GraphicContainer;
      
      public var inp_motd:Input;
      
      public var btn_motdValid:ButtonContainer;
      
      public var btn_motdExit:ButtonContainer;
      
      public function Alliance()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.btn_members.soundId = SoundEnum.TAB;
         this.btn_bulletin.soundId = SoundEnum.TAB;
         this.btn_areas.soundId = SoundEnum.TAB;
         this.btn_fights.soundId = SoundEnum.TAB;
         this.sysApi.addHook(AllianceUpdateInformations,this.onAllianceUpdateInformations);
         this.sysApi.addHook(AllianceMotd,this.onAllianceMotd);
         this.sysApi.addHook(AllianceBulletin,this.onAllianceBulletin);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut);
         this.uiApi.addComponentHook(this.btn_members,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_bulletin,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_areas,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_fights,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.lbl_name,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_name,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_emblemBack,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_emblemUp,ComponentHookList.ON_TEXTURE_READY);
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
         this.tx_emblemBack.dispatchMessages = true;
         this.tx_emblemUp.dispatchMessages = true;
         this.sysApi.sendAction(new PrismsListRegister("Alliance",PrismListenEnum.PRISM_LISTEN_MINE));
         this._alliance = this.socialApi.getAlliance();
         this.updateAllianceInfos();
         if(this.socialApi.hasGuildRight(this.playerApi.id(),"isBoss"))
         {
            this.btn_motdEdit.visible = true;
         }
         else
         {
            this.btn_motdEdit.visible = false;
         }
         this.lbl_motd.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.lbl_motd.text = this._alliance.formattedMotd;
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
         this.inp_motd.text = this._alliance.motd;
         if(this._alliance.lastNotifiedTimestamp > this.sysApi.getData("allianceBulletinLastVisitTimestamp"))
         {
            this.tx_bulletinWarning.visible = true;
         }
         else
         {
            this.tx_bulletinWarning.visible = false;
         }
         this._totalDares = this.socialApi.getTotalAllianceDares();
         this.btn_availableDares.visible = this._totalDares > 0;
         this.openSelectedTab(rest[0][0],rest[0][1]);
      }
      
      public function unload() : void
      {
         this.sysApi.sendAction(new PrismsListRegister("Alliance",PrismListenEnum.PRISM_LISTEN_NONE));
         this.uiApi.unloadUi("subAllianceUi");
      }
      
      private function updateAllianceInfos() : void
      {
         this.lbl_name.text = this._alliance.allianceName;
         this.lbl_tag.text = this.chatApi.getAllianceLink(this._alliance,"[" + this._alliance.allianceTag + "]");
         this.tx_emblemBack.uri = this._alliance.backEmblem.fullSizeIconUri;
         this.tx_emblemUp.uri = this._alliance.upEmblem.fullSizeIconUri;
      }
      
      private function openSelectedTab(param1:uint, param2:Object = null) : void
      {
         if(this._nCurrentTab == param1)
         {
            return;
         }
         this.uiApi.unloadUi("subAllianceUi");
         this.uiApi.loadUiInside(this.getUiNameByTab(param1),this.mainCtr,"subAllianceUi",param2);
         this.getButtonByTab(param1).selected = true;
         this._nCurrentTab = param1;
      }
      
      private function getUiNameByTab(param1:uint) : String
      {
         if(param1 == 0)
         {
            return "allianceMembers";
         }
         if(param1 == 1)
         {
            return "allianceAreas";
         }
         if(param1 == 2)
         {
            return "allianceFights";
         }
         if(param1 == 3)
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
            return this.btn_areas;
         }
         if(param1 == 2)
         {
            return this.btn_fights;
         }
         if(param1 == 3)
         {
            return this.btn_bulletin;
         }
         return null;
      }
      
      private function switchMotdEditMode(param1:Boolean) : void
      {
         if(param1)
         {
            this.inp_motd.text = this._alliance.motd;
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
               this.utilApi.changeColor(this.tx_emblemBack.getChildByName("back"),this._alliance.backEmblem.color,1);
               break;
            case this.tx_emblemUp:
               _loc2_ = this.dataApi.getEmblemSymbol(this._alliance.upEmblem.idEmblem);
               if(_loc2_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._alliance.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._alliance.upEmblem.color,0,true);
               }
         }
      }
      
      private function onAllianceUpdateInformations() : void
      {
         this._alliance = this.socialApi.getAlliance();
         this.updateAllianceInfos();
      }
      
      private function onAllianceMotd() : void
      {
         this._alliance = this.socialApi.getAlliance();
         this.lbl_motd.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.lbl_motd.text = this._alliance.formattedMotd;
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
         this.inp_motd.text = this._alliance.motd;
      }
      
      private function onAllianceBulletin() : void
      {
         if(this._nCurrentTab == 3)
         {
            return;
         }
         this._alliance = this.socialApi.getAlliance();
         if(this._alliance.lastNotifiedTimestamp > this.sysApi.getData("allianceBulletinLastVisitTimestamp"))
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
         if(param1 == this.btn_members)
         {
            this.openSelectedTab(0);
         }
         else if(param1 == this.btn_bulletin)
         {
            this.tx_bulletinWarning.visible = false;
            this.openSelectedTab(3);
         }
         else if(param1 == this.btn_areas)
         {
            this.openSelectedTab(1);
         }
         else if(param1 == this.btn_fights)
         {
            this.openSelectedTab(2);
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
            if(this.inp_motd.text != this._alliance.motd)
            {
               this.sysApi.sendAction(new AllianceMotdSetRequest(this.inp_motd.text));
            }
            this.switchMotdEditMode(false);
         }
         else if(param1 == this.btn_availableDares)
         {
            this.sysApi.dispatchHook(OpenDareSearch,this._alliance.allianceName,"searchFilterAlliance");
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
            case this.lbl_name:
               _loc2_ = this.uiApi.getText("ui.common.creationDate") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDate(this._alliance.creationDate * 1000) + " " + this.timeApi.getClock(this._alliance.creationDate * 1000);
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
               if(this._alliance.motdWriterName != "")
               {
                  if(_loc2_ != "")
                  {
                     _loc2_ = _loc2_ + "\n";
                  }
                  _loc5_ = this._alliance.motdTimestamp * 1000;
                  _loc2_ = _loc2_ + this.uiApi.getText("ui.motd.lastModification",this.timeApi.getDate(_loc5_,true) + " " + this.timeApi.getClock(_loc5_,true,true),this._alliance.motdWriterName);
               }
               break;
            case this.btn_availableDares:
               _loc2_ = this.uiApi.processText(this.uiApi.getText("ui.social.dare.totalAvailable",this._totalDares),"",this._totalDares == 1);
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
            case "validUi":
               if(this.inp_motd.visible && this.inp_motd.haveFocus)
               {
                  if(this.inp_motd.text != this._alliance.motd)
                  {
                     this.sysApi.sendAction(new AllianceMotdSetRequest(this.inp_motd.text));
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
