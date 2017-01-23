package makers
{
   import blocks.TextWithShortcutTooltipBlock;
   
   public class TextWithShortcutTooltipMaker
   {
       
      
      public function TextWithShortcutTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         _loc3_.addBlock(new TextWithShortcutTooltipBlock(param1 as String,param2).block);
         return _loc3_;
      }
   }
}
