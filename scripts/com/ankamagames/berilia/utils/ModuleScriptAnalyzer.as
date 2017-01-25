package com.ankamagames.berilia.utils
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.web.HttpServer;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSwfAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.ASwf;
   import com.ankamagames.jerakine.types.Uri;
   import flash.filesystem.File;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class ModuleScriptAnalyzer
   {
      
      private static var _actionList:Dictionary;
      
      private static var _apiList:Dictionary;
      
      private static var _hookList:Dictionary;
       
      
      private var _loader:IResourceLoader;
      
      private var _actions:Array;
      
      private var _hooks:Array;
      
      private var _apis:Array;
      
      private var _readyFct:Function;
      
      public function ModuleScriptAnalyzer(param1:UiModule, param2:Function, param3:ApplicationDomain = null, param4:String = "")
      {
         var _loc5_:Uri = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._actions = [];
         this._hooks = [];
         this._apis = [];
         super();
         if(!_actionList)
         {
            _actionList = new Dictionary();
            _apiList = new Dictionary();
            _hookList = new Dictionary();
         }
         this._readyFct = param2;
         if(!param3)
         {
            if(param1)
            {
               _loc6_ = param1.script;
            }
            else
            {
               _loc6_ = param4;
            }
            if(ApplicationDomain.currentDomain.hasDefinition("flash.net.ServerSocket"))
            {
               _loc7_ = File.applicationDirectory.nativePath.split("\\").join("/");
               if(_loc6_.indexOf(_loc7_) != -1)
               {
                  _loc6_ = _loc6_.substr(_loc6_.indexOf(_loc7_) + _loc7_.length);
               }
               _loc6_ = HttpServer.getInstance().getUrlTo(_loc6_);
               _loc5_ = new Uri(_loc6_);
               this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onSwfLoaded);
               this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onSwfFailed);
               this._loader.load(_loc5_,null,AdvancedSwfAdapter,true);
            }
            else
            {
               throw new Error("Need Air 2 to analyze module script");
            }
         }
         else
         {
            this.process(param3);
            setTimeout(param2,1);
         }
      }
      
      public function get actions() : Array
      {
         return this._actions;
      }
      
      public function get hooks() : Array
      {
         return this._hooks;
      }
      
      public function get apis() : Array
      {
         return this._apis;
      }
      
      private function onSwfLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:ASwf = param1.resource;
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onSwfLoaded);
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onSwfFailed);
         this.process(_loc2_.applicationDomain);
         this._readyFct();
      }
      
      private function process(param1:ApplicationDomain) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         for each(_loc2_ in _actionList)
         {
            if(param1.hasDefinition("d2actions::" + _loc2_))
            {
               this._actions.push(_loc2_);
            }
         }
         for each(_loc3_ in _hookList)
         {
            if(param1.hasDefinition("d2hooks::" + _loc3_))
            {
               this._hooks.push(_loc3_);
            }
         }
         for each(_loc4_ in _apiList)
         {
            if(param1.hasDefinition("d2api::" + _loc4_))
            {
               this._apis.push(_loc4_);
            }
         }
      }
      
      private function onSwfFailed(param1:ResourceErrorEvent) : void
      {
         this._readyFct();
      }
   }
}
