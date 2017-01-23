package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AccessoryPreviewRequestAction implements Action
   {
       
      
      public var itemGIDs:Vector.<uint>;
      
      public function AccessoryPreviewRequestAction()
      {
         super();
      }
      
      public static function create(param1:Vector.<uint>) : AccessoryPreviewRequestAction
      {
         var _loc2_:AccessoryPreviewRequestAction = new AccessoryPreviewRequestAction();
         _loc2_.itemGIDs = param1;
         return _loc2_;
      }
   }
}
