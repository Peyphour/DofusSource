package makers
{
   import d2actions.PaddockMoveItemRequest;
   import d2actions.PaddockRemoveItemRequest;
   
   public class PaddockItemMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function PaddockItemMenuMaker()
      {
         super();
      }
      
      private function onPaddockRemoved(param1:uint) : void
      {
         Api.system.sendAction(new PaddockRemoveItemRequest(param1));
      }
      
      private function onPaddockMoved(param1:Object, param2:uint) : void
      {
         Api.system.sendAction(new PaddockMoveItemRequest(param1));
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         var _loc5_:Object = Api.social.getGuild();
         var _loc6_:Object = Api.mount.getCurrentPaddock();
         if(_loc5_ && Api.social.hasGuildRight(Api.player.id(),"organizeFarms") && _loc6_ && _loc6_.guildIdentity && _loc6_.guildIdentity.guildId == _loc5_.guildId)
         {
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.remove"),this.onPaddockRemoved,[param2[0].position.cellId],disabled || _loc4_));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.move"),this.onPaddockMoved,[param1,param2[0].position.cellId],disabled || _loc4_));
         }
         return _loc3_;
      }
   }
}
