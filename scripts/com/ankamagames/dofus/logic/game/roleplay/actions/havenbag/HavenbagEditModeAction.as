package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagEditModeAction implements Action
   {
       
      
      public var isActive:Boolean;
      
      public function HavenbagEditModeAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : HavenbagEditModeAction
      {
         var _loc2_:HavenbagEditModeAction = new HavenbagEditModeAction();
         _loc2_.isActive = param1;
         return _loc2_;
      }
   }
}
