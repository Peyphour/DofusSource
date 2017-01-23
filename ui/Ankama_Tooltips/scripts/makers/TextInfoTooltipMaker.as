package makers
{
   import blocks.TextInfoTooltipBlock;
   
   public class TextInfoTooltipMaker
   {
       
      
      public function TextInfoTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/simpleBaseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         _loc3_.addBlock(new TextInfoTooltipBlock().block);
         return _loc3_;
      }
   }
}
