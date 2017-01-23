package makers.world
{
   import blocks.InteractiveElementBlock;
   
   public class WorldRpInteractiveElementTooltipMaker
   {
       
      
      public function WorldRpInteractiveElementTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new InteractiveElementBlock(param1).block);
         return _loc3_;
      }
   }
}
