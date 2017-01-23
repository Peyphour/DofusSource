package makers
{
   import blocks.CartographyTooltipBlock;
   
   public class CartographyTooltipMaker
   {
       
      
      public function CartographyTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/base.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new CartographyTooltipBlock(param1).block);
         return _loc3_;
      }
   }
}
