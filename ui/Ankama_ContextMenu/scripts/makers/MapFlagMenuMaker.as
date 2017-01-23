package makers
{
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import d2actions.FriendSpouseFollow;
   import d2actions.PartyStopFollowingMember;
   import d2enums.CompassTypeEnum;
   import d2hooks.OpenBook;
   import d2hooks.RemoveMapFlag;
   
   public class MapFlagMenuMaker
   {
       
      
      private var disabled:Boolean = false;
      
      private var _worldMapId:int;
      
      public function MapFlagMenuMaker()
      {
         super();
      }
      
      private function askRemoveFlag(param1:String) : void
      {
         var _loc2_:int = 0;
         if(param1.indexOf("flag_srv") == 0)
         {
            _loc2_ = int(param1.substring(8,9));
            switch(_loc2_)
            {
               case CompassTypeEnum.COMPASS_TYPE_SPOUSE:
                  Api.system.sendAction(new FriendSpouseFollow(false));
                  break;
               case CompassTypeEnum.COMPASS_TYPE_PARTY:
                  Api.system.sendAction(new PartyStopFollowingMember(Api.party.getPartyId(),int(param1.substring(10))));
                  break;
               default:
                  Api.system.dispatchHook(RemoveMapFlag,param1,this._worldMapId);
            }
         }
         else
         {
            Api.system.dispatchHook(RemoveMapFlag,param1,this._worldMapId);
         }
      }
      
      private function askOpenQuest(param1:String) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = int(param1.split("_")[2]);
         var _loc3_:Quest = Api.data.getQuest(_loc2_);
         if(_loc3_)
         {
            _loc4_ = new Object();
            _loc4_.quest = _loc3_;
            _loc4_.forceOpen = true;
            Api.system.dispatchHook(OpenBook,"questTab",_loc4_);
         }
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         if(param1 && param1.id.indexOf("flag_") == 0)
         {
            this._worldMapId = param2[0];
            if(param1.canBeManuallyRemoved)
            {
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.popup.delete"),this.askRemoveFlag,[param1.id],this.disabled));
            }
            if(param1.id.indexOf("flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST) == 0)
            {
               _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.shortcuts.openBookQuest"),this.askOpenQuest,[param1.id],this.disabled));
            }
         }
         return _loc3_;
      }
   }
}
