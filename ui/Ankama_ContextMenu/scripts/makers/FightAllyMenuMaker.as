package makers
{
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import d2actions.GameFightPlacementSwapPositionsRequest;
   
   public class FightAllyMenuMaker
   {
       
      
      public function FightAllyMenuMaker()
      {
         super();
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:GameFightFighterInformations = param1 as GameFightFighterInformations;
         var _loc4_:Array = new Array();
         if(Api.player.isInPreFight() && _loc3_.hasOwnProperty("disposition") && _loc3_.disposition)
         {
            _loc4_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.companion.switchPlaces"),this.onSwitchPlaces,[_loc3_.disposition.cellId,_loc3_.contextualId]));
         }
         if(_loc4_.length > 0)
         {
            _loc4_.splice(0,0,ContextMenu.static_createContextMenuTitleObject(Api.fight.getFighterName(_loc3_.contextualId)));
         }
         return _loc4_;
      }
      
      private function onSwitchPlaces(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new GameFightPlacementSwapPositionsRequest(param1,param2));
      }
   }
}
