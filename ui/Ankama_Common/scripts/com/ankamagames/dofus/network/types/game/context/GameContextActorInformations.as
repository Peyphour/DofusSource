package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   
   public class GameContextActorInformations
   {
       
      
      public function GameContextActorInformations()
      {
         super();
      }
      
      public function get contextualId() : Number
      {
         return new Number();
      }
      
      public function get look() : EntityLook
      {
         return new EntityLook();
      }
      
      public function get disposition() : EntityDispositionInformations
      {
         return new EntityDispositionInformations();
      }
   }
}
