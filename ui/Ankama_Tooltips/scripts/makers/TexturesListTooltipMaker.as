package makers
{
   import blocks.TextureTooltipBlock;
   
   public class TexturesListTooltipMaker
   {
       
      
      public function TexturesListTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc6_:* = undefined;
         var _loc3_:String = "chunks/base/base.txt";
         var _loc4_:Object = Api.tooltip.createTooltip(_loc3_,"chunks/base/linearContainer.txt");
         var _loc5_:Object = param1;
         for each(_loc6_ in _loc5_)
         {
            _loc4_.addBlock(new TextureTooltipBlock(_loc6_).block);
         }
         _loc4_.strata = -1;
         return _loc4_;
      }
   }
}
