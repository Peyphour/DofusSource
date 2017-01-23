package makers.world
{
   import blocks.WorldRpCharacterBlock;
   
   public class WorldRpMerchantCharacterTooltipMaker
   {
       
      
      public function WorldRpMerchantCharacterTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new WorldRpCharacterBlock().block);
         return _loc3_;
      }
   }
}
