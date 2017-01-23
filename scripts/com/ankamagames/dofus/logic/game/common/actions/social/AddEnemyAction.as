package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddEnemyAction implements Action
   {
       
      
      public var name:String;
      
      public function AddEnemyAction()
      {
         super();
      }
      
      public static function create(param1:String) : AddEnemyAction
      {
         var _loc2_:AddEnemyAction = new AddEnemyAction();
         _loc2_.name = param1;
         return _loc2_;
      }
   }
}
