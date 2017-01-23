package makers.world
{
   import blocks.mount.PaddockWithGuildBlock;
   import blocks.mount.PaddockWithPriceBlock;
   
   public class WorldRpPaddockTooltipMaker
   {
       
      
      public function WorldRpPaddockTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         var _loc4_:Object = new Object();
         _loc4_.maxItems = param1.maxItems;
         _loc4_.maxMounts = param1.maxOutdoorMount;
         if(param1.hasOwnProperty("price"))
         {
            _loc4_.price = param1.price;
         }
         if(param1.hasOwnProperty("guildIdentity") && param1.guildIdentity)
         {
            _loc4_.guildIdentity = param1.guildIdentity;
            _loc4_.guildName = param1.guildIdentity.guildName;
            _loc3_.addBlock(new PaddockWithGuildBlock(_loc4_).block);
         }
         else
         {
            _loc3_.addBlock(new PaddockWithPriceBlock(_loc4_).block);
         }
         return _loc3_;
      }
   }
}
