package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   
   public class WorldRpPortalTooltipUi
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
      
      private var _area:Area;
      
      public function WorldRpPortalTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._area = this.dataApi.getArea(param1.data.areaId);
         this.bgContainer.width = 1;
         this.bgContainer.removeFromParent();
         this.lbl_prismName.text = this.uiApi.getText("ui.dimension.portal",this._area.name);
         this.lbl_prismName.fullWidth();
         this.tx_AllianceEmblemBack.uri = null;
         this.tx_AllianceEmblemUp.uri = null;
         this.infosCtr.width = this.lbl_prismName.width + 8;
         this.bgContainer.width = this.lbl_prismName.width + 16;
         this.infosCtr.addContent(this.bgContainer,0);
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,param1.data.checkSuperposition,param1.data.cellId);
      }
   }
}
