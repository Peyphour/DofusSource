package com.ankama.codegen.client.api
{
   import com.ankama.codegen.client.api.event.ApiClientEvent;
   import com.ankama.codegen.client.model.CharacterAddScreenshotResponse;
   import com.ankama.codegen.client.model.CharacterExportResponse;
   import flash.utils.Dictionary;
   
   public class CharacterApi
   {
       
      
      private var forceImportModelList:ModelList = null;
      
      private var _apiClient:ApiClient;
      
      private var _returnObjectType:String;
      
      public function CharacterApi(param1:ApiClient)
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
      
      public function addScreenshotApiCall(param1:String, param2:String, param3:String, param4:Number, param5:Number, param6:Number, param7:String, param8:String) : void
      {
         var _loc9_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'screen\' when calling addScreenshot");
         }
         if(!verifyParam(param2))
         {
            throw new ApiError(400,"Missing the required parameter \'title\' when calling addScreenshot");
         }
         if(!verifyParam(param3))
         {
            throw new ApiError(400,"Missing the required parameter \'lang\' when calling addScreenshot");
         }
         if(!verifyParam(param4))
         {
            throw new ApiError(400,"Missing the required parameter \'character\' when calling addScreenshot");
         }
         if(!verifyParam(param5))
         {
            throw new ApiError(400,"Missing the required parameter \'server\' when calling addScreenshot");
         }
         if(!verifyParam(param6))
         {
            throw new ApiError(400,"Missing the required parameter \'map\' when calling addScreenshot");
         }
         var _loc10_:String = "/Character/AddScreenshot".replace(/\{format\}/g,"json");
         var _loc11_:Dictionary = new Dictionary();
         var _loc12_:Dictionary = new Dictionary();
         var _loc13_:Dictionary = new Dictionary();
         var _loc14_:Array = new Array();
         var _loc15_:String = this._apiClient.selectHeaderAccept(_loc14_);
         var _loc16_:Array = new Array("application/x-www-form-urlencoded");
         var _loc17_:String = this._apiClient.selectHeaderContentType(_loc16_);
         if(verifyParam(param1))
         {
            _loc13_["screen"] = this._apiClient.parameterToString(param1);
         }
         if(verifyParam(param2))
         {
            _loc13_["title"] = this._apiClient.parameterToString(param2);
         }
         if(verifyParam(param7))
         {
            _loc13_["description"] = this._apiClient.parameterToString(param7);
         }
         if(verifyParam(param3))
         {
            _loc13_["lang"] = this._apiClient.parameterToString(param3);
         }
         if(verifyParam(param8))
         {
            _loc13_["type"] = this._apiClient.parameterToString(param8);
         }
         if(verifyParam(param4))
         {
            _loc13_["character"] = this._apiClient.parameterToString(param4);
         }
         if(verifyParam(param5))
         {
            _loc13_["server"] = this._apiClient.parameterToString(param5);
         }
         if(verifyParam(param6))
         {
            _loc13_["map"] = this._apiClient.parameterToString(param6);
         }
         var _loc18_:Array = new Array("AuthAnkamaApiKey");
         var _loc19_:CharacterAddScreenshotResponse = null;
         this._returnObjectType = "com.ankama.codegen.client.model.CharacterAddScreenshotResponse";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_addScreenshot);
         this._apiClient.invokeAPI(_loc10_,"POST",_loc11_,_loc9_,_loc12_,_loc13_,_loc15_,_loc17_,_loc18_);
      }
      
      public function onSuccess_addScreenshot(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_addScreenshot);
         this._returnObjectType = "";
      }
      
      public function charactersApiCall(param1:Number) : void
      {
         var _loc2_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'accountId\' when calling characters");
         }
         var _loc3_:String = "/Character/Characters".replace(/\{format\}/g,"json");
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc4_["account_id"] = this._apiClient.parameterToString(param1);
         }
         var _loc7_:Array = new Array();
         var _loc8_:String = this._apiClient.selectHeaderAccept(_loc7_);
         var _loc9_:Array = new Array();
         var _loc10_:String = this._apiClient.selectHeaderContentType(_loc9_);
         var _loc11_:Array = new Array("AuthAnkamaApiKey");
         var _loc12_:Array = null;
         this._returnObjectType = "com.ankama.codegen.client.model.Character";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_characters);
         this._apiClient.invokeAPI(_loc3_,"GET",_loc4_,_loc2_,_loc5_,_loc6_,_loc8_,_loc10_,_loc11_);
      }
      
      public function onSuccess_characters(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_characters);
         this._returnObjectType = "";
      }
      
      public function exportApiCall(param1:String) : void
      {
         var _loc2_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'sJson\' when calling export");
         }
         var _loc3_:String = "/Character/Export".replace(/\{format\}/g,"json");
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Array = new Array();
         var _loc8_:String = this._apiClient.selectHeaderAccept(_loc7_);
         var _loc9_:Array = new Array("application/x-www-form-urlencoded");
         var _loc10_:String = this._apiClient.selectHeaderContentType(_loc9_);
         if(verifyParam(param1))
         {
            _loc6_["sJson"] = this._apiClient.parameterToString(param1);
         }
         var _loc11_:Array = new Array();
         var _loc12_:CharacterExportResponse = null;
         this._returnObjectType = "com.ankama.codegen.client.model.CharacterExportResponse";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_export);
         this._apiClient.invokeAPI(_loc3_,"POST",_loc4_,_loc2_,_loc5_,_loc6_,_loc8_,_loc10_,_loc11_);
      }
      
      public function onSuccess_export(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_export);
         this._returnObjectType = "";
      }
      
      public function getEntityLooksApiCall(param1:Number) : void
      {
         var _loc2_:Object = null;
         if(!verifyParam(param1))
         {
            throw new ApiError(400,"Missing the required parameter \'accountId\' when calling getEntityLooks");
         }
         var _loc3_:String = "/Character/GetEntityLooks".replace(/\{format\}/g,"json");
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Dictionary = new Dictionary();
         if(verifyParam(param1))
         {
            _loc4_["account_id"] = this._apiClient.parameterToString(param1);
         }
         var _loc7_:Array = new Array();
         var _loc8_:String = this._apiClient.selectHeaderAccept(_loc7_);
         var _loc9_:Array = new Array();
         var _loc10_:String = this._apiClient.selectHeaderContentType(_loc9_);
         var _loc11_:Array = new Array();
         var _loc12_:Array = null;
         this._returnObjectType = "com.ankama.codegen.client.model.EntityLook";
         this._apiClient.addEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_getEntityLooks);
         this._apiClient.invokeAPI(_loc3_,"GET",_loc4_,_loc2_,_loc5_,_loc6_,_loc8_,_loc10_,_loc11_);
      }
      
      public function onSuccess_getEntityLooks(param1:ApiClientEvent) : void
      {
         this._apiClient.deserialize(param1.result,this._returnObjectType);
         this._apiClient.removeEventListener(ApiClientEvent.API_CALL_SUCCESS,this.onSuccess_getEntityLooks);
         this._returnObjectType = "";
      }
   }
}
