package d2utils
{
   import utils.DirectAccessObject;
   
   public dynamic class UiModule extends DirectAccessObject
   {
       
      
      public function UiModule(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function set loader(param1:Object) : void
      {
         _target.loader = param1;
      }
      
      public function get instanceId() : uint
      {
         return _target.instanceId;
      }
      
      public function get id() : String
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get version() : String
      {
         return _target.version;
      }
      
      public function get gameVersion() : String
      {
         return _target.gameVersion;
      }
      
      public function get author() : String
      {
         return _target.author;
      }
      
      public function get shortDescription() : String
      {
         return _target.shortDescription;
      }
      
      public function get description() : String
      {
         return _target.description;
      }
      
      public function get iconUri() : Object
      {
         return _target.iconUri;
      }
      
      public function get script() : String
      {
         return _target.script;
      }
      
      public function get shortcuts() : String
      {
         return _target.shortcuts;
      }
      
      public function get uis() : Object
      {
         return _target.uis;
      }
      
      public function get trusted() : Boolean
      {
         return _target.trusted;
      }
      
      public function set trusted(param1:Boolean) : void
      {
         _target.trusted = param1;
      }
      
      public function get enable() : Boolean
      {
         return _target.enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         _target.enable = param1;
      }
      
      public function get rootPath() : String
      {
         return _target.rootPath;
      }
      
      public function get storagePath() : String
      {
         return _target.storagePath;
      }
      
      public function get cachedFiles() : Object
      {
         return _target.cachedFiles;
      }
      
      public function get apiList() : Object
      {
         return _target.apiList;
      }
      
      public function set applicationDomain(param1:Object) : void
      {
         _target.applicationDomain = param1;
      }
      
      public function get applicationDomain() : Object
      {
         return _target.applicationDomain;
      }
      
      public function get mainClass() : Object
      {
         return _target.mainClass;
      }
      
      public function set mainClass(param1:Object) : void
      {
         _target.mainClass = param1;
      }
      
      public function get groups() : Object
      {
         return _target.groups;
      }
      
      public function get rawXml() : Object
      {
         return _target.rawXml;
      }
      
      public function addUiGroup(param1:String, param2:Boolean, param3:Boolean) : void
      {
         _target.addUiGroup(param1,param2,param3);
      }
      
      public function getUi(param1:String) : UiData
      {
         return _target.getUi(param1);
      }
      
      public function toString() : String
      {
         return _target.toString();
      }
      
      public function destroy() : void
      {
         _target.destroy();
      }
      
      public function usedApiList(param1:Function) : void
      {
         _target.usedApiList(param1);
      }
      
      public function usedHookList(param1:Function) : void
      {
         _target.usedHookList(param1);
      }
      
      public function usedActionList(param1:Function) : void
      {
         _target.usedActionList(param1);
      }
   }
}
