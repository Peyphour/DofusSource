package makers.world
{
   import blocks.MonsterFightBlock;
   
   public class WorldMonsterFighterTooltipMaker
   {
       
      
      public function WorldMonsterFighterTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         _loc3_.addBlock(new MonsterFightBlock().block);
         return _loc3_;
      }
   }
}
