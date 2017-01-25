package com.ankamagames.dofus.misc.utils
{
   import com.ankama.codegen.client.api.ApiClient;
   import com.ankama.codegen.client.api.CmsPollInGameApi;
   import com.ankama.codegen.client.api.event.ApiClientEvent;
   import com.ankama.codegen.client.model.CmsPollInGame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.game.common.frames.SurveyFrame;
   import com.ankamagames.dofus.misc.utils.events.ApiKeyReadyEvent;
   import com.ankamagames.dofus.network.enums.HaapiTokenTypeEnum;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.getQualifiedClassName;
   
   public class SurveyManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SurveyManager));
      
      private static const IGNORE_SURVEY_TRESHOLD_CANCELLATION:uint = 3;
      
      private static const MINIMUM_TIME_BETWEEN_SURVEYS:Number = 86400000;
      
      private static var _singleton:SurveyManager;
       
      
      private var _dataStore:DataStoreType;
      
      private var _surveys:Vector.<Survey>;
      
      private var _surveyApi:CmsPollInGameApi;
      
      private var _currentLocale:String;
      
      private var _surveyFrame:SurveyFrame;
      
      public function SurveyManager()
      {
         super();
         this._dataStore = new DataStoreType("Dofus_Surveys",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
         var _loc1_:ApiClient = new ApiClient();
         var _loc2_:String = RpcServiceCenter.getInstance().apiDomainExtension;
         _loc1_.setBasePath("https://haapi.ankama." + _loc2_ + "/json/Ankama/v2");
         this._surveyApi = new CmsPollInGameApi(_loc1_);
         this._currentLocale = LangManager.getInstance().getEntry("config.lang.current");
      }
      
      public static function getInstance() : SurveyManager
      {
         if(!_singleton)
         {
            _singleton = new SurveyManager();
         }
         return _singleton;
      }
      
      public function pullSurveys() : void
      {
         if(this.userAcceptsSurveys && !this.userAcceptedSurveyRecently)
         {
            this.getSurveysFromHaapi();
         }
      }
      
      public function checkSurveys() : void
      {
         var _loc1_:int = 0;
         if(this._surveys && !this.hasSurveyNotificationWaitingForAnswer)
         {
            _loc1_ = 0;
            while(_loc1_ < this._surveys.length)
            {
               if(this._surveys[_loc1_].readyForPlayer)
               {
                  this.addNotificationForSurvey(this._surveys[_loc1_]);
                  break;
               }
               _loc1_++;
            }
         }
      }
      
      public function markSurveyAsDone(param1:Number, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:Survey = null;
         var _loc5_:uint = 0;
         for each(_loc4_ in this._surveys)
         {
            if(_loc4_.id == param1)
            {
               _loc3_ = _loc4_.url;
               this._surveys.splice(this._surveys.indexOf(_loc4_),1);
               break;
            }
         }
         if(param2 && _loc3_)
         {
            navigateToURL(new URLRequest(_loc3_),"_blank");
            StoreDataManager.getInstance().setData(this._dataStore,"lastAcceptedSurveyDate",new Date());
         }
         else
         {
            _loc5_ = StoreDataManager.getInstance().getSetData(this._dataStore,"totalClosedSurveys",0);
            StoreDataManager.getInstance().setData(this._dataStore,"totalClosedSurveys",_loc5_++);
         }
         this.setSurveyAsDoneOnHaapi(param1);
      }
      
      private function addNotificationForSurvey(param1:Survey) : void
      {
         if(!this._surveyFrame)
         {
            this._surveyFrame = new SurveyFrame();
         }
         Kernel.getWorker().addFrame(this._surveyFrame);
         var _loc2_:String = param1.description;
         if(!_loc2_)
         {
            _loc2_ = I18n.getUiText("ui.surveys.notificationContent",[param1.title]);
         }
         var _loc3_:uint = NotificationManager.getInstance().prepareNotification(I18n.getUiText("ui.surveys.notificationTitle"),_loc2_,NotificationTypeEnum.SURVEY_INVITATION,"surveyNotification_" + param1.id);
         NotificationManager.getInstance().addButtonToNotification(_loc3_,I18n.getUiText("ui.common.refuse"),"SurveyNotificationAnswer",[param1.id,false],true,130);
         NotificationManager.getInstance().addButtonToNotification(_loc3_,I18n.getUiText("ui.common.accept"),"SurveyNotificationAnswer",[param1.id,true],true,130);
         NotificationManager.getInstance().addCallbackToNotification(_loc3_,"SurveyNotificationAnswer",[param1.id,false]);
         NotificationManager.getInstance().sendNotification(_loc3_);
      }
      
      private function get hasSurveyNotificationWaitingForAnswer() : Boolean
      {
         return Kernel.getWorker().getFrame(SurveyFrame) != null;
      }
      
      private function get userAcceptsSurveys() : Boolean
      {
         return StoreDataManager.getInstance().getSetData(this._dataStore,"totalClosedSurveys",0) <= IGNORE_SURVEY_TRESHOLD_CANCELLATION;
      }
      
      private function get userAcceptedSurveyRecently() : Boolean
      {
         var _loc1_:Date = StoreDataManager.getInstance().getData(this._dataStore,"lastAcceptedSurveyDate");
         if(!_loc1_)
         {
            return false;
         }
         return new Date().time - _loc1_.time < MINIMUM_TIME_BETWEEN_SURVEYS;
      }
      
      private function getSurveysFromHaapi() : void
      {
         HaapiKeyManager.getInstance().addEventListener(ApiKeyReadyEvent.READY,function(param1:ApiKeyReadyEvent):void
         {
            if(param1.haapiKeyType == HaapiTokenTypeEnum.HAAPI_APIKEY_GENERIC)
            {
               param1.currentTarget.removeEventListener(ApiKeyReadyEvent.READY,arguments.callee);
               _surveyApi.getApiClient().setApiKey(param1.haapiKey);
               _surveyApi.getApiClient().addEventListener(ApiClientEvent.API_CALL_RESULT,onSurveysReceived);
               _surveyApi.getApiClient().addEventListener(ApiClientEvent.API_CALL_ERROR,onSurveysError);
               _surveyApi.getApiCall("DOFUS",_currentLocale,1,42);
            }
         });
         HaapiKeyManager.getInstance().askApiKey(HaapiTokenTypeEnum.HAAPI_APIKEY_GENERIC);
      }
      
      private function setSurveyAsDoneOnHaapi(param1:Number) : void
      {
         var surveyId:Number = param1;
         HaapiKeyManager.getInstance().addEventListener(ApiKeyReadyEvent.READY,function(param1:ApiKeyReadyEvent):void
         {
            if(param1.haapiKeyType == HaapiTokenTypeEnum.HAAPI_APIKEY_GENERIC)
            {
               param1.currentTarget.removeEventListener(ApiKeyReadyEvent.READY,arguments.callee);
               _surveyApi.getApiClient().setApiKey(param1.haapiKey);
               _surveyApi.getApiClient().addEventListener(ApiClientEvent.API_CALL_RESULT,onSurveyMarkedAsDoneReceived);
               _surveyApi.getApiClient().addEventListener(ApiClientEvent.API_CALL_ERROR,onSurveyMarkedAsDoneError);
               _surveyApi.markAsReadApiCall(surveyId);
            }
         });
         HaapiKeyManager.getInstance().askApiKey(HaapiTokenTypeEnum.HAAPI_APIKEY_GENERIC);
      }
      
      private function onSurveysReceived(param1:ApiClientEvent) : void
      {
         var _loc3_:CmsPollInGame = null;
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_RESULT,this.onSurveysReceived);
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_ERROR,this.onSurveysError);
         this._surveys = new Vector.<Survey>();
         var _loc2_:Array = param1.result as Array;
         if(_loc2_ && _loc2_.length)
         {
            for each(_loc3_ in _loc2_)
            {
               this._surveys.push(new Survey(_loc3_));
            }
         }
      }
      
      protected function onSurveysError(param1:ApiClientEvent) : void
      {
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_RESULT,this.onSurveysReceived);
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_ERROR,this.onSurveysError);
         this._surveys = null;
         _log.error("Failed to retrieve surveys data, error:\n" + param1.errorMsg);
      }
      
      private function onSurveyMarkedAsDoneReceived(param1:ApiClientEvent) : void
      {
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_RESULT,this.onSurveyMarkedAsDoneReceived);
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_ERROR,this.onSurveyMarkedAsDoneError);
         Kernel.getWorker().removeFrame(this._surveyFrame);
      }
      
      private function onSurveyMarkedAsDoneError(param1:ApiClientEvent) : void
      {
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_RESULT,this.onSurveyMarkedAsDoneReceived);
         this._surveyApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_ERROR,this.onSurveyMarkedAsDoneError);
         Kernel.getWorker().removeFrame(this._surveyFrame);
         _log.error("Failed to mark survey as done, error:\n" + param1.errorMsg);
      }
   }
}
