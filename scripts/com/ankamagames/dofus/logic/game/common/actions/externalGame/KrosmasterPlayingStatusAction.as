package com.ankamagames.dofus.logic.game.common.actions.externalGame
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class KrosmasterPlayingStatusAction implements Action
   {
       
      
      public var playing:Boolean;
      
      public function KrosmasterPlayingStatusAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : KrosmasterPlayingStatusAction
      {
         var _loc2_:KrosmasterPlayingStatusAction = new KrosmasterPlayingStatusAction();
         _loc2_.playing = param1;
         return _loc2_;
      }
   }
}
