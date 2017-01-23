package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DownloadPartAction implements Action
   {
       
      
      public var id:String;
      
      public function DownloadPartAction()
      {
         super();
      }
      
      public static function create(param1:String) : DownloadPartAction
      {
         var _loc2_:DownloadPartAction = new DownloadPartAction();
         _loc2_.id = param1;
         return _loc2_;
      }
   }
}
