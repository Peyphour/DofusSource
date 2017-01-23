package com.ankamagames.dofus.themes.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ThemeListRequestAction implements Action
   {
       
      
      public var listUrl:String;
      
      public function ThemeListRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : ThemeListRequestAction
      {
         var _loc2_:ThemeListRequestAction = new ThemeListRequestAction();
         _loc2_.listUrl = param1;
         return _loc2_;
      }
   }
}
