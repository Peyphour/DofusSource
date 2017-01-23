package makers
{
   import d2actions.NpcGenericActionRequest;
   import d2hooks.MouseShiftClick;
   import flash.utils.Dictionary;
   
   public class NpcMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function NpcMenuMaker()
      {
         super();
      }
      
      private function onNPCMenuClick(param1:int, param2:int) : void
      {
         Api.system.sendAction(new NpcGenericActionRequest(param1,param2));
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
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc8_:Dictionary = null;
         var _loc9_:uint = 0;
         var _loc10_:* = undefined;
         var _loc11_:Object = null;
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc5_:int = param1.npcId;
         var _loc6_:Object = Api.data.getNpc(_loc5_);
         var _loc7_:Object = _loc6_.actions;
         if(param2.rightClick)
         {
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc6_.name));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.chat.insertCoordinates"),this.insertLink,[_loc6_.name],disabled));
            return _loc3_;
         }
         if(_loc7_.length > 0)
         {
            _loc3_.push(ContextMenu.static_createContextMenuTitleObject(_loc6_.name));
            _loc8_ = new Dictionary();
            for each(_loc9_ in _loc7_)
            {
               _loc11_ = Api.data.getNpcAction(_loc9_);
               if(_loc11_ && (_loc11_.realId != _loc9_ || !_loc8_[_loc11_.realId]))
               {
                  _loc8_[_loc11_.realId] = _loc11_.name;
               }
            }
            for(_loc10_ in _loc8_)
            {
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(_loc8_[_loc10_],this.onNPCMenuClick,[param2.entity.id,_loc10_],disabled || _loc4_));
            }
         }
         return _loc3_;
      }
   }
}
