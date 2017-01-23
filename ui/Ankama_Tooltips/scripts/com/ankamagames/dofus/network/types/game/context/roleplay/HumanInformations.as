package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   
   public class HumanInformations
   {
       
      
      public function HumanInformations()
      {
         super();
      }
      
      public function get restrictions() : ActorRestrictionsInformations
      {
         return new ActorRestrictionsInformations();
      }
      
      public function get sex() : Boolean
      {
         return new Boolean();
      }
      
      public function get options() : Vector.<HumanOption>
      {
         return new Vector.<HumanOption>();
      }
   }
}
