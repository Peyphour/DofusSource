package com.ankamagames.dofus.uiApi
{
   public class NotificationApi
   {
       
      
      public function NotificationApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function showNotification(param1:String, param2:String, param3:uint = 0) : void
      {
      }
      
      [Untrusted]
      public function prepareNotification(param1:String, param2:String, param3:uint = 0, param4:String = "", param5:Boolean = false) : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function addButtonToNotification(param1:uint, param2:String, param3:String, param4:Object = null, param5:Boolean = false, param6:Number = 0, param7:Number = 0, param8:String = "action") : void
      {
      }
      
      [Untrusted]
      public function addCallbackToNotification(param1:uint, param2:String, param3:Object = null, param4:String = "action") : void
      {
      }
      
      [Untrusted]
      public function addImageToNotification(param1:uint, param2:String, param3:Number = 0, param4:Number = 0, param5:Number = -1, param6:Number = -1, param7:String = "", param8:String = "") : void
      {
      }
      
      [Untrusted]
      public function addTimerToNotification(param1:uint, param2:uint, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true) : void
      {
      }
      
      [Untrusted]
      public function sendNotification(param1:int = -1) : void
      {
      }
      
      [Untrusted]
      public function clearAllNotification() : void
      {
      }
   }
}
