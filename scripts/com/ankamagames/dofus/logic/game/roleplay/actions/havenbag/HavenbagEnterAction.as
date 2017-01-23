package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagEnterAction implements Action
   {
       
      
      public function HavenbagEnterAction()
      {
         super();
      }
      
      public static function create() : HavenbagEnterAction
      {
         var _loc1_:HavenbagEnterAction = new HavenbagEnterAction();
         return _loc1_;
      }
   }
}
