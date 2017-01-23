package makers
{
   import blocks.TextInfoWithHorizontalSeparatorTooltipBlock;
   
   public class TextInfoWithHorizontalSeparatorTooltipMaker
   {
       
      
      public function TextInfoWithHorizontalSeparatorTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/empty.txt");
         _loc3_.addBlock(new TextInfoWithHorizontalSeparatorTooltipBlock(param1).block);
         return _loc3_;
      }
   }
}
