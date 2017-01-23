package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HighlightInteractiveElementsAction implements Action
   {
       
      
      public var fromShortcut:Boolean;
      
      public function HighlightInteractiveElementsAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = true) : HighlightInteractiveElementsAction
      {
         var _loc2_:HighlightInteractiveElementsAction = new HighlightInteractiveElementsAction();
         _loc2_.fromShortcut = param1;
         return _loc2_;
      }
   }
}
