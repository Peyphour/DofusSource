package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatus;
   
   public class GameFightFighterNamedInformations extends GameFightFighterInformations
   {
       
      
      public function GameFightFighterNamedInformations()
      {
         super();
      }
      
      public function get name() : String
      {
         return new String();
      }
      
      public function get status() : PlayerStatus
      {
         return new PlayerStatus();
      }
   }
}
