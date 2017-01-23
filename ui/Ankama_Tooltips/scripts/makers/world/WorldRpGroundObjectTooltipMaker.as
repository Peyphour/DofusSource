package makers.world
{
   import blocks.TextTooltipBlock;
   
   public class WorldRpGroundObjectTooltipMaker
   {
       
      
      public function WorldRpGroundObjectTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         _loc3_.addBlock(new TextTooltipBlock(param1.object.name,{
            "css":"[local.css]tooltip_default.css",
            "classCss":"center"
         }).block);
         return _loc3_;
      }
   }
}
