package makers
{
   import d2hooks.MouseShiftClick;
   
   public class InteractiveElementMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function InteractiveElementMenuMaker()
      {
         super();
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:String = Api.data.getInteractive(param1.elementTypeId).name;
         _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc4_));
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.chat.insertCoordinates"),this.insertLink,[_loc4_],disabled));
         return _loc3_;
      }
      
      private function insertLink(param1:String) : void
      {
         Api.system.dispatchHook(MouseShiftClick,{
            "data":"Map",
            "params":{
               "x":Api.player.currentMap().outdoorX,
               "y":Api.player.currentMap().outdoorY,
               "worldMapId":Api.player.currentSubArea().worldmap.id,
               "elementName":param1 + " "
            }
         });
      }
   }
}
