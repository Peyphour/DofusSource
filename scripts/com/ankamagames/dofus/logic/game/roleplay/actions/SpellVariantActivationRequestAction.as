package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SpellVariantActivationRequestAction implements Action
   {
       
      
      public var spellId:uint;
      
      public function SpellVariantActivationRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : SpellVariantActivationRequestAction
      {
         var _loc2_:SpellVariantActivationRequestAction = new SpellVariantActivationRequestAction();
         _loc2_.spellId = param1;
         return _loc2_;
      }
   }
}
