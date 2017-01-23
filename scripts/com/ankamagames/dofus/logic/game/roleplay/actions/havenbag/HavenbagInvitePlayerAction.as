package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagInvitePlayerAction implements Action
   {
       
      
      public var guestId:Number;
      
      public var invite:Boolean;
      
      public function HavenbagInvitePlayerAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Boolean) : HavenbagInvitePlayerAction
      {
         var _loc3_:HavenbagInvitePlayerAction = new HavenbagInvitePlayerAction();
         _loc3_.guestId = param1;
         _loc3_.invite = param2;
         return _loc3_;
      }
   }
}
