package makers.world
{
   import blocks.WorldRpMonstersAgeBonusBlock;
   
   public class WorldRpMonstersGroupTooltipMaker
   {
       
      
      public function WorldRpMonstersGroupTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new WorldRpMonstersAgeBonusBlock().block);
         return _loc3_;
      }
   }
}
