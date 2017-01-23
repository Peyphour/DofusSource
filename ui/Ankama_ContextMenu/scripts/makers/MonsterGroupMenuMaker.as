package makers
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenBook;
   
   public class MonsterGroupMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function MonsterGroupMenuMaker()
      {
         super();
      }
      
      private function askBestiary(param1:Array) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.monsterId = 0;
         _loc2_.monsterSearch = null;
         _loc2_.monsterIdsList = param1;
         _loc2_.forceOpen = true;
         Api.system.dispatchHook(OpenBook,"bestiaryTab",_loc2_);
      }
      
      private function insertLink(param1:*) : void
      {
         Api.system.dispatchHook(MouseShiftClick,{
            "data":"MonsterGroup",
            "params":{
               "x":Api.player.currentMap().outdoorX,
               "y":Api.player.currentMap().outdoorY,
               "worldMapId":Api.player.currentSubArea().worldmap.id,
               "monsterName":Api.data.getMonsterFromId(param1.staticInfos.mainCreatureLightInfos.creatureGenericId).name,
               "infos":Api.roleplay.getMonsterGroupString(param1)
            }
         });
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc5_:MonsterInGroupInformations = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         _loc4_.push(param1.staticInfos.mainCreatureLightInfos.creatureGenericId);
         for each(_loc5_ in param1.staticInfos.underlings)
         {
            if(_loc4_.indexOf(_loc5_.creatureGenericId) == -1)
            {
               _loc4_.push(_loc5_.creatureGenericId);
            }
         }
         if(_loc4_.length > 0)
         {
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.bestiary"),this.askBestiary,[_loc4_],disabled));
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.chat.insertCoordinates"),this.insertLink,[param1],disabled));
         }
         return _loc3_;
      }
   }
}
