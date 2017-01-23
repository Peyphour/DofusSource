package com.ankamagames.dofus.uiApi
{
   public class PartyApi
   {
       
      
      public function PartyApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getPartyMembers(param1:int = 0) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getPartyLeaderId(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function isInParty(param1:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getPartyId() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function isArenaRegistered() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getArenaCurrentStatus() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getArenaPartyId() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getArenaLeader() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getArenaReadyPartyMemberIds() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getArenaAlliesIds() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getArenaRankSoloInfos() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getArenaRankGroupInfos() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAllMemberFollowPlayerId(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getPartyLoyalty(param1:int) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getAllSubscribedDungeons() : Object
      {
         return null;
      }
   }
}
