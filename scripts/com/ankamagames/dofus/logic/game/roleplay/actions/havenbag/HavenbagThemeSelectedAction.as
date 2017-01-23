package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagThemeSelectedAction implements Action
   {
       
      
      public var themeId:int;
      
      public function HavenbagThemeSelectedAction()
      {
         super();
      }
      
      public static function create(param1:int) : HavenbagThemeSelectedAction
      {
         var _loc2_:HavenbagThemeSelectedAction = new HavenbagThemeSelectedAction();
         _loc2_.themeId = param1;
         return _loc2_;
      }
   }
}
