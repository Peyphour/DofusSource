package makers.world
{
   import blocks.CharacterFightBlock;
   
   public class WorldPlayerFighterTooltipMaker
   {
       
      
      public function WorldPlayerFighterTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new CharacterFightBlock().block);
         return _loc3_;
      }
   }
}
