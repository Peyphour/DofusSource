package com.ankamagames.dofus.uiApi
{
   public class SecurityApi
   {
       
      
      public function SecurityApi()
      {
         super();
      }
      
      [Trusted]
      public function askSecureModeCode(param1:Function) : void
      {
      }
      
      [Trusted]
      public function sendSecureModeCode(param1:String, param2:Function, param3:String = null) : void
      {
      }
      
      [Trusted]
      public function SecureModeisActive() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function setShieldLevel(param1:uint) : void
      {
      }
      
      [Trusted]
      public function getShieldLevel() : uint
      {
         return 0;
      }
   }
}
