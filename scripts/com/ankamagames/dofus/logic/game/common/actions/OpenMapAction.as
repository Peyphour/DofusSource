package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenMapAction implements Action
   {
       
      
      public var ignoreSetting:Boolean;
      
      public var fromShortcut:Boolean;
      
      public var conquest:Boolean;
      
      public function OpenMapAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false) : OpenMapAction
      {
         var _loc4_:OpenMapAction = new OpenMapAction();
         _loc4_.ignoreSetting = param1;
         _loc4_.fromShortcut = param2;
         _loc4_.conquest = param3;
         return _loc4_;
      }
   }
}
