package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   
   public class WorldRpPaddockItemTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var lbl_name:Label;
      
      public var lbl_durability:Label;
      
      public var bgCtr:GraphicContainer;
      
      public function WorldRpPaddockItemTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Object = param1.data;
         this.lbl_name.text = _loc2_.name;
         this.lbl_name.fullWidth();
         this.lbl_durability.text = _loc2_.durability.durability + "/" + _loc2_.durability.durabilityMax;
         this.lbl_durability.fullWidth();
         this.bgCtr.width = this.lbl_name.width > this.lbl_durability.width?Number(this.lbl_name.width + 10):Number(this.lbl_durability.width + 10);
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
      }
      
      public function unload() : void
      {
      }
   }
}
