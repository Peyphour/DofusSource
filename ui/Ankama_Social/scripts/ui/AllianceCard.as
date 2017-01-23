package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ComponentHookList;
   import d2hooks.OpenOneAlliance;
   import flash.utils.Dictionary;
   
   public class AllianceCard
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var socialApi:SocialApi;
      
      public var timeApi:TimeApi;
      
      public var chatApi:ChatApi;
      
      private var _data:Object;
      
      private var _compsTxEmblem:Dictionary;
      
      private var _comps:Dictionary;
      
      public var lbl_title:Label;
      
      public var lbl_tag:Label;
      
      public var lbl_leader:Label;
      
      public var lbl_guilds:Label;
      
      public var lbl_areas:Label;
      
      public var lbl_members:Label;
      
      public var lbl_creationDate:Label;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var gd_guilds:Grid;
      
      public var btn_close:ButtonContainer;
      
      public function AllianceCard()
      {
         this._compsTxEmblem = new Dictionary(true);
         this._comps = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(OpenOneAlliance,this.onOpenOneAlliance);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.tx_emblemBack.dispatchMessages = true;
         this.tx_emblemUp.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_emblemBack,ComponentHookList.ON_TEXTURE_READY);
         this.uiApi.addComponentHook(this.tx_emblemUp,ComponentHookList.ON_TEXTURE_READY);
         this._data = rest[0].alliance;
         this.updateInformations();
      }
      
      public function unload() : void
      {
      }
      
      public function updateGuildLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:EmblemSymbol = null;
         this._compsTxEmblem[param2.tx_emblemBackGuild.name] = param1;
         this._compsTxEmblem[param2.tx_emblemUpGuild.name] = param1;
         if(param1 != null)
         {
            param2.lbl_guildName.text = this.chatApi.getGuildLink(param1,param1.guildName);
            param2.lbl_guildLvl.text = param1.guildLevel;
            param2.tx_emblemBackGuild.uri = param1.backEmblem.iconUri;
            param2.tx_emblemUpGuild.uri = param1.upEmblem.iconUri;
            this.utilApi.changeColor(param2.tx_emblemBackGuild,param1.backEmblem.color,1);
            _loc4_ = this.dataApi.getEmblemSymbol(param1.upEmblem.idEmblem);
            if(_loc4_.colorizable)
            {
               this.utilApi.changeColor(param2.tx_emblemUpGuild,param1.upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(param2.tx_emblemUpGuild,param1.upEmblem.color,0,true);
            }
         }
         else
         {
            param2.lbl_guildName.text = "";
            param2.lbl_guildLvl.text = "";
            param2.tx_emblemBackGuild.uri = null;
            param2.tx_emblemUpGuild.uri = null;
         }
      }
      
      private function updateInformations() : void
      {
         this.lbl_title.text = this._data.allianceName;
         this.lbl_tag.text = "[" + this._data.allianceTag + "]";
         this.lbl_leader.text = "{player," + this._data.leaderCharacterName + "," + this._data.leaderCharacterId + "::" + this._data.leaderCharacterName + "}";
         this.lbl_guilds.text = "" + this._data.nbGuilds;
         this.lbl_members.text = "" + this.utilApi.formateIntToString(this._data.nbMembers);
         if(this._data.prismIds && this._data.prismIds.length)
         {
            this.lbl_areas.text = this.uiApi.getText("ui.prism.nbPrisms",this._data.prismIds.length);
         }
         else
         {
            this.lbl_areas.text = this.uiApi.getText("ui.prism.noPrism");
         }
         this.lbl_creationDate.text = this.timeApi.getDofusDate(this._data.creationDate * 1000);
         this.tx_emblemBack.uri = this._data.backEmblem.fullSizeIconUri;
         this.tx_emblemUp.uri = this._data.upEmblem.fullSizeIconUri;
         this.gd_guilds.dataProvider = this._data.guilds;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
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
         var _loc3_:EmblemSymbol = null;
         var _loc2_:Object = this._data;
         if(param1.name.indexOf("Guild") != -1)
         {
            _loc2_ = this._compsTxEmblem[param1.name];
         }
         if(param1.name.indexOf("tx_emblemBack") != -1)
         {
            this.utilApi.changeColor(param1.getChildByName("back"),_loc2_.backEmblem.color,1);
         }
         else if(param1.name.indexOf("tx_emblemUp") != -1)
         {
            _loc3_ = this.dataApi.getEmblemSymbol(_loc2_.upEmblem.idEmblem);
            if(_loc3_.colorizable)
            {
               this.utilApi.changeColor(param1.getChildByName("up"),_loc2_.upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(param1.getChildByName("up"),_loc2_.upEmblem.color,0,true);
            }
         }
      }
      
      private function onOpenOneAlliance(param1:Object) : void
      {
         this._data = param1;
         this.updateInformations();
      }
   }
}
