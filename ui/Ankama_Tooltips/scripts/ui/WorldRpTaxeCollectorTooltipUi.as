package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   
   public class WorldRpTaxeCollectorTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      private var _guild:GuildWrapper;
      
      private var _alliance:AllianceWrapper;
      
      public var lbl_guildName:Label;
      
      public var lbl_playerName:Label;
      
      public var infosCtr:GraphicContainer;
      
      public var tx_back:GraphicContainer;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var tx_AllianceEmblemBack:Texture;
      
      public var tx_AllianceEmblemUp:Texture;
      
      public function WorldRpTaxeCollectorTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Number = NaN;
         this.tx_back.width = 1;
         this.tx_back.removeFromParent();
         this.tx_emblemBack.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_emblemBack,"onTextureReady");
         this.tx_emblemUp.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_emblemUp,"onTextureReady");
         this._guild = param1.data.guildIdentity;
         this.tx_emblemBack.uri = this._guild.backEmblem.fullSizeIconUri;
         this.tx_emblemUp.uri = this._guild.upEmblem.fullSizeIconUri;
         this.lbl_playerName.text = param1.data.lastName + " " + param1.data.firstName;
         this._alliance = param1.data.allianceIdentity;
         if(this._alliance)
         {
            this.lbl_guildName.text = this._guild.guildName + " - [" + this._alliance.allianceTag + "]";
            this.lbl_guildName.fullWidth();
            this.tx_AllianceEmblemBack.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_AllianceEmblemBack,"onTextureReady");
            this.tx_AllianceEmblemBack.uri = this.uiApi.createUri(this._alliance.backEmblem.fullSizeIconUri.toString(),true);
            this.tx_AllianceEmblemUp.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_AllianceEmblemUp,"onTextureReady");
            this.tx_AllianceEmblemUp.uri = this.uiApi.createUri(this._alliance.upEmblem.fullSizeIconUri.toString(),true);
            this.tx_AllianceEmblemBack.y = this.tx_emblemBack.y;
            this.tx_back.width = 50 + this.getMaxWidth() + this.tx_AllianceEmblemBack.width + 16;
            this.tx_AllianceEmblemBack.x = this.tx_back.width - 8 - this.tx_AllianceEmblemBack.width;
            this.tx_AllianceEmblemUp.y = this.tx_emblemUp.y;
            this.tx_AllianceEmblemUp.x = this.tx_AllianceEmblemBack.x + 8;
            this.infosCtr.width = this.tx_back.width - 10;
            _loc2_ = (this.tx_emblemBack.x + this.tx_emblemBack.width + this.tx_AllianceEmblemBack.x) / 2;
            this.lbl_guildName.x = _loc2_ - this.lbl_guildName.width / 2;
            this.lbl_playerName.x = _loc2_ - this.lbl_playerName.width / 2;
         }
         else
         {
            this.lbl_guildName.text = this._guild.guildName;
            this.lbl_guildName.fullWidth();
            this.tx_AllianceEmblemBack.visible = this.tx_AllianceEmblemUp.visible = false;
            this.lbl_guildName.x = this.lbl_playerName.x = 50;
            this.tx_back.width = 50 + this.getMaxWidth() + 16;
         }
         this.infosCtr.addContent(this.tx_back,0);
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,param1.data.checkSuperposition,param1.data.cellId);
      }
      
      private function getMaxWidth() : Number
      {
         var _loc1_:Number = this.lbl_guildName.width;
         this.lbl_playerName.fullWidth();
         if(this.lbl_playerName.width > _loc1_)
         {
            _loc1_ = this.lbl_playerName.width;
         }
         return _loc1_;
      }
      
      private function updateEmblemBack(param1:Texture, param2:int) : void
      {
         this.utilApi.changeColor(param1.getChildByName("back"),param2,1);
         param1.visible = true;
      }
      
      private function updateEmblemUp(param1:Texture, param2:int, param3:int) : void
      {
         var _loc4_:EmblemSymbol = this.dataApi.getEmblemSymbol(param3);
         if(_loc4_.colorizable)
         {
            this.utilApi.changeColor(param1.getChildByName("up"),param2,0);
         }
         else
         {
            this.utilApi.changeColor(param1.getChildByName("up"),param2,0,true);
         }
         param1.visible = true;
      }
      
      public function onTextureReady(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_emblemBack:
               this.updateEmblemBack(this.tx_emblemBack,this._guild.backEmblem.color);
               break;
            case this.tx_emblemUp:
               this.updateEmblemUp(this.tx_emblemUp,this._guild.upEmblem.color,this._guild.upEmblem.idEmblem);
               break;
            case this.tx_AllianceEmblemBack:
               this.updateEmblemBack(this.tx_AllianceEmblemBack,this._alliance.backEmblem.color);
               break;
            case this.tx_AllianceEmblemUp:
               this.updateEmblemUp(this.tx_AllianceEmblemUp,this._alliance.upEmblem.color,this._alliance.upEmblem.idEmblem);
         }
      }
      
      public function unload() : void
      {
      }
   }
}
