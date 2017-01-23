package makers.world
{
   import blocks.WorldRpPrismBlock;
   
   public class WorldRpPrismTooltipMaker
   {
       
      
      public function WorldRpPrismTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new WorldRpPrismBlock(new Object()).block);
         return _loc3_;
      }
   }
}
