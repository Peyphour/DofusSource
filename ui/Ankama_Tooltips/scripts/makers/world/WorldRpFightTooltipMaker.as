package makers.world
{
   import blocks.FightTooltipBlock;
   import d2enums.ProtocolConstantsEnum;
   
   public class WorldRpFightTooltipMaker
   {
       
      
      public function WorldRpFightTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc6_:uint = 0;
         var _loc8_:* = undefined;
         var _loc3_:* = param1.fighters;
         var _loc4_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/empty.txt");
         var _loc5_:Object = new Object();
         var _loc7_:String = "";
         for each(_loc8_ in _loc3_)
         {
            if(_loc8_.id > 0 && _loc8_.level > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc6_ = _loc6_ + ProtocolConstantsEnum.MAX_LEVEL;
            }
            else
            {
               _loc6_ = _loc6_ + _loc8_.level;
            }
         }
         _loc5_.level = Api.ui.getText("ui.common.level") + " " + _loc6_;
         _loc4_.addBlock(new FightTooltipBlock(_loc5_).block);
         return _loc4_;
      }
   }
}
