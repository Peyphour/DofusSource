package makers.world
{
   import blocks.TextTooltipBlock;
   
   public class WorldRpPaddockMountTooltipMaker
   {
       
      
      public function WorldRpPaddockMountTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc3_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         var _loc4_:String = param1.name;
         if(param1.name == "")
         {
            _loc4_ = Api.ui.getText("ui.common.noName");
         }
         else
         {
            _loc4_ = param1.name;
         }
         if(Api.player.getPlayedCharacterInfo().name != param1.ownerName)
         {
            _loc4_ = _loc4_ + ("\n" + Api.ui.getText("ui.mount.mountOf",param1.ownerName));
         }
         _loc4_ = _loc4_ + ("\n" + Api.ui.getText("ui.common.level") + " " + param1.level);
         _loc3_.addBlock(new TextTooltipBlock(_loc4_,{
            "css":"[local.css]tooltip_title.css",
            "classCss":"center"
         }).block);
         return _loc3_;
      }
   }
}
