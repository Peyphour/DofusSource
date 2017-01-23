package makers
{
   import blocks.DelayedActionTooltipBlock;
   
   public class DelayedActionTooltipMaker
   {
       
      
      public function DelayedActionTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/separator.txt");
         _loc3_.addBlock(new DelayedActionTooltipBlock(param1).block);
         _loc3_.strata = -1;
         return _loc3_;
      }
   }
}
