package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagRoomSelectedAction implements Action
   {
       
      
      public var room:uint;
      
      public function HavenbagRoomSelectedAction()
      {
         super();
      }
      
      public static function create(param1:uint) : HavenbagRoomSelectedAction
      {
         var _loc2_:HavenbagRoomSelectedAction = new HavenbagRoomSelectedAction();
         _loc2_.room = param1;
         return _loc2_;
      }
   }
}
