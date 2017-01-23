package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class IdolSelectRequestAction implements Action
   {
       
      
      public var idolId:uint;
      
      public var activate:Boolean;
      
      public var party:Boolean;
      
      public function IdolSelectRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Boolean, param3:Boolean) : IdolSelectRequestAction
      {
         var _loc4_:IdolSelectRequestAction = new IdolSelectRequestAction();
         _loc4_.idolId = param1;
         _loc4_.activate = param2;
         _loc4_.party = param3;
         return _loc4_;
      }
   }
}
