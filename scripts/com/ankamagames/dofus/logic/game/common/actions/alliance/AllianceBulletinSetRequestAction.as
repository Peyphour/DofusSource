package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceBulletinSetRequestAction implements Action
   {
       
      
      public var content:String;
      
      public var notifyMembers:Boolean;
      
      public function AllianceBulletinSetRequestAction()
      {
         super();
      }
      
      public static function create(param1:String, param2:Boolean = true) : AllianceBulletinSetRequestAction
      {
         var _loc3_:AllianceBulletinSetRequestAction = new AllianceBulletinSetRequestAction();
         _loc3_.content = param1;
         _loc3_.notifyMembers = param2;
         return _loc3_;
      }
   }
}
