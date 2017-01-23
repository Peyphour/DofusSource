package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class IdolsPresetUseAction implements Action
   {
       
      
      public var presetId:uint;
      
      public function IdolsPresetUseAction()
      {
         super();
      }
      
      public static function create(param1:uint) : IdolsPresetUseAction
      {
         var _loc2_:IdolsPresetUseAction = new IdolsPresetUseAction();
         _loc2_.presetId = param1;
         return _loc2_;
      }
   }
}
