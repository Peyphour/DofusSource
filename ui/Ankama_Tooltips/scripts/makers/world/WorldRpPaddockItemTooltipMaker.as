package makers.world
{
   import blocks.mount.PaddockItemBlock;
   
   public class WorldRpPaddockItemTooltipMaker
   {
       
      
      public function WorldRpPaddockItemTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/separator.txt");
         _loc3_.addBlock(new PaddockItemBlock(param1).block);
         return _loc3_;
      }
   }
}
