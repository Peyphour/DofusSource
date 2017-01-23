package com.ankamagames.dofus.logic.game.common.actions.dare
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DareInformationsRequestAction implements Action
   {
       
      
      public var dareId:Number;
      
      public function DareInformationsRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number) : DareInformationsRequestAction
      {
         var _loc2_:DareInformationsRequestAction = new DareInformationsRequestAction();
         _loc2_.dareId = param1;
         return _loc2_;
      }
   }
}
