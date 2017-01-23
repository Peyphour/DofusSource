package com.ankama.codegen.client.api
{
   import com.ankama.codegen.client.api.auth.ApiKeyAuth;
   import com.ankama.codegen.client.api.auth.Authentication;
   import com.ankama.codegen.client.api.auth.HttpBasicAuth;
   import com.ankama.codegen.client.api.event.ApiClientEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.globalization.DateTimeFormatter;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import mx.formatters.DateFormatter;
   import mx.utils.DescribeTypeCache;
   import mx.utils.DescribeTypeCacheRecord;
   
   public class ApiClient extends EventDispatcher
   {
       
      
      private var forceImportModelList:ModelList = null;
      
      private var _defaultHeaderMap:Dictionary;
      
      private var _debugging:Boolean = false;
      
      private var _basePath:String = "https://haapi.ankama.tst/json/Ankama/v2";
      
      private var _authentications:Dictionary;
      
      private var _dateFormat:DateTimeFormatter;
      
      private var _loader:URLLoader;
      
      public function ApiClient()
      {
         this._defaultHeaderMap = new Dictionary();
         super();
         this._dateFormat = new DateTimeFormatter("fr-FR");
         this._dateFormat.setDateTimePattern("yyyy-MM-dd\'T\'HH:mm:ss.SSSZ");
         this._authentications = new Dictionary();
         this._authentications["AuthAnkamaApiKey"] = new ApiKeyAuth("header","APIKEY");
         this._authentications["AuthPassword"] = new HttpBasicAuth();
      }
      
      public function getBasePath() : String
      {
         return this._basePath;
      }
      
      public function setBasePath(param1:String) : ApiClient
      {
         this._basePath = param1;
         return this;
      }
      
      public function setUserAgent(param1:String) : ApiClient
      {
         this.addDefaultHeader("User-Agent",param1);
         return this;
      }
      
      public function addDefaultHeader(param1:String, param2:String) : ApiClient
      {
         this._defaultHeaderMap[param1] = param2;
         return this;
      }
      
      public function getAuthentications() : Dictionary
      {
         return this._authentications;
      }
      
      public function getAuthentication(param1:String) : Authentication
      {
         return this._authentications[param1];
      }
      
      public function setUsername(param1:String) : void
      {
         var _loc2_:Authentication = null;
         for each(_loc2_ in this._authentications)
         {
            if(_loc2_ is HttpBasicAuth)
            {
               HttpBasicAuth(_loc2_).setUsername(param1);
               return;
            }
         }
         throw new Error("No HTTP basic authentication configured!");
      }
      
      public function setPassword(param1:String) : void
      {
         var _loc2_:Authentication = null;
         for each(_loc2_ in this._authentications)
         {
            if(_loc2_ is HttpBasicAuth)
            {
               HttpBasicAuth(_loc2_).setPassword(param1);
               return;
            }
         }
         throw new Error("No HTTP basic authentication configured!");
      }
      
      public function setApiKey(param1:String) : void
      {
         var _loc2_:Authentication = null;
         for each(_loc2_ in this._authentications)
         {
            if(_loc2_ is ApiKeyAuth)
            {
               ApiKeyAuth(_loc2_).setApiKey(param1);
               return;
            }
         }
         throw new Error("No API key authentication configured!");
      }
      
      public function setApiKeyPrefix(param1:String) : void
      {
         var _loc2_:Authentication = null;
         for each(_loc2_ in this._authentications)
         {
            if(_loc2_ is ApiKeyAuth)
            {
               ApiKeyAuth(_loc2_).setApiKeyPrefix(param1);
               return;
            }
         }
         throw new Error("No API key authentication configured!");
      }
      
      public function getDateFormat() : DateTimeFormatter
      {
         return this._dateFormat;
      }
      
      public function setDateFormat(param1:DateTimeFormatter) : ApiClient
      {
         this._dateFormat = param1;
         return this;
      }
      
      public function parseDate(param1:String) : String
      {
         var date:Date = null;
         var str:String = param1;
         try
         {
            date = new Date(Date.parse(str));
            return this._dateFormat.formatUTC(date);
         }
         catch(e:Error)
         {
            throw new Error(e);
         }
         return "";
      }
      
      public function formatDate(param1:Date) : String
      {
         return this._dateFormat.formatUTC(param1);
      }
      
      public function parameterToString(param1:Object) : String
      {
         var _loc2_:* = null;
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return "";
         }
         if(param1 is Date)
         {
            return this.formatDate(param1 as Date);
         }
         if(param1 is Dictionary)
         {
            _loc2_ = "";
            for each(_loc3_ in Dictionary(param1))
            {
               if(_loc2_.length > 0)
               {
                  _loc2_ = _loc2_ + ",";
               }
               _loc2_ = _loc2_ + String(_loc3_);
            }
            return _loc2_;
         }
         return String(param1);
      }
      
      public function selectHeaderAccept(param1:Array) : String
      {
         if(param1.length == 0)
         {
            return null;
         }
         if(StringUtil.containsIgnoreCase(param1,"application/json"))
         {
            return "application/json";
         }
         return StringUtil.join(param1,",");
      }
      
      public function selectHeaderContentType(param1:Array) : String
      {
         if(param1.length == 0)
         {
            return "application/json";
         }
         if(StringUtil.containsIgnoreCase(param1,"application/json"))
         {
            return "application/json";
         }
         return param1[0];
      }
      
      public function escapeString(param1:String) : String
      {
         var str:String = param1;
         try
         {
            return encodeURIComponent(str.replace(/\+/g,"%20"));
         }
         catch(e:Error)
         {
            return str;
         }
         return str;
      }
      
      public function invokeAPI(param1:String, param2:String, param3:Dictionary, param4:Object, param5:Dictionary, param6:Dictionary, param7:String, param8:String, param9:Array) : void
      {
         var _loc12_:* = null;
         var _loc13_:URLRequestHeader = null;
         var _loc14_:ClientResponse = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         this.updateParamsForAuth(param9,param3,param5);
         var _loc10_:URLRequest = new URLRequest();
         var _loc11_:* = "";
         this._loader = new URLLoader();
         this._loader.addEventListener(Event.COMPLETE,this.onRequestComplete);
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         for(_loc12_ in param3)
         {
            _loc15_ = param3[_loc12_];
            if(_loc15_ != null)
            {
               if(_loc11_.length == 0)
               {
                  _loc11_ = _loc11_ + "?";
               }
               else
               {
                  _loc11_ = _loc11_ + "&";
               }
               _loc11_ = _loc11_ + this.escapeString(_loc12_) + "=" + this.escapeString(_loc15_);
            }
         }
         _loc10_.url = this._basePath + param1 + _loc11_;
         _loc10_.contentType = param8;
         _loc10_.method = param2;
         for(_loc12_ in param5)
         {
            _loc13_ = new URLRequestHeader(_loc12_,param5[_loc12_]);
            _loc10_.requestHeaders.push(_loc13_);
         }
         for(_loc12_ in this._defaultHeaderMap)
         {
            if(param5[_loc12_] === undefined)
            {
               _loc13_ = new URLRequestHeader(_loc12_,this._defaultHeaderMap[_loc12_]);
               _loc10_.requestHeaders.push(_loc13_);
            }
         }
         if(param2 == URLRequestMethod.GET)
         {
            _loc10_.method = param2;
         }
         else if(param2 == URLRequestMethod.POST)
         {
            if(param8.indexOf("application/x-www-form-urlencoded") == 0)
            {
               _loc16_ = this.getXWWWFormUrlencodedParams(param6);
               _loc10_.data = _loc16_;
            }
            else
            {
               _loc10_.data = JsonUtil.toJson(param4);
            }
         }
         else if(param2 == URLRequestMethod.PUT)
         {
            if(param8 == "application/x-www-form-urlencoded")
            {
               _loc16_ = this.getXWWWFormUrlencodedParams(param6);
               _loc10_.data = _loc16_;
            }
            else
            {
               _loc10_.data = JsonUtil.toJson(param4);
            }
         }
         else if(param2 == URLRequestMethod.DELETE)
         {
            if(param8 == "application/x-www-form-urlencoded" || param4 == null)
            {
               _loc16_ = this.getXWWWFormUrlencodedParams(param6);
               _loc10_.data = _loc16_;
            }
            else
            {
               _loc10_.data = JsonUtil.toJson(param4);
            }
         }
         else
         {
            throw new ApiError(500,"unknown method type " + param2);
         }
         this._loader.load(_loc10_);
      }
      
      public function deserialize(param1:*, param2:String) : void
      {
         var _loc3_:* = undefined;
         if(param2 != "null" && param2 != "" && ApplicationDomain.currentDomain.hasDefinition(param2))
         {
            _loc3_ = this.getTypedObject(param1,param2);
         }
         else
         {
            _loc3_ = param1;
         }
         dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_RESULT,_loc3_,""));
      }
      
      private function getTypedObject(param1:*, param2:String) : *
      {
         var _loc7_:XML = null;
         var _loc8_:Date = null;
         var _loc9_:Array = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         if(!param1)
         {
            return;
         }
         if(param1.hasOwnProperty("length") && param1.length > 0)
         {
            _loc9_ = new Array();
            for each(_loc10_ in param1)
            {
               _loc9_.push(this.getTypedObject(_loc10_,param2));
            }
            return _loc9_;
         }
         var _loc3_:Class = getDefinitionByName(param2) as Class;
         var _loc4_:* = new _loc3_();
         var _loc5_:DescribeTypeCacheRecord = DescribeTypeCache.describeType(_loc4_);
         var _loc6_:XMLList = _loc5_.typeDescription.variable;
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.@type == "Date")
            {
               _loc8_ = DateFormatter.parseDateString(param1[_loc7_.@name]);
               _loc4_[_loc7_.@name] = _loc8_;
            }
            else if(_loc7_.@type == "flash.utils::Dictionary")
            {
               for(_loc11_ in param1[_loc7_.@name])
               {
                  _loc4_[_loc7_.@name] = new Dictionary();
                  _loc4_[_loc7_.@name][_loc11_] = param1[_loc7_.@name][_loc11_];
               }
            }
            else if(_loc7_.@type.indexOf("com.ankama.codegen.client.model") != -1 && (ApplicationDomain.currentDomain.hasDefinition(param2) && param1[_loc7_.@name] != null))
            {
               _loc4_[_loc7_.@name] = this.getTypedObject(param1[_loc7_.@name],_loc7_.@type);
            }
            else if(param1)
            {
               _loc4_[_loc7_.@name] = param1[_loc7_.@name];
            }
         }
         return _loc4_;
      }
      
      private function updateParamsForAuth(param1:Array, param2:Dictionary, param3:Dictionary) : void
      {
         var _loc4_:String = null;
         var _loc5_:Authentication = null;
         for each(_loc4_ in param1)
         {
            _loc5_ = this._authentications[_loc4_];
            if(_loc5_ == null)
            {
               throw new Error("Authentication undefined: " + _loc4_);
            }
            _loc5_.applyToParams(param2,param3);
         }
      }
      
      private function onRequestComplete(param1:Event) : void
      {
         var de:Object = null;
         var e:Event = param1;
         var loaderComplete:URLLoader = URLLoader(e.currentTarget);
         try
         {
            de = JsonUtil.fromJson(loaderComplete.data);
            dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_SUCCESS,de));
         }
         catch(e:Error)
         {
            dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,"Can\'t decode string, JSON required !!"));
         }
         if(de == null)
         {
            dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,"No information received from the server ..."));
         }
         else if(de.hasOwnProperty("error") && de.error != null)
         {
            switch(typeof de.error)
            {
               case "string":
               case "number":
                  dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,"ERROR HAAPI API SERVICE: " + de.error + (de.type != null?", " + de.type:"") + (de.message != null?", " + de.message:"")));
                  break;
               case "object":
                  dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,(de.error.type != null?de.error.type:de.error.code) + " -> " + de.error.message));
                  break;
               default:
                  dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,"ERROR HAAPI API SERVICE: " + de.error));
            }
         }
      }
      
      private function onError(param1:Event) : void
      {
         var _loc2_:String = "catched an Error type : " + param1.type;
         if(param1 is ErrorEvent)
         {
            dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,", " + ErrorEvent(param1).text + " " + param1.target.data));
         }
         else
         {
            dispatchEvent(new ApiClientEvent(ApiClientEvent.API_CALL_ERROR,null,"HAAPI API UNKNOW ERROR " + _loc2_));
         }
      }
      
      private function getXWWWFormUrlencodedParams(param1:Dictionary) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:* = "";
         for(_loc3_ in param1)
         {
            _loc5_ = this.parameterToString(_loc3_);
            _loc6_ = this.parameterToString(param1[_loc3_]);
            try
            {
               _loc2_ = _loc2_ + encodeURIComponent(_loc5_) + "=" + encodeURIComponent(_loc6_) + "&";
            }
            catch(e:Error)
            {
               continue;
            }
         }
         _loc4_ = _loc2_.toString();
         if(_loc4_.charAt(_loc4_.length - 1) == "&")
         {
            _loc4_ = _loc4_.substring(0,_loc4_.length - 1);
         }
         return _loc4_;
      }
   }
}
