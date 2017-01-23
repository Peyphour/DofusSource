package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowMountsInFightAction implements Action
   {
       
      
      private var _visibility:Boolean;
      
      public function ShowMountsInFightAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : ShowMountsInFightAction
      {
         var _loc2_:ShowMountsInFightAction = new ShowMountsInFightAction();
         _loc2_._visibility = param1;
         return _loc2_;
      }
      
      public function get visibility() : Boolean
      {
         return this._visibility;
      }
   }
}
