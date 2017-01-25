package com.ankama.codegen.client.api
{
   import com.ankama.codegen.client.api.event.ApiClientEvent;
   import flash.utils.Dictionary;
   
   public class KardApi
   {
       
      
      private var forceImportModelList:ModelList = null;
      
      private var _apiClient:ApiClient;
      
      private var _returnObjectType:String;
      
      public function KardApi(param1:ApiClient)
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
      
      public function consumeByCodeApiCall(param1:String, param2:String, param3:Number) : void
      {
         var _loc4_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'lang\' when calling consumeByCode");
         }
         if(!verifyParam(param2))
         {
            throw new ApiError(400,"Missing the required parameter \'code\' when calling consumeByCode");
         }
         var _loc5_:String = "/Kard/ConsumeByCode".replace(/\{format\}/g,"json");
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc6_["lang"] = this._apiClient.parameterToString(param1);
         }
         if(verifyParam(param2))
         {
            _loc6_["code"] = this._apiClient.parameterToString(param2);
         }
         if(verifyParam(param3))
         {
            _loc6_["game_id"] = this._apiClient.parameterToString(param3);
         }
         var _loc9_:Array = new Array();
         var _loc10_:String = this._apiClient.selectHeaderAccept(_loc9_);
         var _loc11_:Array = new Array();
         var _loc12_:String = this._apiClient.selectHeaderContentType(_loc11_);
         var _loc13_:Array = new Array("AuthAnkamaApiKey");
         var _loc14_:Array = null;
         this._returnObjectType = "com.ankama.codegen.client.model.KardKard";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_consumeByCode);
         this._apiClient.invokeAPI(_loc5_,"GET",_loc6_,_loc4_,_loc7_,_loc8_,_loc10_,_loc12_,_loc13_);
      }
      
      public function onSuccess_consumeByCode(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_consumeByCode);
         this._returnObjectType = "";
      }
      
      public function consumeByIdApiCall(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'lang\' when calling consumeById");
         }
         if(!verifyParam(param2))
         {
            throw new ApiError(400,"Missing the required parameter \'id\' when calling consumeById");
         }
         var _loc5_:String = "/Kard/ConsumeById".replace(/\{format\}/g,"json");
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc6_["lang"] = this._apiClient.parameterToString(param1);
         }
         if(verifyParam(param2))
         {
            _loc6_["id"] = this._apiClient.parameterToString(param2);
         }
         if(verifyParam(param3))
         {
            _loc6_["game_id"] = this._apiClient.parameterToString(param3);
         }
         var _loc9_:Array = new Array();
         var _loc10_:String = this._apiClient.selectHeaderAccept(_loc9_);
         var _loc11_:Array = new Array();
         var _loc12_:String = this._apiClient.selectHeaderContentType(_loc11_);
         var _loc13_:Array = new Array("AuthAnkamaApiKey");
         var _loc14_:Array = null;
         this._returnObjectType = "com.ankama.codegen.client.model.KardKard";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_consumeById);
         this._apiClient.invokeAPI(_loc5_,"GET",_loc6_,_loc4_,_loc7_,_loc8_,_loc10_,_loc12_,_loc13_);
      }
      
      public function onSuccess_consumeById(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_consumeById);
         this._returnObjectType = "";
      }
      
      public function consumeByOrderIdApiCall(param1:String, param2:Number) : void
      {
         var _loc3_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'lang\' when calling consumeByOrderId");
         }
         if(!verifyParam(param2))
         {
            throw new ApiError(400,"Missing the required parameter \'orderId\' when calling consumeByOrderId");
         }
         var _loc4_:String = "/Kard/ConsumeByOrderId".replace(/\{format\}/g,"json");
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc5_["lang"] = this._apiClient.parameterToString(param1);
         }
         if(verifyParam(param2))
         {
            _loc5_["order_id"] = this._apiClient.parameterToString(param2);
         }
         var _loc8_:Array = new Array();
         var _loc9_:String = this._apiClient.selectHeaderAccept(_loc8_);
         var _loc10_:Array = new Array();
         var _loc11_:String = this._apiClient.selectHeaderContentType(_loc10_);
         var _loc12_:Array = new Array("AuthAnkamaApiKey");
         var _loc13_:Array = null;
         this._returnObjectType = "com.ankama.codegen.client.model.KardKard";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_consumeByOrderId);
         this._apiClient.invokeAPI(_loc4_,"GET",_loc5_,_loc3_,_loc6_,_loc7_,_loc9_,_loc11_,_loc12_);
      }
      
      public function onSuccess_consumeByOrderId(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_consumeByOrderId);
         this._returnObjectType = "";
      }
   }
}
