package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   
   public class WorldRpPaddockTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var lbl_paddockSize:Label;
      
      public var lbl_price:Label;
      
      public var lbl_type:Label;
      
      private var _guild:GuildWrapper;
      
      public function WorldRpPaddockTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Boolean = param1.data.hasOwnProperty("guildIdentity");
         if(_loc2_ && param1.data.guildIdentity)
         {
            this._guild = param1.data.guildIdentity;
            this.tx_emblemBack.visible = false;
            this.tx_emblemBack.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_emblemBack,"onTextureReady");
            this.tx_emblemBack.uri = this._guild.backEmblem.fullSizeIconUri;
            this.tx_emblemUp.visible = true;
            this.tx_emblemUp.dispatchMessages = true;
            this.uiApi.addComponentHook(this.tx_emblemUp,"onTextureReady");
            this.tx_emblemUp.uri = this._guild.upEmblem.fullSizeIconUri;
         }
         if(param1.data.hasOwnProperty("price") && param1.data.price)
         {
            if(!param1.data.isSaleLocked)
            {
               this.lbl_type.text = this.uiApi.getText("ui.mount.paddockToBuy",this.utilApi.kamasToString(param1.data.price));
            }
            else
            {
               this.lbl_type.text = this.uiApi.getText("ui.mount.paddockToBuySoon",this.utilApi.kamasToString(param1.data.price));
            }
            this.lbl_paddockSize.text = this.uiApi.getText("ui.mount.paddockSize",param1.data.maxItems,param1.data.maxOutdoorMount);
         }
         else if(_loc2_ && this._guild)
         {
            this.lbl_type.text = this.uiApi.getText("ui.mount.paddockPrivate");
            this.lbl_paddockSize.text = this.uiApi.getText("ui.mount.paddockSize",param1.data.maxItems,param1.data.maxOutdoorMount);
         }
         else if(param1.data.hasOwnProperty("isAbandonned") && param1.data.isAbandonned)
         {
            this.lbl_type.text = this.uiApi.getText("ui.mount.paddockAbandonned");
            this.lbl_paddockSize.text = this.uiApi.getText("ui.mount.maxMount",param1.data.maxItems);
         }
         else
         {
            this.lbl_type.text = this.uiApi.getText("ui.mount.paddockPublic");
            this.lbl_paddockSize.text = this.uiApi.getText("ui.mount.maxMount",param1.data.maxItems);
         }
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         switch(param1)
         {
            case this.tx_emblemBack:
               this.utilApi.changeColor(this.tx_emblemBack.getChildByName("back"),this._guild.backEmblem.color,1);
               this.tx_emblemBack.visible = true;
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
               this.tx_emblemUp.visible = true;
         }
      }
   }
}
