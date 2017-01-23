package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GiftAssignAllRequestAction implements Action
   {
       
      
      public var characterId:Number;
      
      public function GiftAssignAllRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number) : GiftAssignAllRequestAction
      {
         var _loc2_:GiftAssignAllRequestAction = new GiftAssignAllRequestAction();
         _loc2_.characterId = param1;
         return _loc2_;
      }
   }
}
