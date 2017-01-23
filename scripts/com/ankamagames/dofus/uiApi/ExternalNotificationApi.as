package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationRequest;
   import com.ankamagames.dofus.externalnotification.enums.ExternalNotificationModeEnum;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class ExternalNotificationApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function ExternalNotificationApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(ExternalNotificationApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function setMaxNotifications(param1:int) : void
      {
         ExternalNotificationManager.getInstance().setMaxNotifications(param1);
      }
      
      [Untrusted]
      public function setNotificationsMode(param1:int) : void
      {
         ExternalNotificationManager.getInstance().setNotificationsMode(param1);
      }
      
      [Untrusted]
      public function setDisplayDuration(param1:int) : void
      {
         ExternalNotificationManager.getInstance().setDisplayDuration(param1);
      }
      
      [Untrusted]
      public function isExternalNotificationTypeIgnored(param1:int) : Boolean
      {
         return ExternalNotificationManager.getInstance().isExternalNotificationTypeIgnored(param1);
      }
      
      [Untrusted]
      public function areExternalNotificationsEnabled() : Boolean
      {
         return ExternalNotificationManager.getInstance().notificationsEnabled;
      }
      
      [Untrusted]
      public function getShowMode() : int
      {
         return ExternalNotificationManager.getInstance().showMode;
      }
      
      [Untrusted]
      public function canAddExternalNotification(param1:int) : Boolean
      {
         if(BuildInfos.BUILD_TYPE != BuildTypeEnum.RELEASE && XmlConfig.getInstance().getBooleanEntry("config.dev.externalNotiflood"))
         {
            return true;
         }
         return ExternalNotificationManager.getInstance().canAddExternalNotification(param1);
      }
      
      [Untrusted]
      public function addExternalNotification(param1:int, param2:String, param3:String, param4:String, param5:String, param6:String, param7:int, param8:String, param9:String = "normal2", param10:String = "left", param11:Object = null, param12:String = "16011", param13:Boolean = false, param14:String = null, param15:Array = null) : String
      {
         var _loc16_:Object = {
            "title":param4,
            "message":param5,
            "iconPath":param6,
            "icon":param7,
            "iconBg":param8,
            "css":param9,
            "cssClass":param10,
            "entityContactData":param11
         };
         var _loc17_:ExternalNotificationRequest = new ExternalNotificationRequest(param1,ExternalNotificationManager.getInstance().clientId,ExternalNotificationManager.getInstance().otherClientsIds,param2,!!param13?int(ExternalNotificationModeEnum.ALWAYS):int(ExternalNotificationManager.getInstance().showMode),param3,_loc16_,param12,ExternalNotificationManager.getInstance().notificationPlaySound(param1),ExternalNotificationManager.getInstance().notificationNotify(param1),param14,param15);
         ExternalNotificationManager.getInstance().handleNotificationRequest(_loc17_);
         return _loc17_.instanceId;
      }
      
      [Untrusted]
      public function removeExternalNotification(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Array = param1.split("#");
         ExternalNotificationManager.getInstance().closeExternalNotification(_loc3_[0],_loc3_[1],param2);
      }
      
      [Untrusted]
      public function resetExternalNotificationDisplayTimeout(param1:String) : void
      {
         var _loc2_:Array = param1.split("#");
         ExternalNotificationManager.getInstance().resetNotificationDisplayTimeout(_loc2_[0],_loc2_[1]);
      }
   }
}
