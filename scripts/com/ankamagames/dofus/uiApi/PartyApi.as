package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class PartyApi implements IApi
   {
       
      
      private var _module:UiModule;
      
      protected var _log:Logger;
      
      public function PartyApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(PartyApi));
         super();
      }
      
      private function get partyManagementFrame() : PartyManagementFrame
      {
         return Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getPartyMembers(param1:int = 0) : Object
      {
         if(param1 == 1)
         {
            return this.partyManagementFrame.arenaPartyMembers;
         }
         return this.partyManagementFrame.partyMembers;
      }
      
      [Untrusted]
      public function getPartyLeaderId(param1:int) : Number
      {
         var _loc2_:Object = null;
         if(param1 == this.partyManagementFrame.arenaPartyId)
         {
            for each(_loc2_ in this.partyManagementFrame.arenaPartyMembers)
            {
               if(_loc2_.isLeader)
               {
                  return _loc2_.id;
               }
            }
         }
         else if(param1 == this.partyManagementFrame.partyId)
         {
            for each(_loc2_ in this.partyManagementFrame.partyMembers)
            {
               if(_loc2_.isLeader)
               {
                  return _loc2_.id;
               }
            }
         }
         return -1;
      }
      
      [Untrusted]
      public function isInParty(param1:Number) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.partyManagementFrame.partyMembers)
         {
            if(param1 == _loc2_.id)
            {
               return true;
            }
         }
         for each(_loc2_ in this.partyManagementFrame.arenaPartyMembers)
         {
            if(param1 == _loc2_.id)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getPartyId() : int
      {
         return this.partyManagementFrame.partyId;
      }
      
      [Untrusted]
      public function isArenaRegistered() : Boolean
      {
         return this.partyManagementFrame.isArenaRegistered;
      }
      
      [Untrusted]
      public function getArenaCurrentStatus() : int
      {
         return this.partyManagementFrame.arenaCurrentStatus;
      }
      
      [Untrusted]
      public function getArenaPartyId() : int
      {
         return this.partyManagementFrame.arenaPartyId;
      }
      
      [Untrusted]
      public function getArenaLeader() : Object
      {
         return this.partyManagementFrame.arenaLeader;
      }
      
      [Untrusted]
      public function getArenaReadyPartyMemberIds() : Object
      {
         return this.partyManagementFrame.arenaReadyPartyMemberIds;
      }
      
      [Untrusted]
      public function getArenaAlliesIds() : Object
      {
         return this.partyManagementFrame.arenaAlliesIds;
      }
      
      [Untrusted]
      public function getArenaRankSoloInfos() : Object
      {
         return this.partyManagementFrame.arenaRankSoloInfos;
      }
      
      [Untrusted]
      public function getArenaRankGroupInfos() : Object
      {
         return this.partyManagementFrame.arenaRankGroupInfos;
      }
      
      [Untrusted]
      public function getAllMemberFollowPlayerId(param1:int) : Number
      {
         return this.partyManagementFrame.allMemberFollowPlayerId;
      }
      
      [Untrusted]
      public function getPartyLoyalty(param1:int) : Boolean
      {
         return this.partyManagementFrame.partyLoyalty;
      }
      
      [Untrusted]
      public function getAllSubscribedDungeons() : Vector.<uint>
      {
         return this.partyManagementFrame.subscribedDungeons;
      }
   }
}
