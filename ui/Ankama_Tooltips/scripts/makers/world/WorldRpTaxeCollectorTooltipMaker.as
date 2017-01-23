package makers.world
{
   import blocks.WorldRpCharacterWithGuildBlock;
   
   public class WorldRpTaxeCollectorTooltipMaker
   {
       
      
      public function WorldRpTaxeCollectorTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/separator.txt");
         var _loc4_:Object = new Object();
         _loc4_.guildName = param1.guildIdentity.guildName;
         if(param1.allianceIdentity)
         {
            _loc4_.guildName = _loc4_.guildName + (" - [" + param1.allianceIdentity.allianceTag + "]");
         }
         _loc3_.addBlock(new WorldRpCharacterWithGuildBlock(_loc4_).block);
         return _loc3_;
      }
   }
}
