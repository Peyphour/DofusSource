package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class IdolsPresetDeleteAction implements Action
   {
       
      
      public var presetId:uint;
      
      public function IdolsPresetDeleteAction()
      {
         super();
      }
      
      public static function create(param1:uint) : IdolsPresetDeleteAction
      {
         var _loc2_:IdolsPresetDeleteAction = new IdolsPresetDeleteAction();
         _loc2_.presetId = param1;
         return _loc2_;
      }
   }
}
