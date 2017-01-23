package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   
   public class BindsApi
   {
       
      
      public function BindsApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getBindList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getShortcut() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getShortcutBind(param1:String, param2:Boolean = false) : Bind
      {
         return null;
      }
      
      [Untrusted]
      public function getShortcutsFromKeyCode(param1:uint) : Shortcut
      {
         return null;
      }
      
      [Untrusted]
      public function setShortcutBind(param1:String, param2:String, param3:Boolean, param4:Boolean, param5:Boolean) : void
      {
      }
      
      [Untrusted]
      public function removeShortcutBind(param1:String) : void
      {
      }
      
      [Untrusted]
      public function getShortcutBindStr(param1:String, param2:Boolean = false) : String
      {
         return null;
      }
      
      [Trusted]
      public function resetAllBinds() : void
      {
      }
      
      [Untrusted]
      public function availableKeyboards() : Array
      {
         return null;
      }
      
      [Trusted]
      public function changeKeyboard(param1:String) : void
      {
      }
      
      [Untrusted]
      public function getCurrentLocale() : String
      {
         return null;
      }
      
      [Untrusted]
      public function bindIsRegister(param1:Bind) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function bindIsPermanent(param1:Bind) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function bindIsDisabled(param1:Bind) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function setBindDisabled(param1:Bind, param2:Boolean) : void
      {
      }
      
      [Untrusted]
      public function getRegisteredBind(param1:Bind) : Bind
      {
         return null;
      }
      
      [Untrusted]
      public function getShortcutByName(param1:String) : Shortcut
      {
         return null;
      }
      
      [Trusted]
      public function setShortcutEnabled(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function getIsShortcutEnabled() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function disableShortcut(param1:String, param2:Boolean) : void
      {
      }
      
      [Untrusted]
      public function enableShortcutKey(param1:uint, param2:uint, param3:Boolean) : void
      {
      }
   }
}
