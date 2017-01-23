package com.ankamagames.dofus.logic.connection.actions
{
   public class LoginValidationWithSteamAction extends LoginValidationAction
   {
       
      
      public function LoginValidationWithSteamAction()
      {
         super();
      }
      
      public static function create() : LoginValidationWithSteamAction
      {
         var _loc1_:LoginValidationWithSteamAction = new LoginValidationWithSteamAction();
         _loc1_.password = "";
         _loc1_.username = "";
         _loc1_.autoSelectServer = false;
         return _loc1_;
      }
   }
}
