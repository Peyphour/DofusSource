package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   
   public class ConnectionApi
   {
       
      
      public function ConnectionApi()
      {
         super();
      }
      
      [Untrusted]
      public function getUsedServers() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getServers() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAvailableSlotsByServerType() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function hasGuestAccount() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isCharacterWaitingForChange(param1:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function allowAutoConnectCharacter(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function getAutoChosenServer(param1:int) : GameServerInformations
      {
         return null;
      }
   }
}
