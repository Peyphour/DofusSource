package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterReportAction implements Action
   {
       
      
      public var reportedId:Number;
      
      public var reason:uint;
      
      public function CharacterReportAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:uint) : CharacterReportAction
      {
         var _loc3_:CharacterReportAction = new CharacterReportAction();
         _loc3_.reportedId = param1;
         _loc3_.reason = param2;
         return _loc3_;
      }
   }
}
