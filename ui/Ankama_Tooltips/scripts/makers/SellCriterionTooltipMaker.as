package makers
{
   import blocks.ConditionTooltipBlock;
   
   public class SellCriterionTooltipMaker
   {
      
      private static const chunkType:String = "htmlChunks";
       
      
      public function SellCriterionTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:* = chunkType + "/base/baseWithBackground.txt";
         var _loc4_:Object = Api.tooltip.createTooltip(_loc3_,chunkType + "/base/container.txt",chunkType + "/base/separator.txt");
         _loc4_.chunkType = chunkType;
         _loc4_.addBlock(new ConditionTooltipBlock({"criteria":[param1]},param1,Api.ui.getText("ui.sell.condition"),false,chunkType).block);
         return _loc4_;
      }
   }
}
