package makers.world
{
   import blocks.TextTooltipBlock;
   
   public class WorldTaxeCollectorFighterTooltipMaker
   {
       
      
      public function WorldTaxeCollectorFighterTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         param2 = {
            "css":"[local.css]tooltip_title.css",
            "classCss":"center"
         };
         if(Api.fight.preFightIsActive())
         {
            _loc3_.addBlock(new TextTooltipBlock(Api.fight.getFighterName(param1.contextualId) + " (" + Api.fight.getFighterLevel(param1.contextualId) + ")",param2).block);
         }
         else
         {
            _loc3_.addBlock(new TextTooltipBlock(Api.fight.getFighterName(param1.contextualId) + " (" + param1.stats.lifePoints + ")",param2).block);
         }
         return _loc3_;
      }
   }
}
