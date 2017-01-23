package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.HouseGuildRightsView;
   import d2actions.HouseGuildShare;
   import d2hooks.HouseGuildNone;
   import d2hooks.HouseGuildRights;
   
   public class HouseGuildManager
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var socialApi:SocialApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _myGuild:GuildWrapper;
      
      private var _guildEmblem:Object;
      
      private var _guildName:String;
      
      public var btnClose:ButtonContainer;
      
      public var btnValidate:ButtonContainer;
      
      public var lblGuildHouseNotice:TextArea;
      
      public var lbl_title:Label;
      
      public var cbGuildHouseEnabled:ButtonContainer;
      
      public var cbMemberEmblemOnDoor:ButtonContainer;
      
      public var cbOthersEmblemOnDoor:ButtonContainer;
      
      public var cbAccessGuildmatesHouse:ButtonContainer;
      
      public var cbAccessHouseDenyOthers:ButtonContainer;
      
      public var cbGuildmatesAccessSafes:ButtonContainer;
      
      public var cbForbiddenSafes:ButtonContainer;
      
      public var cbAllowRespawn:ButtonContainer;
      
      public var cbAllowTeleport:ButtonContainer;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var tx_emblemBackOld:Texture;
      
      public var tx_emblemUpOld:Texture;
      
      public var tx_emblemBackNew:Texture;
      
      public var tx_emblemUpNew:Texture;
      
      public var ctr_rightsList:GraphicContainer;
      
      public var ctr_oneEmblem:GraphicContainer;
      
      public var ctr_twoEmblems:GraphicContainer;
      
      public function HouseGuildManager()
      {
         super();
      }
      
      public function main(param1:*) : void
      {
         this.sysApi.addHook(HouseGuildNone,this.houseGuildNone);
         this.sysApi.addHook(HouseGuildRights,this.houseGuildRights);
         this.sysApi.sendAction(new HouseGuildRightsView());
         this.uiApi.addComponentHook(this.btnClose,"onRelease");
         this.uiApi.addComponentHook(this.btnValidate,"onRelease");
         this.uiApi.addComponentHook(this.cbGuildHouseEnabled,"onRelease");
         this.tx_emblemBack.dispatchMessages = true;
         this.tx_emblemUp.dispatchMessages = true;
         this.tx_emblemBackOld.dispatchMessages = true;
         this.tx_emblemUpOld.dispatchMessages = true;
         this.tx_emblemBackNew.dispatchMessages = true;
         this.tx_emblemUpNew.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_emblemBack,"onTextureReady");
         this.uiApi.addComponentHook(this.tx_emblemUp,"onTextureReady");
         this.uiApi.addComponentHook(this.tx_emblemBackOld,"onTextureReady");
         this.uiApi.addComponentHook(this.tx_emblemUpOld,"onTextureReady");
         this.uiApi.addComponentHook(this.tx_emblemBackNew,"onTextureReady");
         this.uiApi.addComponentHook(this.tx_emblemUpNew,"onTextureReady");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.lblGuildHouseNotice.wordWrap = true;
         this.lblGuildHouseNotice.multiline = true;
         this._myGuild = this.socialApi.getGuild();
      }
      
      private function houseGuildNone() : void
      {
         this.ctr_rightsList.disabled = true;
         this.lbl_title.text = this.uiApi.getText("ui.common.guildHouse");
         this.showEmblem();
      }
      
      private function houseGuildRights(param1:uint, param2:String, param3:Object, param4:int) : void
      {
         this.ctr_rightsList.disabled = false;
         this._guildName = param2;
         this.lbl_title.text = this.uiApi.getText("ui.common.houseOwnerName",this._guildName);
         this._guildEmblem = param3;
         this.showEmblem();
         this.updateRights(param4);
      }
      
      private function showEmblem() : void
      {
         if(this._guildEmblem == null || this._guildName == this._myGuild.guildName)
         {
            this.ctr_oneEmblem.visible = true;
            this.ctr_twoEmblems.visible = false;
            this.tx_emblemBack.uri = this.uiApi.createUri(this._myGuild.backEmblem.fullSizeIconUri.toString());
            this.tx_emblemUp.uri = this.uiApi.createUri(this._myGuild.upEmblem.fullSizeIconUri.toString());
         }
         else
         {
            this.ctr_oneEmblem.visible = false;
            this.ctr_twoEmblems.visible = true;
            this.tx_emblemBackOld.uri = this.uiApi.createUri(this._guildEmblem.backEmblem.fullSizeIconUri.toString());
            this.tx_emblemUpOld.uri = this.uiApi.createUri(this._guildEmblem.upEmblem.fullSizeIconUri.toString());
            this.tx_emblemBackNew.uri = this.uiApi.createUri(this._myGuild.backEmblem.fullSizeIconUri.toString());
            this.tx_emblemUpNew.uri = this.uiApi.createUri(this._myGuild.upEmblem.fullSizeIconUri.toString());
         }
      }
      
      private function updateRights(param1:int) : void
      {
         this.cbGuildHouseEnabled.selected = (1 & param1 >> 0) == 1;
         this.cbMemberEmblemOnDoor.selected = (1 & param1 >> 1) == 1;
         this.cbOthersEmblemOnDoor.selected = (1 & param1 >> 2) == 1;
         this.cbAccessGuildmatesHouse.selected = (1 & param1 >> 3) == 1;
         this.cbAccessHouseDenyOthers.selected = (1 & param1 >> 4) == 1;
         this.cbGuildmatesAccessSafes.selected = (1 & param1 >> 5) == 1;
         this.cbForbiddenSafes.selected = (1 & param1 >> 6) == 1;
         this.cbAllowTeleport.selected = (1 & param1 >> 7) == 1;
         this.cbAllowRespawn.selected = (1 & param1 >> 8) == 1;
      }
      
      private function rightsToInt() : int
      {
         var _loc1_:int = 0;
         _loc1_ = this.setBoolean(this.cbGuildHouseEnabled.selected,_loc1_,0);
         _loc1_ = this.setBoolean(this.cbMemberEmblemOnDoor.selected,_loc1_,1);
         _loc1_ = this.setBoolean(this.cbOthersEmblemOnDoor.selected,_loc1_,2);
         _loc1_ = this.setBoolean(this.cbAccessGuildmatesHouse.selected,_loc1_,3);
         _loc1_ = this.setBoolean(this.cbAccessHouseDenyOthers.selected,_loc1_,4);
         _loc1_ = this.setBoolean(this.cbGuildmatesAccessSafes.selected,_loc1_,5);
         _loc1_ = this.setBoolean(this.cbForbiddenSafes.selected,_loc1_,6);
         _loc1_ = this.setBoolean(this.cbAllowTeleport.selected,_loc1_,7);
         _loc1_ = this.setBoolean(this.cbAllowRespawn.selected,_loc1_,8);
         return _loc1_;
      }
      
      private function setBoolean(param1:Boolean, param2:int, param3:int) : int
      {
         if(param1)
         {
            param2 = param2 | 1 << param3;
         }
         else
         {
            param2 = param2 & ~(1 << param3);
         }
         return param2;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btnClose:
               this.uiApi.unloadUi(this.uiApi.me().name);
               return;
            case this.btnValidate:
               if(this._guildName == this._myGuild.guildName || !this._guildName)
               {
                  this.onPopupValid();
               }
               else
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.house.takeAnotherGuildHouse",this._guildName),[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onPopupValid,this.onPopupClose],this.onPopupValid,this.onPopupClose);
               }
               return;
            case this.cbGuildHouseEnabled:
               this.ctr_rightsList.disabled = !this.cbGuildHouseEnabled.selected;
               return;
            default:
               return;
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         var _loc3_:EmblemSymbol = null;
         var _loc4_:EmblemSymbol = null;
         switch(param1)
         {
            case this.tx_emblemBack:
               this.utilApi.changeColor(this.tx_emblemBack.getChildByName("back"),this._myGuild.backEmblem.color,1);
               break;
            case this.tx_emblemUp:
               _loc2_ = this.dataApi.getEmblemSymbol(this._myGuild.upEmblem.idEmblem);
               if(_loc2_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._myGuild.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUp.getChildByName("up"),this._myGuild.upEmblem.color,0,true);
               }
               break;
            case this.tx_emblemBackOld:
               this.utilApi.changeColor(this.tx_emblemBackOld.getChildByName("back"),this._guildEmblem.backEmblem.color,1);
               break;
            case this.tx_emblemUpOld:
               _loc3_ = this.dataApi.getEmblemSymbol(this._guildEmblem.upEmblem.idEmblem);
               if(_loc3_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUpOld.getChildByName("up"),this._guildEmblem.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUpOld.getChildByName("up"),this._guildEmblem.upEmblem.color,0,true);
               }
               break;
            case this.tx_emblemBackNew:
               this.utilApi.changeColor(this.tx_emblemBackNew.getChildByName("back"),this._myGuild.backEmblem.color,1);
               break;
            case this.tx_emblemUpNew:
               _loc4_ = this.dataApi.getEmblemSymbol(this._myGuild.upEmblem.idEmblem);
               if(_loc4_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUpNew.getChildByName("up"),this._myGuild.upEmblem.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUpNew.getChildByName("up"),this._myGuild.upEmblem.color,0,true);
               }
         }
      }
      
      public function unload() : void
      {
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupValid() : void
      {
         this.sysApi.sendAction(new HouseGuildShare(this.cbGuildHouseEnabled.selected,this.rightsToInt()));
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi((this.uiApi.me() as Object).name);
               return true;
            default:
               return false;
         }
      }
   }
}
