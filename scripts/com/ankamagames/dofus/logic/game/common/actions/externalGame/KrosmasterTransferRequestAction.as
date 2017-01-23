package com.ankamagames.dofus.logic.game.common.actions.externalGame
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class KrosmasterTransferRequestAction implements Action
   {
       
      
      public var figureId:String;
      
      public function KrosmasterTransferRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : KrosmasterTransferRequestAction
      {
         var _loc2_:KrosmasterTransferRequestAction = new KrosmasterTransferRequestAction();
         _loc2_.figureId = param1;
         return _loc2_;
      }
   }
}
