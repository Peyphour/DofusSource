package
{
   import d2components.SecureComponent;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import utils.ActionList;
   import utils.DirectAccessObject;
   import utils.HookList;
   import utils.ReadOnlyData;
   import utils.d2apiList;
   
   public class SharedDefinitions extends Sprite
   {
       
      
      private var _importDirectAccessObject:DirectAccessObject;
      
      private var _importReadOnlyData:ReadOnlyData;
      
      private var _importSecureComponent:SecureComponent;
      
      private var _importAPI:ForceImport = null;
      
      private var _importActionList:ActionList = null;
      
      public const version:uint = 1;
      
      private var _loadStack:Array;
      
      private var _loader:Loader;
      
      public function SharedDefinitions()
      {
         this._loadStack = [];
         this._loader = new Loader();
         super();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleLoad);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onModuleLoadFail);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onModuleLoadProgress);
      }
      
      public function loadModule(param1:String, param2:Function, param3:Function, param4:Object) : void
      {
         var _loc5_:Object = {
            "url":param1,
            "successCallback":param2,
            "additionalInfo":param4,
            "errorCallback":param3
         };
         this._loadStack.push(_loc5_);
         if(this._loadStack.length == 1)
         {
            this.loadNextFile();
         }
      }
      
      public function getActionList() : Array
      {
         return ActionList.list;
      }
      
      public function getHookList() : Array
      {
         return HookList.list;
      }
      
      public function getApiList() : Array
      {
         return d2apiList.list;
      }
      
      private function loadNextFile() : void
      {
         var _loc1_:Object = null;
         var _loc2_:LoaderContext = null;
         if(this._loadStack.length)
         {
            _loc1_ = this._loadStack[0];
            _loc2_ = new LoaderContext();
            _loc2_.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            this._loader.load(new URLRequest(_loc1_.url),_loc2_);
         }
      }
      
      private function onModuleLoad(param1:Event) : void
      {
         var _loc2_:Object = this._loadStack[0];
         _loc2_.successCallback(param1,_loc2_.additionalInfo);
         this._loadStack.shift();
         this.loadNextFile();
      }
      
      private function onModuleLoadFail(param1:Event) : void
      {
         var _loc2_:Object = this._loadStack[0];
         _loc2_.errorCallback(param1,_loc2_.additionalInfo);
         this._loadStack.shift();
         this.loadNextFile();
      }
      
      private function onModuleLoadProgress(param1:ProgressEvent) : void
      {
      }
   }
}
