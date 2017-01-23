package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.EventEnums;
   
   public class WorldRpPrismTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var infosCtr:GraphicContainer;
      
      public var lbl_prismName:Label;
      
      public var tx_AllianceEmblemBack:Texture;
      
      public var tx_AllianceEmblemUp:Texture;
      
      public var bgContainer:GraphicContainer;
      
      private var _alliance:AllianceWrapper;
      
      public function WorldRpPrismTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._alliance = param1.data.allianceIdentity;
         this.bgContainer.width = 1;
         this.bgContainer.removeFromParent();
         this.lbl_prismName.text = this._alliance.allianceName;
         this.lbl_prismName.fullWidth();
         this.lbl_prismName.y = this.tx_AllianceEmblemBack.height / 2 - this.lbl_prismName.height / 2;
         this.tx_AllianceEmblemBack.x = this.lbl_prismName.width + 8;
         this.tx_AllianceEmblemUp.x = this.tx_AllianceEmblemBack.x + 8;
         this.tx_AllianceEmblemUp.y = this.tx_AllianceEmblemBack.y + 8;
         this.tx_AllianceEmblemBack.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_AllianceEmblemBack,EventEnums.EVENT_ONTEXTUREREADY);
         this.tx_AllianceEmblemBack.uri = this.uiApi.createUri(this._alliance.backEmblem.fullSizeIconUri.toString(),true);
         this.tx_AllianceEmblemUp.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_AllianceEmblemUp,EventEnums.EVENT_ONTEXTUREREADY);
         this.tx_AllianceEmblemUp.uri = this.uiApi.createUri(this._alliance.upEmblem.fullSizeIconUri.toString(),true);
         this.infosCtr.width = this.lbl_prismName.width + 8 + this.tx_AllianceEmblemBack.width;
         this.infosCtr.height = this.tx_AllianceEmblemBack.height;
         this.bgContainer.width = this.lbl_prismName.width + this.tx_AllianceEmblemBack.width + 16;
         this.infosCtr.addContent(this.bgContainer,0);
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,param1.data.checkSuperposition,param1.data.cellId);
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:EmblemSymbol = null;
         if(param1 == this.tx_AllianceEmblemBack)
         {
            this.utilApi.changeColor(this.tx_AllianceEmblemBack.getChildByName("back"),this._alliance.backEmblem.color,1);
            this.tx_AllianceEmblemBack.visible = true;
         }
         else if(param1 == this.tx_AllianceEmblemUp)
         {
            _loc2_ = this.dataApi.getEmblemSymbol(this._alliance.upEmblem.idEmblem);
            if(_loc2_.colorizable)
            {
               this.utilApi.changeColor(this.tx_AllianceEmblemUp.getChildByName("up"),this._alliance.upEmblem.color,0);
            }
            else
            {
               this.utilApi.changeColor(this.tx_AllianceEmblemUp.getChildByName("up"),this._alliance.upEmblem.color,0,true);
            }
            this.tx_AllianceEmblemUp.visible = true;
         }
      }
   }
}
