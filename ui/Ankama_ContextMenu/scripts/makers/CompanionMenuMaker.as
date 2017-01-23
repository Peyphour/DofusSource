package makers
{
   import com.ankamagames.dofus.internalDatacenter.people.PartyCompanionWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import d2actions.GameContextKick;
   import d2actions.GameFightPlacementSwapPositionsRequest;
   import d2actions.ObjectSetPosition;
   import d2actions.PartyCancelInvitation;
   import d2actions.PartyKickRequest;
   import d2enums.CharacterInventoryPositionEnum;
   
   public class CompanionMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function CompanionMenuMaker()
      {
         super();
      }
      
      private function onDismiss() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc1_:Object = Api.storage.getViewContent("equipment");
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ && _loc3_.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION)
            {
               _loc2_ = _loc3_.objectUID;
               break;
            }
         }
         if(_loc2_ != 0)
         {
            Api.system.sendAction(new ObjectSetPosition(_loc2_,63,1));
         }
      }
      
      private function onSwitchPlaces(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new GameFightPlacementSwapPositionsRequest(param1,param2));
      }
      
      protected function onKick(param1:Number) : void
      {
         Api.system.sendAction(new GameContextKick(param1));
      }
      
      protected function kickPlayer(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyKickRequest(param1,param2));
      }
      
      protected function cancelPartyInvitation(param1:int, param2:Number) : void
      {
         Api.system.sendAction(new PartyCancelInvitation(param1,param2));
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc11_:int = 0;
         var _loc12_:* = false;
         var _loc13_:PartyMemberWrapper = null;
         if(param1 is GameFightCompanionInformations)
         {
            _loc3_ = param1 as GameFightCompanionInformations;
            if(Api.player.isInFight() && !Api.player.isInPreFight())
            {
               return [];
            }
            _loc4_ = _loc3_.masterId;
            _loc6_ = _loc3_.contextualId;
            _loc7_ = Api.data.getCompanion(_loc3_.companionGenericId).name;
            if(_loc4_ != Api.player.id())
            {
               _loc5_ = Api.fight.getFighterName(_loc4_);
               _loc7_ = Api.ui.getText("ui.common.belonging",_loc7_,_loc5_);
            }
            else
            {
               _loc5_ = Api.player.getPlayedCharacterInfo().name;
            }
         }
         else
         {
            _loc3_ = param1 as PartyCompanionWrapper;
            _loc4_ = _loc3_.id;
            _loc5_ = _loc3_.masterName;
            _loc6_ = _loc3_.id;
            _loc7_ = _loc3_.name;
         }
         var _loc8_:Array = new Array();
         var _loc9_:String = Api.fight.getFighterInformations(_loc4_).team;
         var _loc10_:String = Api.fight.getFighterInformations(Api.player.id()).team;
         _loc8_.push(ContextMenu.static_createContextMenuTitleObject(_loc7_));
         if(_loc4_ == Api.player.id())
         {
            _loc8_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.companion.dismiss"),this.onDismiss,[]),disabled);
         }
         else
         {
            if(Api.player.isInPreFight() && Api.fight.isFightLeader())
            {
               _loc8_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.fight.kickSomeone",_loc5_),this.onKick,[_loc4_]),disabled);
            }
            if(Api.player.isInParty())
            {
               _loc11_ = Api.party.getPartyId();
               if(_loc11_ > 0 && Api.party.getPartyLeaderId(_loc11_) == Api.player.id())
               {
                  _loc12_ = false;
                  for each(_loc13_ in Api.party.getPartyMembers(0))
                  {
                     if(_loc13_.id == _loc4_)
                     {
                        _loc12_ = !_loc13_.isMember;
                        break;
                     }
                  }
                  if(_loc12_)
                  {
                     _loc8_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.cancelInvitationForSomeone",_loc5_),this.cancelPartyInvitation,[_loc11_,_loc4_]));
                  }
                  else
                  {
                     _loc8_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.party.kickSomeone",_loc5_),this.kickPlayer,[_loc11_,_loc4_]));
                  }
               }
            }
         }
         if(Api.player.isInPreFight() && _loc9_ == _loc10_ && _loc3_.hasOwnProperty("disposition") && _loc3_.disposition)
         {
            _loc8_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.companion.switchPlaces"),this.onSwitchPlaces,[_loc3_.disposition.cellId,_loc6_]),disabled);
         }
         if(_loc8_.length == 1)
         {
            _loc8_ = null;
         }
         return _loc8_;
      }
   }
}
