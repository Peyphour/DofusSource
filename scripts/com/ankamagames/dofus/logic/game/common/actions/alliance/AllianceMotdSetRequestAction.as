package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceMotdSetRequestAction implements Action
   {
       
      
      public var content:String;
      
      public function AllianceMotdSetRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : AllianceMotdSetRequestAction
      {
         var _loc2_:AllianceMotdSetRequestAction = new AllianceMotdSetRequestAction();
         _loc2_.content = param1;
         return _loc2_;
      }
   }
}
