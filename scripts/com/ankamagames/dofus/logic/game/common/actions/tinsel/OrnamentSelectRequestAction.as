package com.ankamagames.dofus.logic.game.common.actions.tinsel
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OrnamentSelectRequestAction implements Action
   {
       
      
      public var ornamentId:int;
      
      public function OrnamentSelectRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : OrnamentSelectRequestAction
      {
         var _loc2_:OrnamentSelectRequestAction = new OrnamentSelectRequestAction();
         _loc2_.ornamentId = param1;
         return _loc2_;
      }
   }
}
