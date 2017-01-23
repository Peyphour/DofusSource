package com.ankamagames.dofus.uiApi
{
   public class ConfigApi
   {
       
      
      public function ConfigApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getConfigProperty(param1:String, param2:String) : *
      {
         return null;
      }
      
      [Untrusted]
      public function setConfigProperty(param1:String, param2:String, param3:*) : void
      {
      }
      
      [Untrusted]
      public function resetConfigProperty(param1:String, param2:String) : void
      {
      }
      
      [Untrusted]
      public function createOptionManager(param1:String) : Object
      {
         return null;
      }
      
      [Trusted]
      public function getAllThemes() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getCurrentTheme() : String
      {
         return null;
      }
      
      [Trusted]
      public function isOptionalFeatureActive(param1:int) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function getServerConstant(param1:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getExternalNotificationOptions(param1:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function setExternalNotificationOptions(param1:int, param2:Object) : void
      {
      }
      
      [Untrusted]
      public function setDebugMode(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function getDebugMode() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function debugFileExists() : Boolean
      {
         return false;
      }
   }
}
