package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   
   public class SecurityApi implements IApi
   {
       
      
      public function SecurityApi()
      {
         super();
      }
      
      [Trusted]
      public function askSecureModeCode(param1:Function) : void
      {
         SecureModeManager.getInstance().askCode(param1);
      }
      
      [Trusted]
      public function sendSecureModeCode(param1:String, param2:Function, param3:String = null) : void
      {
         SecureModeManager.getInstance().computerName = param3;
         SecureModeManager.getInstance().sendCode(param1,param2);
      }
      
      [Trusted]
      public function SecureModeisActive() : Boolean
      {
         return SecureModeManager.getInstance().active;
      }
      
      [Trusted]
      public function setShieldLevel(param1:uint) : void
      {
         SecureModeManager.getInstance().shieldLevel = param1;
      }
      
      [Trusted]
      public function getShieldLevel() : uint
      {
         return SecureModeManager.getInstance().shieldLevel;
      }
   }
}
