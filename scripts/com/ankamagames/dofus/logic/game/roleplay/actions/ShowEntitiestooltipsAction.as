package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowEntitiestooltipsAction implements Action
   {
       
      
      public var fromShortcut:Boolean;
      
      public function ShowEntitiestooltipsAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = true) : ShowEntitiestooltipsAction
      {
         var _loc2_:ShowEntitiestooltipsAction = new ShowEntitiestooltipsAction();
         _loc2_.fromShortcut = param1;
         return _loc2_;
      }
   }
}
