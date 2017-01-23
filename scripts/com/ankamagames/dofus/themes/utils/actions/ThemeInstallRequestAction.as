package com.ankamagames.dofus.themes.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ThemeInstallRequestAction implements Action
   {
       
      
      public var url:String;
      
      public function ThemeInstallRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : ThemeInstallRequestAction
      {
         var _loc2_:ThemeInstallRequestAction = new ThemeInstallRequestAction();
         _loc2_.url = param1;
         return _loc2_;
      }
   }
}
