package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class IdolsPresetSaveAction implements Action
   {
       
      
      public var presetId:uint;
      
      public var iconId:uint;
      
      public var idolsIds:Vector.<uint>;
      
      public function IdolsPresetSaveAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Vector.<uint>) : IdolsPresetSaveAction
      {
         var _loc4_:IdolsPresetSaveAction = new IdolsPresetSaveAction();
         _loc4_.presetId = param1;
         _loc4_.iconId = param2;
         _loc4_.idolsIds = param3;
         return _loc4_;
      }
   }
}
