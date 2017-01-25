package com.ankama.codegen.client.api
{
   import com.ankama.codegen.client.api.event.ApiClientEvent;
   import flash.utils.Dictionary;
   
   public class CmsPollInGameApi
   {
       
      
      private var forceImportModelList:ModelList = null;
      
      private var _apiClient:ApiClient;
      
      private var _returnObjectType:String;
      
      public function CmsPollInGameApi(param1:ApiClient)
      {
         super();
         this._apiClient = param1;
      }
      
      private static function verifyParam(param1:*) : Boolean
      {
         if(param1 is int || param1 is uint)
         {
            return true;
         }
         if(param1 is Number)
         {
            return !isNaN(param1);
         }
         return param1 != null;
      }
      
      public function getApiClient() : ApiClient
      {
         return this._apiClient;
      }
      
      public function setApiClient(param1:ApiClient) : void
      {
         this._apiClient = param1;
      }
      
      public function getApiCall(param1:String, param2:String, param3:Number, param4:Number) : void
      {
         var _loc5_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'site\' when calling get");
         }
         if(!verifyParam(param2))
         {
            throw new ApiError(400,"Missing the required parameter \'lang\' when calling get");
         }
         if(!verifyParam(param3))
         {
            throw new ApiError(400,"Missing the required parameter \'page\' when calling get");
         }
         if(!verifyParam(param4))
         {
            throw new ApiError(400,"Missing the required parameter \'count\' when calling get");
         }
         var _loc6_:String = "/Cms/PollInGame/Get".replace(/\{format\}/g,"json");
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:Dictionary = new Dictionary();
         var _loc9_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc7_["site"] = this._apiClient.parameterToString(param1);
         }
         if(verifyParam(param2))
         {
            _loc7_["lang"] = this._apiClient.parameterToString(param2);
         }
         if(verifyParam(param3))
         {
            _loc7_["page"] = this._apiClient.parameterToString(param3);
         }
         if(verifyParam(param4))
         {
            _loc7_["count"] = this._apiClient.parameterToString(param4);
         }
         var _loc10_:Array = new Array();
         var _loc11_:String = this._apiClient.selectHeaderAccept(_loc10_);
         var _loc12_:Array = new Array();
         var _loc13_:String = this._apiClient.selectHeaderContentType(_loc12_);
         var _loc14_:Array = new Array("AuthAnkamaApiKey");
         var _loc15_:Array = null;
         this._returnObjectType = "com.ankama.codegen.client.model.CmsPollInGame";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_get);
         this._apiClient.invokeAPI(_loc6_,"GET",_loc7_,_loc5_,_loc8_,_loc9_,_loc11_,_loc13_,_loc14_);
      }
      
      public function onSuccess_get(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_get);
         this._returnObjectType = "";
      }
      
      public function markAsReadApiCall(param1:Number) : void
      {
         var _loc2_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'item\' when calling markAsRead");
         }
         var _loc3_:String = "/Cms/PollInGame/MarkAsRead".replace(/\{format\}/g,"json");
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc4_["item"] = this._apiClient.parameterToString(param1);
         }
         var _loc7_:Array = new Array();
         var _loc8_:String = this._apiClient.selectHeaderAccept(_loc7_);
         var _loc9_:Array = new Array();
         var _loc10_:String = this._apiClient.selectHeaderContentType(_loc9_);
         var _loc11_:Array = new Array("AuthAnkamaApiKey");
         var _loc12_:Boolean = null;
         this._returnObjectType = "com.ankama.codegen.client.model.Boolean";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_markAsRead);
         this._apiClient.invokeAPI(_loc3_,"GET",_loc4_,_loc2_,_loc5_,_loc6_,_loc8_,_loc10_,_loc11_);
      }
      
      public function onSuccess_markAsRead(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_markAsRead);
         this._returnObjectType = "";
      }
   }
}
