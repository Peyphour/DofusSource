package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2enums.ProtocolConstantsEnum;
   
   public class WorldRpFightTooltipUi
   {
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var mainCtr:GraphicContainer;
      
      public var levelCtr:GraphicContainer;
      
      public var waveCtr:GraphicContainer;
      
      public var lbl_fightersList:Label;
      
      public var lbl_nbWaves:Label;
      
      public var tx_wave:Texture;
      
      public function WorldRpFightTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:Object = null;
         var _loc2_:* = param1.data.nbWaves > 0;
         var _loc3_:String = "";
         for each(_loc4_ in param1.data.fighters)
         {
            if(_loc4_.allianceTag)
            {
               _loc3_ = _loc3_ + (_loc4_.allianceTag + " ");
            }
            _loc3_ = _loc3_ + (_loc4_.name + " (");
            if(_loc4_.id > 0 && _loc4_.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.prestige") + (_loc4_.level - ProtocolConstantsEnum.MAX_LEVEL) + ")\n");
            }
            else
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.short.level") + _loc4_.level + ")\n");
            }
         }
         this.lbl_fightersList.text = _loc3_;
         if(!_loc2_)
         {
            this.waveCtr.visible = false;
            this.lbl_fightersList.y = this.levelCtr.y + this.levelCtr.height;
         }
         else
         {
            this.waveCtr.visible = true;
            this.waveCtr.y = this.levelCtr.y + this.levelCtr.height;
            this.lbl_nbWaves.text = "x " + param1.data.nbWaves;
            this.lbl_nbWaves.fullWidth();
            this.tx_wave.x = this.mainCtr.width / 2 - (this.tx_wave.width + this.lbl_nbWaves.width) / 2;
            this.lbl_nbWaves.x = this.tx_wave.x + this.tx_wave.width;
            this.lbl_fightersList.y = this.waveCtr.y + this.waveCtr.height;
         }
         this.mainCtr.height = this.mainCtr.contentHeight;
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
         var _loc5_:Number = this.mainCtr.width / 2;
         this.levelCtr.x = int(_loc5_ - this.levelCtr.width / 2) - 2;
      }
      
      public function unload() : void
      {
      }
   }
}
