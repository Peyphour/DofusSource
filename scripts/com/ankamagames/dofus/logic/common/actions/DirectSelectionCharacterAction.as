package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DirectSelectionCharacterAction implements Action
   {
       
      
      public var serverId:uint;
      
      public var characterId:Number;
      
      public function DirectSelectionCharacterAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Number) : DirectSelectionCharacterAction
      {
         var _loc3_:DirectSelectionCharacterAction = new DirectSelectionCharacterAction();
         _loc3_.serverId = param1;
         _loc3_.characterId = param2;
         return _loc3_;
      }
   }
}
