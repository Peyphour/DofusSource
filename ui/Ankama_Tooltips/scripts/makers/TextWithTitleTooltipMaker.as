package makers
{
   import blocks.TextTooltipBlock;
   
   public class TextWithTitleTooltipMaker
   {
       
      
      public function TextWithTitleTooltipMaker()
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
         _loc3_.addBlock(new TextTooltipBlock(param1.title as String,param2).block);
         param2 = {"css":"[local.css]tooltip_default.css"};
         _loc3_.addBlock(new TextTooltipBlock(param1.text as String,param2).block);
         return _loc3_;
      }
   }
}
