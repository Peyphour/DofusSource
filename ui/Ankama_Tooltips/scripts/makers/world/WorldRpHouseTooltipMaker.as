package makers.world
{
   import blocks.HouseTooltipBlock;
   
   public class WorldRpHouseTooltipMaker
   {
       
      
      public function WorldRpHouseTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         var _loc4_:Object = new Object();
         _loc4_.ownerName = param1.ownerName;
         _loc4_.isOneSale = param1.isOnSale;
         _loc4_.isSaleLocked = param1.isSaleLocked;
         var _loc5_:* = param1.guildIdentity != null;
         if(_loc5_)
         {
            _loc4_.guildIdentity = param1.guildIdentity;
            _loc3_.addBlock(new HouseTooltipBlock(_loc4_,2).block);
         }
         else if(param1.isOnSale)
         {
            _loc3_.addBlock(new HouseTooltipBlock(_loc4_,1).block);
         }
         else if(param1.isSaleLocked)
         {
            _loc3_.addBlock(new HouseTooltipBlock(_loc4_,3).block);
         }
         else
         {
            _loc3_.addBlock(new HouseTooltipBlock(_loc4_,0).block);
         }
         return _loc3_;
      }
   }
}
