package com.ankamagames.dofus.themes.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ThemeDeleteRequestAction implements Action
   {
       
      
      public var themeDirectory:String;
      
      public function ThemeDeleteRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : ThemeDeleteRequestAction
      {
         var _loc2_:ThemeDeleteRequestAction = new ThemeDeleteRequestAction();
         _loc2_.themeDirectory = param1;
         return _loc2_;
      }
   }
}
