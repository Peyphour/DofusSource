package com.ankamagames.dofus.uiApi
{
   public class ExternalNotificationApi
   {
       
      
      public function ExternalNotificationApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function setMaxNotifications(param1:int) : void
      {
      }
      
      [Untrusted]
      public function setNotificationsMode(param1:int) : void
      {
      }
      
      [Untrusted]
      public function setDisplayDuration(param1:int) : void
      {
      }
      
      [Untrusted]
      public function isExternalNotificationTypeIgnored(param1:int) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function areExternalNotificationsEnabled() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getShowMode() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function canAddExternalNotification(param1:int) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function addExternalNotification(param1:int, param2:String, param3:String, param4:String, param5:String, param6:String, param7:int, param8:String, param9:String = "normal2", param10:String = "left", param11:Object = null, param12:String = "16011", param13:Boolean = false, param14:String = null, param15:Array = null) : String
      {
         return null;
      }
      
      [Untrusted]
      public function removeExternalNotification(param1:String, param2:Boolean = false) : void
      {
      }
      
      [Untrusted]
      public function resetExternalNotificationDisplayTimeout(param1:String) : void
      {
      }
   }
}
