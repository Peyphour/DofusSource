package com.ankamagames.berilia.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.components.TextureBase;
   import com.ankamagames.berilia.types.data.PreCompiledUiModule;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiGroup;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.ParsingErrorEvent;
   import com.ankamagames.berilia.types.event.ParsorEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedErrorMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.types.shortcut.ShortcutCategory;
   import com.ankamagames.berilia.uiRender.XmlParsor;
   import com.ankamagames.berilia.utils.ModFlashProtocol;
   import com.ankamagames.berilia.utils.ModProtocol;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.resources.ResourceType;
   import com.ankamagames.jerakine.resources.adapters.impl.TxtAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.protocols.ProtocolFactory;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class UiModuleManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiModuleManager));
      
      private static const _lastModulesToUnload:Array = ["Ankama_GameUiCore","Ankama_Common","Ankama_Tooltips","Ankama_ContextMenu"];
      
      private static var _self:UiModuleManager;
       
      
      private var _loader:IResourceLoader;
      
      private var _uiLoader:IResourceLoader;
      
      private var _scriptNum:uint;
      
      private var _modules:Array;
      
      private var _preprocessorIndex:Dictionary;
      
      private var _uiFiles:Array;
      
      private var _regImport:RegExp;
      
      private var _versions:Array;
      
      private var _clearUi:Array;
      
      private var _uiFileToLoad:uint;
      
      private var _moduleCount:uint = 0;
      
      private var _cacheLoader:IResourceLoader;
      
      private var _unparsedXml:Array;
      
      private var _unparsedXmlCount:uint;
      
      private var _unparsedXmlTotalCount:uint;
      
      private var _modulesRoot:File;
      
      private var _modulesPaths:Dictionary;
      
      private var _modulesHashs:Dictionary;
      
      private var _resetState:Boolean;
      
      private var _parserAvaibleCount:uint = 2;
      
      private var _unInitializedModules:Array;
      
      private var _bytesToLoad:Array;
      
      private var _moduleLoaders:Dictionary;
      
      private var _loadingModule:Dictionary;
      
      private var _disabledModules:Array;
      
      private var _timeOutFrameNumber:int;
      
      private var _filter:Array;
      
      private var _filterInclude:Boolean;
      
      public var isDevMode:Boolean = false;
      
      private var _moduleScriptLoadedRef:Dictionary;
      
      private var _uiLoaded:Dictionary;
      
      private var _trustedModuleScripts:Array;
      
      public function UiModuleManager()
      {
         this._regImport = /<Import *url *= *"([^"]*)/g;
         this._modulesHashs = new Dictionary();
         this._bytesToLoad = new Array();
         this._moduleScriptLoadedRef = new Dictionary();
         this._uiLoaded = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad,false,0,true);
         this._uiLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._uiLoader.addEventListener(ResourceErrorEvent.ERROR,this.onUiLoadError,false,0,true);
         this._uiLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onUiLoaded,false,0,true);
         this._cacheLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._moduleLoaders = new Dictionary();
      }
      
      public static function getInstance() : UiModuleManager
      {
         if(!_self)
         {
            _self = new UiModuleManager();
         }
         return _self;
      }
      
      public function get unInitializedModules() : Array
      {
         return this._unInitializedModules;
      }
      
      public function get moduleCount() : uint
      {
         return this._moduleCount;
      }
      
      public function get unparsedXmlCount() : uint
      {
         return this._unparsedXmlCount;
      }
      
      public function get unparsedXmlTotalCount() : uint
      {
         return this._unparsedXmlTotalCount;
      }
      
      public function get ready() : Boolean
      {
         return this._moduleCount > 0;
      }
      
      public function get modulesHashs() : Dictionary
      {
         return this._modulesHashs;
      }
      
      public function init(param1:Array, param2:Boolean) : void
      {
         var _loc5_:File = null;
         this._filter = param1;
         this._filterInclude = param2;
         this._resetState = false;
         this._modules = new Array();
         this._preprocessorIndex = new Dictionary(true);
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._versions = new Array();
         this._clearUi = new Array();
         this._uiFiles = new Array();
         this._modulesPaths = new Dictionary();
         this._unInitializedModules = new Array();
         this._loadingModule = new Dictionary();
         this._disabledModules = [];
         if(AirScanner.hasAir())
         {
            ProtocolFactory.addProtocol("mod",ModProtocol);
         }
         else
         {
            ProtocolFactory.addProtocol("mod",ModFlashProtocol);
         }
         var _loc3_:String = LangManager.getInstance().getEntry("config.mod.path");
         if(_loc3_.substr(0,2) != "\\\\" && _loc3_.substr(1,2) != ":/")
         {
            this._modulesRoot = new File(File.applicationDirectory.nativePath + File.separator + _loc3_);
         }
         else
         {
            this._modulesRoot = new File(_loc3_);
         }
         var _loc4_:Uri = new Uri(this._modulesRoot.nativePath + "/hash.metas");
         this._loader.load(_loc4_);
         BindsManager.getInstance().initialize();
         if(this._modulesRoot.exists)
         {
            for each(_loc5_ in this._modulesRoot.getDirectoryListing())
            {
               if(!(!_loc5_.isDirectory || _loc5_.name.charAt(0) == "."))
               {
                  if(param1.indexOf(_loc5_.name) != -1 == param2)
                  {
                     this.loadModule(_loc5_.name);
                  }
               }
            }
            return;
         }
         ErrorManager.addError("Impossible de trouver le dossier contenant les modules (url: " + LangManager.getInstance().getEntry("config.mod.path") + ")");
      }
      
      public function lightInit(param1:Vector.<UiModule>) : void
      {
         var _loc2_:UiModule = null;
         this._resetState = false;
         this._modules = new Array();
         this._modulesPaths = new Dictionary();
         for each(_loc2_ in param1)
         {
            this._modules[_loc2_.id] = _loc2_;
            this._modulesPaths[_loc2_.id] = _loc2_.rootPath;
         }
      }
      
      public function getModules() : Array
      {
         return this._modules;
      }
      
      public function getModule(param1:String, param2:Boolean = false) : UiModule
      {
         var _loc3_:UiModule = null;
         if(this._modules)
         {
            _loc3_ = this._modules[param1];
         }
         if(!_loc3_ && param2 && this._unInitializedModules)
         {
            _loc3_ = this._unInitializedModules[param1];
         }
         return _loc3_;
      }
      
      public function get disabledModules() : Array
      {
         return this._disabledModules;
      }
      
      public function reset() : void
      {
         var _loc1_:UiModule = null;
         var _loc2_:int = 0;
         _log.warn("Reset des modules");
         this._resetState = true;
         if(this._loader)
         {
            this._loader.cancel();
         }
         if(this._cacheLoader)
         {
            this._cacheLoader.cancel();
         }
         if(this._uiLoader)
         {
            this._uiLoader.cancel();
         }
         TooltipManager.clearCache();
         for each(_loc1_ in this._modules)
         {
            if(_lastModulesToUnload.indexOf(_loc1_.id) == -1)
            {
               this.unloadModule(_loc1_.id);
            }
         }
         _loc2_ = 0;
         while(_loc2_ < _lastModulesToUnload.length)
         {
            if(this._modules[_lastModulesToUnload[_loc2_]])
            {
               this.unloadModule(_lastModulesToUnload[_loc2_]);
            }
            _loc2_++;
         }
         Shortcut.reset();
         Berilia.getInstance().reset();
         ApiBinder.reset();
         UiPerformanceManager.getInstance().reset();
         TextureBase.clearCache();
         KernelEventsManager.getInstance().initialize();
         this._modules = [];
         this._uiFileToLoad = 0;
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._parserAvaibleCount = 2;
         this._modulesPaths = new Dictionary();
      }
      
      public function getModulePath(param1:String) : String
      {
         return this._modulesPaths[param1];
      }
      
      public function loadModule(param1:String) : void
      {
         var _loc3_:File = null;
         var _loc4_:Uri = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         this.unloadModule(param1);
         var _loc2_:File = this._modulesRoot.resolvePath(param1);
         if(_loc2_.exists)
         {
            _loc3_ = this.searchDmFile(_loc2_);
            if(_loc3_)
            {
               this._moduleCount++;
               this._scriptNum++;
               if(_loc3_.nativePath.indexOf("app:/") == 0)
               {
                  _loc6_ = "app:/".length;
                  _loc7_ = _loc3_.nativePath.substring(_loc6_,_loc3_.url.length);
                  _loc4_ = new Uri(_loc7_);
                  _loc5_ = _loc7_.substr(0,_loc7_.lastIndexOf("/"));
               }
               else
               {
                  _loc4_ = new Uri(_loc3_.nativePath);
                  _loc5_ = _loc3_.parent.nativePath;
               }
               _loc4_.tag = _loc3_;
               this._modulesPaths[param1] = _loc5_;
               this._loader.load(_loc4_);
            }
            else
            {
               _log.error("Cannot found .dm or .d2ui file in " + _loc2_.url);
            }
         }
      }
      
      public function unloadModule(param1:String) : void
      {
         var uiCtr:UiRootContainer = null;
         var ui:String = null;
         var group:UiGroup = null;
         var variables:Array = null;
         var varName:String = null;
         var apiList:Vector.<Object> = null;
         var api:Object = null;
         var id:String = param1;
         if(this._modules == null)
         {
            return;
         }
         var m:UiModule = this._modules[id];
         if(!m)
         {
            return;
         }
         var moduleUiInstances:Array = [];
         for each(uiCtr in Berilia.getInstance().uiList)
         {
            if(uiCtr.uiModule == m)
            {
               moduleUiInstances.push(uiCtr.name);
            }
         }
         for each(ui in moduleUiInstances)
         {
            Berilia.getInstance().unloadUi(ui);
         }
         for each(group in m.groups)
         {
            UiGroupManager.getInstance().removeGroup(group.name);
         }
         variables = DescribeTypeCache.getVariables(m.mainClass,true);
         for each(varName in variables)
         {
            if(m.mainClass[varName] is Object)
            {
               m.mainClass[varName] = null;
            }
         }
         m.destroy();
         apiList = m.apiList;
         while(apiList.length)
         {
            api = apiList.shift();
            if(api && api.hasOwnProperty("destroy"))
            {
               try
               {
                  api["destroy"]();
               }
               catch(e:UntrustedApiCallError)
               {
                  api["destroy"](SecureCenter.ACCESS_KEY);
                  continue;
               }
            }
         }
         if(m.mainClass && m.mainClass.hasOwnProperty("unload"))
         {
            m.mainClass["unload"]();
         }
         BindsManager.getInstance().removeAllEventListeners("__module_" + m.id);
         KernelEventsManager.getInstance().removeAllEventListeners("__module_" + m.id);
         delete this._modules[id];
         this._disabledModules[id] = m;
      }
      
      private function launchModule() : void
      {
         var _loc10_:Boolean = true;
         var _loc11_:Boolean = false;
         var _loc2_:UiModule = null;
         var _loc4_:UiModule = null;
         var _loc5_:* = null;
         §§push(0);
         if(!_loc10_)
         {
            §§push((-(§§pop() + 67 + 74) - 57) * 2);
         }
         var _loc7_:uint = §§pop();
         §§push(new Array());
         if(_loc10_)
         {
            §§push(§§pop());
         }
         if(!_loc11_)
         {
            §§push(0);
            if(_loc11_)
            {
               §§push((§§pop() - 1 + 117) * 22 - 7 - 1);
            }
            if(_loc10_)
            {
               if(_loc10_)
               {
                  for each(_loc2_ in this._unInitializedModules)
                  {
                     if(_loc10_)
                     {
                        if(_loc2_.trusted)
                        {
                           if(!_loc11_)
                           {
                              §§push(_loc1_);
                              if(_loc10_)
                              {
                                 §§pop().unshift(_loc2_);
                                 if(!_loc10_)
                                 {
                                    continue;
                                 }
                              }
                           }
                           continue;
                        }
                        §§push(_loc1_);
                        §§pop().push(_loc2_);
                     }
                  }
               }
            }
            if(_loc10_)
            {
               while(true)
               {
                  §§push(_loc1_.length);
                  §§push(0);
                  if(_loc11_)
                  {
                     §§push(§§pop() - 70 - 1 + 23);
                  }
                  if(§§pop() <= §§pop())
                  {
                     break;
                  }
                  §§push(new Array());
                  if(_loc10_)
                  {
                     §§push(§§pop());
                  }
                  _loc5_ = §§pop();
                  if(!_loc11_)
                  {
                     §§push(0);
                     if(_loc11_)
                     {
                        §§push(§§pop() + 1 - 1 + 53 + 1);
                     }
                     if(!_loc11_)
                     {
                        if(_loc10_)
                        {
                           while(§§hasnext(_loc1_,_loc8_))
                           {
                              if(!_loc10_)
                              {
                                 addr140:
                                 while(true)
                                 {
                                    ApiBinder.addApiData("currentUi",null);
                                    if(!_loc11_)
                                    {
                                    }
                                    break;
                                 }
                                 §§push(ApiBinder.initApi(_loc6_.mainClass,_loc6_));
                                 if(_loc10_)
                                 {
                                    §§push(§§pop());
                                    if(!_loc11_)
                                    {
                                       if(_loc10_)
                                       {
                                       }
                                       §§push(_loc3_);
                                    }
                                 }
                                 if(§§pop())
                                 {
                                    _loc4_ = _loc6_;
                                    if(_loc10_)
                                    {
                                       _loc5_.push(_loc6_);
                                    }
                                    continue;
                                 }
                                 if(_loc6_.mainClass)
                                 {
                                    delete this._unInitializedModules[_loc6_.id];
                                    if(_loc10_)
                                    {
                                       if(!_loc10_)
                                       {
                                          addr206:
                                          while(true)
                                          {
                                             ErrorManager.tryFunction(_loc6_.mainClass.main,null,"Une erreur est survenue lors de l\'appel à la fonction main() du module " + _loc6_.id);
                                             if(!_loc11_)
                                             {
                                                if(_loc10_)
                                                {
                                                }
                                                break;
                                             }
                                          }
                                          continue;
                                       }
                                       while(true)
                                       {
                                          _loc7_ = getTimer();
                                       }
                                    }
                                    while(true)
                                    {
                                       if(_loc10_)
                                       {
                                          §§goto(addr206);
                                       }
                                       §§goto(addr234);
                                    }
                                 }
                                 else
                                 {
                                    §§push(_log);
                                    §§push("Impossible d\'instancier la classe principale du module ");
                                    if(_loc10_)
                                    {
                                       §§push(§§pop() + _loc6_.id);
                                    }
                                    §§pop().error(§§pop());
                                    continue;
                                 }
                              }
                              while(true)
                              {
                                 if(_loc10_)
                                 {
                                    §§goto(addr140);
                                 }
                                 §§goto(addr164);
                              }
                           }
                        }
                     }
                     if(!_loc10_)
                     {
                        continue;
                     }
                  }
                  §§push(_loc5_);
                  if(_loc10_)
                  {
                     if(§§pop().length == _loc1_.length)
                     {
                        if(_loc10_)
                        {
                           §§push(ErrorManager);
                           §§push("Le module ");
                           if(!_loc11_)
                           {
                              §§push(_loc4_.id);
                              if(_loc10_)
                              {
                                 §§push(§§pop() + §§pop());
                                 if(!_loc11_)
                                 {
                                    §§push(§§pop() + " demande une référence vers un module inexistant : ");
                                    if(_loc11_)
                                    {
                                    }
                                    addr283:
                                    §§pop().addError(§§pop());
                                    if(!_loc10_)
                                    {
                                       continue;
                                    }
                                 }
                              }
                              addr282:
                              §§goto(addr283);
                              §§push(§§pop() + §§pop());
                           }
                           §§goto(addr282);
                           §§push(_loc3_);
                        }
                     }
                     §§push(_loc5_);
                     if(!_loc11_)
                     {
                        §§push(§§pop());
                     }
                  }
               }
               if(!_loc10_)
               {
               }
            }
            Berilia.getInstance().handler.process(new AllModulesLoadedMessage());
         }
      }
      
      private function launchUiCheck() : void
      {
         var _loc1_:Boolean = true;
         var _loc2_:Boolean = false;
         if(_loc1_)
         {
            this._uiFileToLoad = this._uiFiles.length;
            if(_loc2_)
            {
            }
            addr42:
            return;
         }
         if(this._uiFiles.length)
         {
            if(_loc1_)
            {
               this._uiLoader.load(this._uiFiles,null,TxtAdapter);
               if(!_loc2_)
               {
                  §§goto(addr42);
               }
            }
         }
         else
         {
            this.onAllUiChecked(null);
         }
         §§goto(addr42);
      }
      
      private function processCachedFiles(param1:Array) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = true;
         var _loc2_:Uri = null;
         var _loc3_:Uri = null;
         var _loc4_:ICache = null;
         if(_loc9_)
         {
            §§push(0);
            if(_loc8_)
            {
               §§push((§§pop() - 1) * 62 * 15);
            }
            if(_loc9_)
            {
               if(_loc9_)
               {
                  for each(_loc3_ in param1)
                  {
                     if(!_loc8_)
                     {
                        if(_loc9_)
                        {
                           §§push("css");
                           if(_loc9_)
                           {
                              if(§§pop() === _loc7_)
                              {
                                 if(!_loc8_)
                                 {
                                    §§push(0);
                                    if(!_loc9_)
                                    {
                                       §§push(-(§§pop() * 58) * 80);
                                    }
                                 }
                                 addr206:
                                 switch(§§pop())
                                 {
                                    case 0:
                                       CssManager.getInstance().load(_loc3_.uri);
                                       if(!_loc9_)
                                       {
                                       }
                                       continue;
                                    case 1:
                                    case 2:
                                       _loc2_ = new Uri(FileUtils.getFilePath(_loc3_.normalizedUri));
                                       _loc4_ = UriCacheFactory.getCacheFromUri(_loc2_);
                                       if(!_loc4_)
                                       {
                                          if(_loc9_)
                                          {
                                             _loc4_ = UriCacheFactory.init(_loc2_.uri,new Cache(param1.length,new LruGarbageCollector()));
                                          }
                                          break;
                                       }
                                       this._cacheLoader.load(_loc3_,_loc4_);
                                       if(_loc9_)
                                       {
                                          continue;
                                       }
                                       break;
                                    default:
                                       §§push(_log);
                                       §§push("Impossible de mettre en cache le fichier ");
                                       if(_loc9_)
                                       {
                                          §§push(§§pop() + _loc3_.uri);
                                          if(!_loc9_)
                                          {
                                          }
                                          addr119:
                                          §§pop().error(§§pop());
                                          break;
                                       }
                                       §§goto(addr119);
                                       §§push(§§pop() + ", le type n\'est pas supporté (uniquement css, jpg et png)");
                                 }
                                 continue;
                              }
                              §§push("jpg");
                              if(_loc8_)
                              {
                              }
                              addr170:
                              if(§§pop() !== _loc7_)
                              {
                                 §§push(3);
                                 if(!_loc9_)
                                 {
                                    §§push((§§pop() - 23 + 91 - 104 + 1 + 1) * 33);
                                 }
                              }
                              §§goto(addr206);
                              addr172:
                              §§push(2);
                              if(!_loc9_)
                              {
                                 §§push(§§pop() + 1 - 55 - 56 + 22 - 1);
                              }
                              §§goto(addr206);
                           }
                           if(§§pop() === _loc7_)
                           {
                              if(!_loc9_)
                              {
                              }
                              §§goto(addr206);
                           }
                           else
                           {
                              §§goto(addr170);
                              §§push("png");
                           }
                           §§goto(addr172);
                        }
                        §§push(1);
                        if(_loc8_)
                        {
                           §§push(-(-(§§pop() * 66 - 1) - 90) - 1 - 54);
                        }
                        if(_loc8_)
                        {
                        }
                        §§goto(addr206);
                     }
                     else
                     {
                        continue;
                     }
                  }
               }
            }
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = true;
         if(_loc5_)
         {
            §§push(_log);
            §§push("onLoadError() - ");
            if(!_loc4_)
            {
               §§push(§§pop() + param1.errorMsg);
            }
            §§pop().error(§§pop());
            if(_loc5_)
            {
               §§push(param1.uri.fileType);
               if(_loc5_)
               {
                  if(§§pop() != "metas")
                  {
                     if(_loc5_)
                     {
                        Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(param1.uri.tag,param1.uri));
                        if(_loc4_)
                        {
                        }
                     }
                  }
                  §§push(param1.uri.fileType);
               }
               if(!_loc4_)
               {
                  §§push("swfs");
                  if(_loc5_)
                  {
                     if(§§pop() === _loc2_)
                     {
                        if(_loc5_)
                        {
                           §§push(0);
                           if(!_loc5_)
                           {
                              §§push((§§pop() * 103 + 1) * 2 - 93 - 1);
                           }
                        }
                        addr207:
                        switch(§§pop())
                        {
                           case 0:
                              §§push(ErrorManager);
                              §§push("Impossible de charger le fichier ");
                              if(!_loc4_)
                              {
                                 §§push(§§pop() + param1.uri);
                                 if(!_loc4_)
                                 {
                                    §§push(" (");
                                    if(_loc5_)
                                    {
                                       §§push(§§pop() + §§pop());
                                       if(!_loc5_)
                                       {
                                       }
                                    }
                                    addr76:
                                    §§pop().addError(§§pop() + §§pop());
                                    if(!_loc4_)
                                    {
                                       §§push(_loc2_._scriptNum - 1);
                                       if(!_loc4_)
                                       {
                                          §§push(_loc3_);
                                          if(_loc5_)
                                          {
                                             _loc2_._scriptNum = _loc3_;
                                          }
                                       }
                                       if(!§§pop())
                                       {
                                          if(_loc4_)
                                          {
                                          }
                                          break;
                                       }
                                       addr108:
                                       return;
                                    }
                                    this.launchUiCheck();
                                    if(!_loc4_)
                                    {
                                       §§goto(addr108);
                                    }
                                    else
                                    {
                                       break;
                                    }
                                 }
                                 §§push(§§pop() + param1.errorMsg);
                                 if(_loc4_)
                                 {
                                 }
                                 §§goto(addr76);
                              }
                              §§goto(addr76);
                              §§push(")");
                           case 1:
                              §§goto(addr108);
                           default:
                              §§push(ErrorManager);
                              §§push("Impossible de charger le fichier ");
                              if(!_loc4_)
                              {
                                 §§push(§§pop() + param1.uri);
                                 if(!_loc4_)
                                 {
                                    §§push(" (");
                                    if(!_loc4_)
                                    {
                                       §§push(§§pop() + §§pop());
                                       if(_loc5_)
                                       {
                                          §§push(§§pop() + param1.errorMsg);
                                          if(!_loc5_)
                                          {
                                          }
                                          addr136:
                                          §§pop().addError(§§pop());
                                          break;
                                       }
                                    }
                                    addr135:
                                    §§goto(addr136);
                                    §§push(§§pop() + §§pop());
                                 }
                              }
                              §§goto(addr135);
                              §§push(")");
                        }
                     }
                     else
                     {
                        §§push("metas");
                     }
                  }
                  if(§§pop() !== _loc2_)
                  {
                     §§push(2);
                     if(!_loc5_)
                     {
                        §§push(§§pop() + 1 - 1 + 114 + 1 - 53);
                     }
                  }
                  §§goto(addr207);
               }
               §§push(1);
               if(_loc4_)
               {
                  §§push(--(§§pop() * 80 * 107 * 78) + 65 + 21);
               }
               if(!_loc5_)
               {
               }
               §§goto(addr207);
            }
         }
         §§goto(addr108);
      }
      
      private function onUiLoadError(param1:ResourceErrorEvent) : void
      {
         var _loc4_:Boolean = true;
         var _loc5_:Boolean = false;
         if(_loc4_)
         {
            §§push(ErrorManager);
            §§push("Impossible de charger le fichier d\'interface ");
            if(_loc4_)
            {
               §§push(§§pop() + param1.uri);
               if(_loc4_)
               {
                  §§push(" (");
                  if(_loc4_)
                  {
                     §§push(§§pop() + §§pop());
                     if(_loc5_)
                     {
                     }
                  }
                  addr42:
                  §§push(§§pop() + §§pop());
               }
               §§push(§§pop() + param1.errorMsg);
               if(_loc4_)
               {
                  §§goto(addr42);
                  §§push(")");
               }
            }
            §§pop().addError(§§pop());
            if(_loc5_)
            {
            }
            addr76:
            return;
         }
         Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(param1.uri.tag,param1.uri));
         if(!_loc5_)
         {
            if(_loc4_)
            {
               _loc2_._uiFileToLoad = _loc3_;
            }
         }
         §§goto(addr76);
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = false;
         if(!_loc4_)
         {
            if(this._resetState)
            {
               if(!_loc4_)
               {
                  return;
               }
            }
            else
            {
               if(_loc3_)
               {
                  §§push("swf");
                  if(!_loc4_)
                  {
                     if(§§pop() === _loc2_)
                     {
                        §§push(0);
                        if(_loc4_)
                        {
                           §§push((-((§§pop() - 1) * 69) + 41) * 89 + 1);
                        }
                     }
                     else
                     {
                        §§push("swfs");
                        if(!_loc4_)
                        {
                           if(§§pop() === _loc2_)
                           {
                              §§push(1);
                              if(!_loc3_)
                              {
                                 §§push(§§pop() - 1 - 26 - 46 - 1 - 1 + 15);
                              }
                           }
                           else
                           {
                              §§push("d2ui");
                              if(_loc3_)
                              {
                                 if(§§pop() !== _loc2_)
                                 {
                                    §§push("dm");
                                    if(_loc4_)
                                    {
                                    }
                                 }
                              }
                           }
                        }
                        if(§§pop() === _loc2_)
                        {
                           §§push(3);
                           if(!_loc3_)
                           {
                              §§push(§§pop() + 1 + 100 + 111);
                           }
                           if(!_loc3_)
                           {
                              addr163:
                           }
                        }
                        else
                        {
                           §§push("xml");
                           if(!_loc4_)
                           {
                              if(§§pop() === _loc2_)
                              {
                                 §§push(4);
                                 if(_loc4_)
                                 {
                                    §§push(--(§§pop() - 103 - 1) + 56);
                                 }
                              }
                              else
                              {
                                 §§push("metas");
                              }
                           }
                        }
                     }
                     addr174:
                     switch(§§pop())
                     {
                        case 0:
                        case 1:
                           this.onScriptLoad(param1);
                           if(_loc4_)
                           {
                              addr35:
                           }
                           addr176:
                           return;
                        case 2:
                        case 3:
                           this.onDMLoad(param1);
                           if(_loc3_)
                           {
                              §§goto(addr35);
                           }
                           else
                           {
                              break;
                           }
                        case 4:
                           this.onShortcutLoad(param1);
                           if(_loc3_)
                           {
                              break;
                           }
                           addr47:
                           §§goto(addr176);
                        case 5:
                           this.onHashLoaded(param1);
                           §§goto(addr47);
                        default:
                           §§goto(addr176);
                     }
                  }
                  if(§§pop() === _loc2_)
                  {
                     §§push(5);
                     if(_loc4_)
                     {
                        §§push(-((-(§§pop() - 13) - 1) * 83));
                     }
                     §§goto(addr163);
                  }
                  else
                  {
                     §§push(6);
                     if(!_loc3_)
                     {
                        §§push(§§pop() * 49 - 1 - 1);
                     }
                  }
                  §§goto(addr174);
               }
               §§push(2);
               if(!_loc3_)
               {
                  §§push((§§pop() + 1) * 109 + 1);
               }
               §§goto(addr174);
            }
         }
         §§goto(addr176);
      }
      
      private function onDMLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = true;
         var _loc3_:Uri = null;
         var _loc6_:File = null;
         var _loc7_:String = null;
         var _loc9_:Loader = null;
         var _loc10_:LoaderContext = null;
         var _loc11_:ByteArray = null;
         var _loc12_:Uri = null;
         var _loc13_:UiData = null;
         var _loc15_:File = null;
         if(!_loc20_)
         {
            if(param1.resourceType == ResourceType.RESOURCE_XML)
            {
            }
            addr97:
            §§push(this._unInitializedModules);
            if(!_loc20_)
            {
               §§push(_loc2_.id);
               if(_loc21_)
               {
                  §§pop()[§§pop()] = _loc2_;
                  §§push(_loc2_.script);
                  if(!_loc20_)
                  {
                     if(§§pop())
                     {
                        §§push(this._trustedModuleScripts);
                        if(!_loc20_)
                        {
                           §§push(_loc2_.id);
                           if(!_loc21_)
                           {
                           }
                           addr351:
                           §§pop()[§§pop()] = _loc2_;
                           return;
                        }
                     }
                     addr299:
                     §§push(_loc2_.enable);
                     if(_loc21_)
                     {
                        if(!§§pop())
                        {
                           §§push(_log);
                           §§push("Le module ");
                           if(_loc21_)
                           {
                              §§push(§§pop() + _loc2_.id);
                              if(!_loc21_)
                              {
                              }
                              addr316:
                              §§pop().fatal(§§pop());
                              addr333:
                              if(_loc21_)
                              {
                                 if(_loc21_)
                                 {
                                    this._moduleCount--;
                                 }
                              }
                              if(_loc21_)
                              {
                                 this._scriptNum--;
                              }
                              §§push(this._disabledModules);
                           }
                           §§goto(addr316);
                           §§push(§§pop() + " est désactivé");
                        }
                        else
                        {
                           §§push(_loc2_.shortcuts);
                        }
                     }
                     addr380:
                     if(§§pop())
                     {
                        this._loadingModule[_loc2_] = _loc2_.id;
                        §§push(new Array());
                        if(!_loc20_)
                        {
                           §§push(§§pop());
                        }
                        if(_loc21_)
                        {
                           if(!(_loc2_ is PreCompiledUiModule))
                           {
                              if(!_loc20_)
                              {
                                 §§push(0);
                                 if(!_loc21_)
                                 {
                                    §§push(-(§§pop() + 1) - 85);
                                 }
                                 if(!_loc20_)
                                 {
                                    if(_loc21_)
                                    {
                                       for each(_loc13_ in _loc2_.uis)
                                       {
                                          if(_loc13_.file)
                                          {
                                             _loc3_ = new Uri(_loc13_.file);
                                             if(!_loc20_)
                                             {
                                                if(_loc20_)
                                                {
                                                   loop1:
                                                   while(true)
                                                   {
                                                      this._uiFiles.push(_loc3_);
                                                      if(!_loc21_)
                                                      {
                                                      }
                                                      addr522:
                                                      while(true)
                                                      {
                                                         if(!_loc21_)
                                                         {
                                                            break loop1;
                                                         }
                                                         continue loop1;
                                                      }
                                                   }
                                                   continue;
                                                }
                                                addr513:
                                                while(true)
                                                {
                                                   _loc3_.tag = {
                                                      "mod":_loc2_.id,
                                                      "base":_loc13_.file
                                                   };
                                                   §§goto(addr522);
                                                }
                                             }
                                             while(_loc20_)
                                             {
                                                §§goto(addr513);
                                             }
                                             continue;
                                          }
                                       }
                                    }
                                    if(_loc21_)
                                    {
                                    }
                                 }
                              }
                           }
                        }
                        if(!_loc20_)
                        {
                           §§push(new Array());
                           if(_loc21_)
                           {
                              §§push(§§pop());
                           }
                           if(!_loc20_)
                           {
                              §§push(0);
                              if(!_loc21_)
                              {
                                 §§push(-§§pop() - 1 - 47 - 1);
                              }
                              if(_loc21_)
                              {
                                 if(_loc21_)
                                 {
                                    for each(_loc7_ in _loc2_.cachedFiles)
                                    {
                                       _loc6_ = _loc5_.resolvePath(_loc7_);
                                       if(_loc6_.exists)
                                       {
                                          if(_loc21_)
                                          {
                                             if(!_loc6_.isDirectory)
                                             {
                                                if(_loc21_)
                                                {
                                                   §§push(_loc4_);
                                                   if(_loc21_)
                                                   {
                                                      §§push();
                                                      §§push("mod://");
                                                      if(!_loc20_)
                                                      {
                                                         §§push(_loc2_.id);
                                                         if(!_loc20_)
                                                         {
                                                            §§push(§§pop() + §§pop());
                                                            if(_loc20_)
                                                            {
                                                            }
                                                            addr611:
                                                            §§push(_loc7_);
                                                         }
                                                         addr613:
                                                         §§pop().push(new §§pop().Uri(§§pop() + §§pop()));
                                                         if(_loc20_)
                                                         {
                                                         }
                                                      }
                                                      §§push(§§pop() + "/");
                                                      if(_loc21_)
                                                      {
                                                         §§goto(addr611);
                                                      }
                                                      §§goto(addr613);
                                                   }
                                                   addr625:
                                                   §§push(0);
                                                   if(_loc20_)
                                                   {
                                                      §§push(-((§§pop() - 1) * 35) * 85 + 72 - 1 - 1);
                                                   }
                                                   if(_loc21_)
                                                   {
                                                      if(_loc21_)
                                                      {
                                                         for each(_loc15_ in _loc14_)
                                                         {
                                                            if(!_loc15_.isDirectory)
                                                            {
                                                               if(!_loc21_)
                                                               {
                                                                  continue;
                                                               }
                                                            }
                                                            §§push(_loc4_);
                                                            §§push();
                                                            §§push("mod://");
                                                            if(!_loc20_)
                                                            {
                                                               §§push(_loc2_.id);
                                                               if(!_loc20_)
                                                               {
                                                                  §§push(§§pop() + §§pop());
                                                                  if(!_loc20_)
                                                                  {
                                                                     §§push("/");
                                                                     if(!_loc20_)
                                                                     {
                                                                        §§push(§§pop() + §§pop());
                                                                        if(!_loc21_)
                                                                        {
                                                                        }
                                                                        addr690:
                                                                        §§push("/");
                                                                     }
                                                                     §§push(§§pop() + §§pop());
                                                                     if(!_loc21_)
                                                                     {
                                                                     }
                                                                     addr704:
                                                                     §§pop().push(new §§pop().Uri(§§pop()));
                                                                     continue;
                                                                  }
                                                                  §§push(_loc7_);
                                                                  if(_loc21_)
                                                                  {
                                                                     §§push(§§pop() + §§pop());
                                                                     if(_loc21_)
                                                                     {
                                                                        §§goto(addr690);
                                                                     }
                                                                     §§goto(addr704);
                                                                  }
                                                               }
                                                               addr699:
                                                               §§goto(addr704);
                                                               §§push(§§pop() + §§pop());
                                                            }
                                                            §§goto(addr699);
                                                            §§push(FileUtils.getFileName(_loc15_.url));
                                                         }
                                                      }
                                                   }
                                                }
                                                continue;
                                             }
                                             §§push(_loc6_.getDirectoryListing());
                                             if(!_loc20_)
                                             {
                                                §§goto(addr625);
                                             }
                                             else
                                             {
                                                continue;
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                              if(!_loc20_)
                              {
                                 this.processCachedFiles(_loc4_);
                              }
                           }
                        }
                        return;
                     }
                     if(_loc21_)
                     {
                        _loc16_._moduleCount = _loc17_;
                     }
                     if(!_loc20_)
                     {
                        _loc16_._scriptNum = _loc17_;
                     }
                     §§push(ErrorManager);
                     §§push("Failed to load custom module ");
                     if(!_loc20_)
                     {
                        §§push(_loc2_.author);
                        if(!_loc20_)
                        {
                           §§push(§§pop() + §§pop());
                           if(_loc21_)
                           {
                              §§push("_");
                              if(_loc21_)
                              {
                                 §§push(§§pop() + §§pop());
                                 if(!_loc21_)
                                 {
                                 }
                              }
                              addr442:
                              §§push(§§pop() + §§pop());
                           }
                           addr443:
                           §§pop().addError(§§pop());
                           return;
                        }
                        addr438:
                        §§push(§§pop() + §§pop());
                        if(_loc21_)
                        {
                           §§goto(addr442);
                           §§push(", because the local HTTP server is not available.");
                        }
                        §§goto(addr443);
                     }
                     §§goto(addr438);
                     §§push(_loc2_.name);
                  }
                  if(§§pop())
                  {
                     _loc12_ = new Uri(_loc2_.shortcuts);
                     _loc12_.tag = _loc2_.id;
                     if(_loc21_)
                     {
                        this._loader.load(_loc12_);
                     }
                  }
                  §§goto(addr380);
                  §§push(_loc2_.trusted);
               }
               if(_loc8_)
               {
                  if(!_loc20_)
                  {
                     _loc9_ = new Loader();
                     if(!_loc20_)
                     {
                        if(_loc20_)
                        {
                           while(true)
                           {
                              _loc9_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
                              if(_loc21_)
                              {
                                 if(_loc21_)
                                 {
                                    if(!_loc21_)
                                    {
                                       loop8:
                                       while(true)
                                       {
                                          _loc2_.trusted = true;
                                          if(_loc20_)
                                          {
                                          }
                                          addr215:
                                          while(true)
                                          {
                                             if(_loc20_)
                                             {
                                                break loop8;
                                             }
                                             continue loop8;
                                          }
                                       }
                                       if(!_loc2_.shortcuts)
                                       {
                                          if(_loc21_)
                                          {
                                             if(!_loc20_)
                                             {
                                             }
                                             _loc9_.loadBytes(_loc11_,_loc10_);
                                             if(!_loc21_)
                                             {
                                             }
                                          }
                                       }
                                       else
                                       {
                                          this._bytesToLoad[_loc2_.id] = {
                                             "moduleLoader":_loc9_,
                                             "scriptBytes":_loc11_,
                                             "lc":_loc10_
                                          };
                                       }
                                       §§goto(addr299);
                                    }
                                    addr196:
                                    while(true)
                                    {
                                       _loc11_ = new _loc8_() as ByteArray;
                                       if(_loc21_)
                                       {
                                          if(_loc21_)
                                          {
                                          }
                                          §§goto(addr220);
                                       }
                                       break;
                                    }
                                    §§goto(addr247);
                                 }
                                 addr182:
                                 while(true)
                                 {
                                    if(_loc21_)
                                    {
                                    }
                                    AirScanner.allowByteCodeExecution(_loc10_,true);
                                 }
                              }
                              while(!_loc21_)
                              {
                                 §§goto(addr196);
                              }
                           }
                        }
                        while(true)
                        {
                           this._moduleScriptLoadedRef[_loc9_] = _loc2_;
                           §§goto(addr215);
                        }
                     }
                     while(true)
                     {
                        if(_loc21_)
                        {
                        }
                        _loc10_ = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
                        §§goto(addr182);
                     }
                  }
                  else
                  {
                     addr279:
                     if(!_loc20_)
                     {
                        _loc16_._scriptNum = _loc17_;
                     }
                     addr298:
                     if(_loc20_)
                     {
                     }
                     return;
                  }
               }
               else
               {
                  §§push(_log);
                  §§push("Script from module ");
                  if(_loc21_)
                  {
                     §§push(§§pop() + _loc2_.id);
                     if(!_loc21_)
                     {
                     }
                     addr259:
                     §§pop().error(§§pop());
                     if(_loc21_)
                     {
                        if(_loc21_)
                        {
                           _loc16_._moduleCount = _loc17_;
                        }
                        if(_loc21_)
                        {
                           §§goto(addr279);
                        }
                     }
                  }
                  §§goto(addr259);
                  §§push(§§pop() + " has not been embedded, module failed to load");
               }
               _loc2_.trusted = false;
               §§goto(addr298);
            }
            §§goto(addr351);
            §§push(_loc2_.id);
         }
         if(_loc21_)
         {
            §§goto(addr97);
         }
         §§goto(addr333);
      }
      
      private function onScriptLoadFail(param1:IOErrorEvent, param2:UiModule) : void
      {
         var _loc5_:Boolean = true;
         var _loc6_:Boolean = false;
         if(_loc5_)
         {
            §§push(_log);
            §§push("Le script du module ");
            if(_loc5_)
            {
               §§push(§§pop() + param2.id);
               if(!_loc6_)
               {
                  §§push(§§pop() + " est introuvable");
               }
            }
            §§pop().error(§§pop());
            if(!_loc5_)
            {
            }
            addr58:
            addr60:
            this.launchUiCheck();
            return;
         }
         §§push(_loc3_._scriptNum - 1);
         if(_loc5_)
         {
            §§push(_loc4_);
            if(_loc5_)
            {
               _loc3_._scriptNum = _loc4_;
            }
         }
         if(!§§pop())
         {
            if(_loc5_)
            {
               §§goto(addr58);
            }
         }
         §§goto(addr60);
      }
      
      private function onScriptLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc5_:Boolean = true;
         var _loc6_:Boolean = false;
         var _loc2_:UiModule = this._unInitializedModules[param1.uri.tag];
         if(_loc5_)
         {
            this._moduleScriptLoadedRef[_loc3_] = _loc2_;
         }
         var _loc4_:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         if(_loc5_)
         {
            AirScanner.allowByteCodeExecution(_loc4_,true);
            if(!_loc6_)
            {
               if(!_loc5_)
               {
                  addr58:
                  while(true)
                  {
                     _loc3_.loadBytes(param1.resource as ByteArray,_loc4_);
                     if(_loc5_)
                     {
                        if(!_loc6_)
                        {
                        }
                        break;
                     }
                  }
                  return;
               }
               while(true)
               {
                  _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
               }
            }
         }
         while(true)
         {
            if(_loc5_)
            {
               §§goto(addr58);
            }
            §§goto(addr90);
         }
      }
      
      private function onModuleScriptLoaded(param1:Event, param2:UiModule = null) : void
      {
         var _loc6_:Boolean = false;
         _loc3_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
         if(!param2)
         {
            param2 = this._moduleScriptLoadedRef[_loc3_];
            if(!_loc7_)
            {
               while(true)
               {
                  §§push(this._disabledModules);
                  if(!_loc6_)
                  {
                     §§push(param2.id);
                     if(_loc7_)
                     {
                        §§push(delete §§pop()[§§pop()]);
                        if(_loc7_)
                        {
                           §§pop();
                           if(!_loc7_)
                           {
                              addr61:
                              while(true)
                              {
                                 param2.loader = _loc3_;
                                 if(!_loc6_)
                                 {
                                 }
                                 param2.applicationDomain = _loc3_.contentLoaderInfo.applicationDomain;
                                 if(_loc7_)
                                 {
                                 }
                                 param2.mainClass = _loc3_.content;
                                 if(_loc7_)
                                 {
                                 }
                              }
                           }
                           addr175:
                           Berilia.getInstance().handler.process(new ModuleLoadedMessage(param2.id));
                           if(!_loc6_)
                           {
                           }
                           §§push(this._scriptNum - 1);
                           if(!_loc6_)
                           {
                              if(!_loc6_)
                              {
                                 _loc4_._scriptNum = _loc5_;
                              }
                           }
                           if(!§§pop())
                           {
                              this.launchUiCheck();
                           }
                           return;
                        }
                        addr108:
                        while(true)
                        {
                           §§pop();
                           if(_loc7_)
                           {
                           }
                           §§push(_log);
                           §§push("Load script ");
                           if(!_loc6_)
                           {
                              §§push(§§pop() + param2.id);
                              if(!_loc7_)
                              {
                              }
                              addr169:
                              §§pop().trace(§§pop());
                              if(_loc6_)
                              {
                                 break;
                              }
                              §§goto(addr61);
                           }
                           §§push(", ");
                           if(_loc7_)
                           {
                              §§push(§§pop() + §§pop());
                              if(!_loc6_)
                              {
                                 §§push(this._moduleCount);
                                 if(!_loc6_)
                                 {
                                    §§push(§§pop() - this._scriptNum);
                                    if(_loc7_)
                                    {
                                       §§push(1);
                                       if(!_loc7_)
                                       {
                                          §§push(-((§§pop() + 104 - 1 + 1 - 53) * 100) + 93);
                                       }
                                       §§push(§§pop() + §§pop());
                                    }
                                    §§push(§§pop() + §§pop());
                                    if(_loc6_)
                                    {
                                    }
                                    §§goto(addr169);
                                 }
                                 addr168:
                                 §§goto(addr169);
                                 §§push(§§pop() + §§pop());
                              }
                              §§push("/");
                           }
                           §§push(§§pop() + §§pop());
                           if(!_loc6_)
                           {
                              §§goto(addr168);
                              §§push(this._moduleCount);
                           }
                           §§goto(addr169);
                        }
                        §§goto(addr175);
                     }
                     addr93:
                     while(true)
                     {
                        §§pop()[§§pop()] = param2;
                        if(_loc7_)
                        {
                           break;
                        }
                     }
                     continue;
                  }
                  while(true)
                  {
                     §§goto(addr93);
                  }
               }
            }
         }
         while(true)
         {
            §§goto(addr108);
         }
      }
      
      private function onShortcutLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc15_:Boolean = true;
         var _loc16_:Boolean = false;
         var _loc3_:XML = null;
         var _loc4_:* = undefined;
         var _loc5_:ShortcutCategory = null;
         var _loc6_:* = false;
         var _loc8_:Boolean = false;
         var _loc9_:* = false;
         var _loc10_:XML = null;
         var _loc2_:XML = param1.resource;
         if(_loc15_)
         {
            §§push(0);
            if(!_loc15_)
            {
               §§push((§§pop() - 1 - 10 - 1 - 1 + 1) * 15);
            }
            if(!_loc16_)
            {
               if(!_loc16_)
               {
                  for each(_loc3_ in _loc2_..category)
                  {
                     _loc5_ = ShortcutCategory.create(_loc3_.@name,LangManager.getInstance().replaceKey(_loc3_.@description));
                     if(!_loc16_)
                     {
                        §§push(0);
                        if(!_loc15_)
                        {
                           §§push(((§§pop() - 103) * 77 + 68) * 14);
                        }
                        if(!_loc16_)
                        {
                           if(_loc15_)
                           {
                              for each(_loc10_ in _loc3_..shortcut)
                              {
                                 §§push(!_loc10_.@name);
                                 if(_loc15_)
                                 {
                                    §§push(§§pop());
                                    if(!_loc16_)
                                    {
                                       if(!§§pop())
                                       {
                                          if(_loc15_)
                                          {
                                             §§pop();
                                             §§push(!_loc10_.@name.toString().length);
                                          }
                                          addr182:
                                          _loc6_ = §§pop();
                                          addr221:
                                          if(!_loc16_)
                                          {
                                             addr186:
                                             §§push(Boolean(_loc10_.@visible));
                                             §§push(Boolean(_loc10_.@visible));
                                             if(!_loc16_)
                                             {
                                                if(§§pop())
                                                {
                                                   §§pop();
                                                   §§push(_loc10_.@visible == "false");
                                                   if(!_loc15_)
                                                   {
                                                   }
                                                   addr245:
                                                   addr250:
                                                   §§pop();
                                                   if(_loc10_.@holdKeys == "true")
                                                   {
                                                      addr251:
                                                      _loc9_ = true;
                                                   }
                                                   new Shortcut(_loc10_.@name,_loc10_.@textfieldEnabled == "true",LangManager.getInstance().replaceKey(_loc10_.toString()),_loc5_,!_loc6_,_loc7_,_loc8_,_loc9_,LangManager.getInstance().replaceKey(_loc10_.@tooltipContent),_loc10_.@admin == "true");
                                                   continue;
                                                }
                                                if(§§pop())
                                                {
                                                   if(_loc16_)
                                                   {
                                                      continue;
                                                   }
                                                }
                                                _loc8_ = false;
                                                §§push(Boolean(_loc10_.@required));
                                             }
                                          }
                                          if(_loc10_.@required == "true")
                                          {
                                             if(_loc15_)
                                             {
                                                _loc8_ = true;
                                                if(_loc16_)
                                                {
                                                   continue;
                                                }
                                             }
                                             §§goto(addr251);
                                          }
                                          §§push(false);
                                          if(!_loc16_)
                                          {
                                             _loc9_ = §§pop();
                                             if(!_loc16_)
                                             {
                                                addr244:
                                                §§push(Boolean(_loc10_.@holdKeys));
                                                if(Boolean(_loc10_.@holdKeys))
                                                {
                                                   §§goto(addr245);
                                                }
                                             }
                                             else
                                             {
                                                continue;
                                             }
                                          }
                                          §§goto(addr250);
                                       }
                                       if(§§pop())
                                       {
                                          if(_loc15_)
                                          {
                                             §§push(ErrorManager);
                                             §§push("Le fichier de raccourci est mal formé, il manque la priopriété name dans le fichier ");
                                             if(!_loc16_)
                                             {
                                                §§push(§§pop() + param1.uri);
                                             }
                                             §§pop().addError(§§pop());
                                             if(_loc15_)
                                             {
                                             }
                                             addr156:
                                             return;
                                          }
                                          §§goto(addr251);
                                       }
                                       _loc6_ = false;
                                       if(!_loc16_)
                                       {
                                          if(_loc16_)
                                          {
                                             §§goto(addr156);
                                          }
                                          else
                                          {
                                             §§push(Boolean(_loc10_.@permanent));
                                             §§push(Boolean(_loc10_.@permanent));
                                             if(_loc15_)
                                             {
                                                if(§§pop())
                                                {
                                                   §§pop();
                                                   if(!_loc16_)
                                                   {
                                                   }
                                                   §§push(_loc10_.@permanent == "true");
                                                }
                                                if(§§pop())
                                                {
                                                   §§goto(addr182);
                                                   §§push(true);
                                                }
                                                §§goto(addr186);
                                             }
                                          }
                                       }
                                       else
                                       {
                                          continue;
                                       }
                                    }
                                    addr216:
                                    if(§§pop())
                                    {
                                       if(_loc15_)
                                       {
                                          §§pop();
                                          §§goto(addr221);
                                       }
                                    }
                                    §§goto(addr221);
                                 }
                                 §§push(§§pop());
                                 if(_loc15_)
                                 {
                                    §§goto(addr216);
                                 }
                                 §§goto(addr244);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         _loc4_ = this._bytesToLoad[param1.uri.tag];
         if(_loc4_)
         {
            if(!_loc16_)
            {
               _loc4_.moduleLoader.loadBytes(_loc4_.scriptBytes,_loc4_.lc);
               if(!_loc15_)
               {
               }
            }
            delete this._bytesToLoad[param1.uri.tag];
         }
      }
      
      private function onHashLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = true;
         var _loc2_:XML = null;
         if(!_loc5_)
         {
            §§push(0);
            if(!_loc6_)
            {
               §§push(-(§§pop() - 1 - 1 - 94 - 1 + 28));
            }
            if(!_loc5_)
            {
               if(_loc6_)
               {
                  for each(_loc2_ in param1.resource..file)
                  {
                     if(_loc6_)
                     {
                        this._modulesHashs[_loc2_.@name.toString()] = _loc2_.toString();
                     }
                  }
               }
            }
         }
      }
      
      private function onAllUiChecked(param1:ResourceLoaderProgressEvent) : void
      {
         var _loc11_:Boolean = false;
         var _loc3_:UiModule = null;
         var _loc4_:String = null;
         var _loc5_:UiData = null;
         §§push(new Array());
         if(_loc10_)
         {
            §§push(§§pop());
         }
         var _loc2_:* = §§pop();
         if(!_loc11_)
         {
            §§push(0);
            if(!_loc10_)
            {
               §§push(-(§§pop() - 1 + 1 + 4) * 65 - 51);
            }
            if(!_loc11_)
            {
               if(_loc10_)
               {
                  §§push(this._unInitializedModules);
                  if(_loc10_)
                  {
                     if(_loc10_)
                     {
                        for each(_loc3_ in §§pop())
                        {
                           if(!_loc11_)
                           {
                              §§push(0);
                              if(_loc11_)
                              {
                                 §§push(-(-(§§pop() + 1) * 77 + 1));
                              }
                              if(!_loc11_)
                              {
                                 if(!_loc11_)
                                 {
                                    for each(_loc5_ in _loc3_.uis)
                                    {
                                       if(_loc10_)
                                       {
                                          _loc2_[UiData(_loc5_).file] = _loc5_;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     if(!_loc11_)
                     {
                        if(_loc11_)
                        {
                        }
                        addr128:
                        §§push(0);
                        if(!_loc10_)
                        {
                           §§push(§§pop() - 83 + 1 - 111 - 87 - 1);
                        }
                     }
                     addr213:
                     if(!_loc11_)
                     {
                        addr220:
                        this._unparsedXmlCount = this._unparsedXmlTotalCount = this._unparsedXml.length;
                        if(_loc10_)
                        {
                           this.parseNextXml();
                        }
                     }
                     return;
                  }
                  addr144:
                  if(_loc10_)
                  {
                     loop2:
                     while(§§hasnext(§§pop(),_loc6_))
                     {
                        if(_loc11_)
                        {
                           addr156:
                           while(true)
                           {
                              UiRenderManager.getInstance().clearCacheFromId(_loc4_);
                              if(_loc10_)
                              {
                                 if(!_loc11_)
                                 {
                                 }
                                 addr181:
                                 UiRenderManager.getInstance().setUiVersion(_loc4_,this._clearUi[_loc4_]);
                                 if(_loc10_)
                                 {
                                    break;
                                 }
                                 addr204:
                                 this._unparsedXml.push(_loc2_[_loc4_]);
                                 continue loop2;
                              }
                              break;
                           }
                           if(!_loc11_)
                           {
                           }
                           §§push(_loc2_);
                           if(!_loc11_)
                           {
                              if(§§pop()[_loc4_])
                              {
                                 if(!_loc11_)
                                 {
                                    §§goto(addr204);
                                 }
                                 else
                                 {
                                    continue;
                                 }
                              }
                              else
                              {
                                 continue;
                              }
                           }
                           §§goto(addr204);
                        }
                        while(true)
                        {
                           _loc4_ = §§nextname(_loc6_,_loc7_);
                           if(_loc10_)
                           {
                              if(!_loc11_)
                              {
                                 §§goto(addr156);
                              }
                              §§goto(addr181);
                           }
                           §§goto(addr192);
                        }
                     }
                  }
                  §§goto(addr213);
               }
               addr142:
               §§goto(addr144);
               §§push(this._clearUi);
            }
            if(!_loc11_)
            {
               §§goto(addr142);
            }
            §§goto(addr213);
         }
         this._unparsedXml = [];
         if(_loc10_)
         {
            §§goto(addr128);
         }
         §§goto(addr220);
      }
      
      private function parseNextXml() : void
      {
         var _loc6_:Boolean = false;
         var _loc2_:XmlParsor = null;
         this._unparsedXmlCount = this._unparsedXml.length;
         §§push(this._unparsedXml);
         if(!_loc6_)
         {
            if(§§pop().length)
            {
               if(this._parserAvaibleCount)
               {
                  if(!_loc6_)
                  {
                     if(_loc5_)
                     {
                        _loc3_._parserAvaibleCount = _loc4_;
                     }
                     if(_loc5_)
                     {
                        §§push(this._unparsedXml);
                     }
                     else
                     {
                        addr154:
                        while(true)
                        {
                           if(!_loc6_)
                           {
                           }
                        }
                     }
                     addr174:
                     return;
                  }
                  addr169:
                  while(true)
                  {
                     if(_loc5_)
                     {
                        addr151:
                        while(true)
                        {
                           this.launchModule();
                           §§goto(addr154);
                        }
                     }
                     §§goto(addr174);
                  }
               }
               addr142:
               §§goto(addr174);
            }
            else
            {
               BindsManager.getInstance().checkBinds();
               if(_loc6_)
               {
                  §§goto(addr151);
               }
            }
            while(true)
            {
               Berilia.getInstance().handler.process(new AllUiXmlParsedMessage());
               §§goto(addr169);
            }
         }
         if(!_loc6_)
         {
         }
         _loc2_ = new XmlParsor();
         if(!_loc6_)
         {
            if(_loc5_)
            {
            }
            _loc2_.rootPath = _loc1_.module.rootPath;
            if(!_loc6_)
            {
               if(_loc6_)
               {
                  addr92:
                  while(true)
                  {
                     _loc2_.addEventListener(ParsingErrorEvent.ERROR,this.onXmlParsingError);
                     if(_loc5_)
                     {
                        if(!_loc6_)
                        {
                           if(!_loc6_)
                           {
                           }
                           addr136:
                           _loc2_.processFile(_loc1_.file);
                           break;
                        }
                     }
                     break;
                  }
               }
               while(true)
               {
                  §§push(_loc2_);
                  §§push(Event.COMPLETE);
                  §§push(this.onXmlParsed);
                  §§push(false);
                  §§push(0);
                  if(!_loc5_)
                  {
                     §§push((-§§pop() - 84) * 71 + 25 + 1 - 83 + 17);
                  }
                  §§pop().addEventListener(§§pop(),§§pop(),§§pop(),§§pop(),true);
               }
            }
            while(true)
            {
               if(_loc6_)
               {
                  break;
               }
               §§goto(addr92);
            }
            §§goto(addr136);
         }
         if(_loc5_)
         {
         }
         §§goto(addr142);
      }
      
      private function onXmlParsed(param1:ParsorEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = true;
         if(param1.uiDefinition)
         {
            param1.uiDefinition.name = XmlParsor(param1.target).url;
            UiRenderManager.getInstance().setUiDefinition(param1.uiDefinition);
            Berilia.getInstance().handler.process(new UiXmlParsedMessage(param1.uiDefinition.name));
         }
         if(!_loc4_)
         {
            _loc2_._parserAvaibleCount = _loc3_;
         }
         this.parseNextXml();
      }
      
      private function onXmlParsingError(param1:ParsingErrorEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            Berilia.getInstance().handler.process(new UiXmlParsedErrorMessage(param1.url,param1.msg));
         }
      }
      
      private function onUiLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = true;
         var _loc8_:Array = null;
         var _loc9_:* = null;
         var _loc10_:String = null;
         var _loc11_:Uri = null;
         if(!_loc14_)
         {
            if(!this._resetState)
            {
               var _loc2_:int = this._uiFiles.indexOf(param1.uri);
               if(_loc15_)
               {
                  §§push(this._uiFiles);
                  if(_loc15_)
                  {
                     §§push(this._uiFiles.indexOf(param1.uri));
                     §§push(1);
                     if(_loc14_)
                     {
                        §§push((§§pop() + 1 - 54) * 5 + 1 - 1);
                     }
                     §§pop().splice(§§pop(),§§pop());
                  }
                  addr64:
                  var _loc3_:UiModule = §§pop()[param1.uri.tag.mod];
                  var _loc4_:String = param1.uri.tag.base;
                  if(_loc15_)
                  {
                     §§push(this._versions);
                     if(_loc15_)
                     {
                        §§push(param1.uri.uri);
                        if(_loc15_)
                        {
                           if(§§pop()[§§pop()] == null)
                           {
                              §§push(MD5.hash(param1.resource as String));
                              if(!_loc14_)
                              {
                                 §§push(§§pop());
                                 if(_loc15_)
                                 {
                                    addr116:
                                    §§push(§§pop());
                                 }
                              }
                           }
                           var _loc5_:* = §§pop();
                           var _loc6_:* = _loc5_ == UiRenderManager.getInstance().getUiVersion(param1.uri.uri);
                           if(!_loc6_)
                           {
                              if(_loc15_)
                              {
                                 §§push(this._clearUi);
                                 if(_loc15_)
                                 {
                                    §§push(param1.uri.uri);
                                    if(_loc15_)
                                    {
                                       §§push(_loc5_);
                                       if(!_loc14_)
                                       {
                                          §§pop()[§§pop()] = §§pop();
                                          if(_loc15_)
                                          {
                                             if(param1.uri.tag.template)
                                             {
                                                if(_loc14_)
                                                {
                                                }
                                                addr181:
                                                §§push(param1.resource as String);
                                                if(_loc15_)
                                                {
                                                   §§push(§§pop());
                                                }
                                                var _loc7_:* = §§pop();
                                                if(!_loc14_)
                                                {
                                                   while(_loc8_ = this._regImport.exec(_loc7_))
                                                   {
                                                      §§push(LangManager.getInstance());
                                                      §§push(_loc8_);
                                                      §§push(1);
                                                      if(_loc14_)
                                                      {
                                                         §§push(§§pop() * 103 * 0 + 104 - 1 - 1 + 84);
                                                      }
                                                      §§push(§§pop().replaceKey(§§pop()[§§pop()]));
                                                      if(!_loc14_)
                                                      {
                                                         §§push(§§pop());
                                                         if(!_loc14_)
                                                         {
                                                            _loc9_ = §§pop();
                                                            §§push("mod://");
                                                            if(!_loc14_)
                                                            {
                                                               §§push(§§pop().indexOf(§§pop()));
                                                               §§push(-1);
                                                               if(!_loc15_)
                                                               {
                                                                  §§push(-(§§pop() + 50 + 3) - 1);
                                                               }
                                                               if(§§pop() != §§pop())
                                                               {
                                                                  §§push(_loc9_);
                                                                  §§push(6);
                                                                  if(_loc14_)
                                                                  {
                                                                     §§push(-§§pop() + 5 + 86 - 13);
                                                                  }
                                                                  §§push(_loc9_);
                                                                  §§push("/");
                                                                  §§push(6);
                                                                  if(_loc14_)
                                                                  {
                                                                     §§push(-(§§pop() + 1 + 80));
                                                                  }
                                                                  §§push(§§pop().indexOf(§§pop(),§§pop()));
                                                                  §§push(6);
                                                                  if(!_loc15_)
                                                                  {
                                                                     §§push(((-(§§pop() + 1) - 109) * 86 - 91 + 10) * 98);
                                                                  }
                                                                  _loc10_ = §§pop().substr(§§pop(),§§pop() - §§pop());
                                                                  if(_loc15_)
                                                                  {
                                                                     §§push(this._modulesPaths[_loc10_]);
                                                                     §§push(_loc9_);
                                                                     §§push(6);
                                                                     if(_loc14_)
                                                                     {
                                                                        §§push(§§pop() * 5 - 1 - 1 + 1);
                                                                     }
                                                                     §§push(§§pop() + §§pop().substr(§§pop() + _loc10_.length));
                                                                     if(_loc15_)
                                                                     {
                                                                        _loc9_ = §§pop();
                                                                     }
                                                                     else
                                                                     {
                                                                        addr348:
                                                                        §§push(_loc9_);
                                                                     }
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  §§push(_loc9_);
                                                                  §§push(":");
                                                                  if(!_loc14_)
                                                                  {
                                                                     §§push(§§pop().indexOf(§§pop()));
                                                                     §§push(-1);
                                                                     if(_loc14_)
                                                                     {
                                                                        §§push(--§§pop() + 12 + 77 - 1 + 1);
                                                                     }
                                                                     §§push(§§pop() == §§pop());
                                                                     if(_loc15_)
                                                                     {
                                                                        if(§§pop())
                                                                        {
                                                                           if(_loc14_)
                                                                           {
                                                                           }
                                                                        }
                                                                        addr345:
                                                                        if(§§pop())
                                                                        {
                                                                           §§goto(addr348);
                                                                           §§push(_loc3_.rootPath);
                                                                        }
                                                                     }
                                                                     §§pop();
                                                                     §§push(_loc9_);
                                                                  }
                                                               }
                                                               addr352:
                                                               §§push(this._clearUi);
                                                               if(!_loc14_)
                                                               {
                                                                  §§push(_loc9_);
                                                                  if(_loc15_)
                                                                  {
                                                                     if(§§pop()[§§pop()])
                                                                     {
                                                                        if(!_loc14_)
                                                                        {
                                                                           §§push(this._clearUi);
                                                                           if(_loc14_)
                                                                           {
                                                                           }
                                                                           addr378:
                                                                           §§pop()[_loc4_] = this._versions[_loc4_];
                                                                           continue;
                                                                        }
                                                                     }
                                                                     else if(this._uiLoaded[_loc9_])
                                                                     {
                                                                        continue;
                                                                     }
                                                                     this._uiLoaded[_loc9_] = true;
                                                                     if(_loc15_)
                                                                     {
                                                                        _loc12_._uiFileToLoad = _loc13_;
                                                                     }
                                                                     _loc11_ = new Uri(_loc9_);
                                                                     _loc11_.tag = {
                                                                        "mod":_loc3_.id,
                                                                        "base":_loc4_,
                                                                        "template":true
                                                                     };
                                                                     if(!_loc14_)
                                                                     {
                                                                        this._uiLoader.load(_loc11_,null,TxtAdapter);
                                                                     }
                                                                     continue;
                                                                  }
                                                                  addr374:
                                                                  §§pop()[§§pop()] = _loc5_;
                                                                  §§goto(addr378);
                                                                  §§push(this._clearUi);
                                                               }
                                                               §§push(param1.uri.uri);
                                                               if(_loc15_)
                                                               {
                                                                  §§goto(addr374);
                                                               }
                                                               §§goto(addr378);
                                                            }
                                                            addr332:
                                                            §§push(§§pop().indexOf(§§pop()));
                                                            §§push(-1);
                                                            if(!_loc15_)
                                                            {
                                                               §§push(-(§§pop() + 1) - 50 - 116 - 106);
                                                            }
                                                            §§goto(addr345);
                                                            §§push(§§pop() == §§pop());
                                                         }
                                                         _loc9_ = §§pop() + §§pop();
                                                         §§goto(addr352);
                                                      }
                                                      §§goto(addr332);
                                                      §§push("ui/Ankama_Common");
                                                   }
                                                   if(_loc15_)
                                                   {
                                                      §§push(this._uiFileToLoad - 1);
                                                      if(!_loc14_)
                                                      {
                                                         if(_loc15_)
                                                         {
                                                            _loc12_._uiFileToLoad = _loc13_;
                                                         }
                                                      }
                                                      if(!§§pop())
                                                      {
                                                         if(!_loc15_)
                                                         {
                                                         }
                                                      }
                                                      addr473:
                                                      return;
                                                   }
                                                }
                                                this.onAllUiChecked(null);
                                                §§goto(addr473);
                                             }
                                          }
                                          §§push(this._clearUi);
                                          if(_loc15_)
                                          {
                                             §§pop()[param1.uri.tag.base] = this._versions[param1.uri.tag.base];
                                             if(_loc14_)
                                             {
                                             }
                                             §§goto(addr181);
                                          }
                                       }
                                       addr180:
                                       §§pop()[§§pop()] = §§pop();
                                       §§goto(addr181);
                                    }
                                    addr179:
                                    §§goto(addr180);
                                    §§push(_loc5_);
                                 }
                                 addr176:
                                 §§goto(addr179);
                                 §§push(param1.uri.uri);
                              }
                           }
                           §§goto(addr176);
                           §§push(this._versions);
                        }
                        addr97:
                        §§push(§§pop()[§§pop()]);
                        if(!_loc15_)
                        {
                        }
                        §§goto(addr116);
                     }
                     addr94:
                     §§goto(addr97);
                     §§push(param1.uri.uri);
                  }
                  §§goto(addr94);
                  §§push(this._versions);
               }
               §§goto(addr64);
               §§push(this._unInitializedModules);
            }
         }
      }
      
      private function searchDmFile(param1:File) : File
      {
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = true;
         var _loc3_:File = null;
         var _loc4_:File = null;
         if(!_loc7_)
         {
            §§push(param1.nativePath.indexOf(".svn"));
            §§push(-1);
            if(!_loc8_)
            {
               §§push(§§pop() + 1 - 1 - 1 + 1 + 1);
            }
            if(§§pop() == §§pop())
            {
               var _loc2_:Array = param1.getDirectoryListing();
               if(_loc8_)
               {
                  §§push(0);
                  if(_loc7_)
                  {
                     §§push(-(-(§§pop() - 1) + 106 - 52 + 1 - 1));
                  }
                  if(!_loc7_)
                  {
                     if(!_loc7_)
                     {
                        §§push(_loc2_);
                        if(_loc8_)
                        {
                           if(_loc8_)
                           {
                              while(true)
                              {
                                 for each(_loc3_ in §§pop())
                                 {
                                    if(!_loc7_)
                                    {
                                       §§push(!_loc3_.isDirectory);
                                       if(!_loc7_)
                                       {
                                          §§push(§§pop());
                                          if(!_loc7_)
                                          {
                                             if(§§pop())
                                             {
                                                if(!_loc8_)
                                                {
                                                }
                                             }
                                             addr105:
                                             if(§§pop())
                                             {
                                                if(_loc8_)
                                                {
                                                   if(_loc3_.extension.toLowerCase() == "d2ui")
                                                   {
                                                      if(!_loc7_)
                                                      {
                                                         break;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      §§push(!_loc4_);
                                                      if(!_loc7_)
                                                      {
                                                         addr123:
                                                         §§push(§§pop());
                                                      }
                                                      addr136:
                                                      if(!§§pop())
                                                      {
                                                         continue;
                                                      }
                                                   }
                                                }
                                                addr137:
                                                _loc4_ = _loc3_;
                                             }
                                             continue;
                                          }
                                          if(§§pop())
                                          {
                                             if(_loc8_)
                                             {
                                                §§pop();
                                                if(!_loc7_)
                                                {
                                                   addr131:
                                                   §§push(_loc3_.extension.toLowerCase() == "dm");
                                                }
                                                §§goto(addr137);
                                             }
                                          }
                                          §§goto(addr136);
                                       }
                                       §§pop();
                                       if(!_loc7_)
                                       {
                                          §§push(Boolean(_loc3_.extension));
                                          if(!_loc7_)
                                          {
                                             §§goto(addr105);
                                          }
                                          §§goto(addr123);
                                       }
                                       §§goto(addr131);
                                    }
                                    break;
                                 }
                              }
                              return _loc3_;
                           }
                           if(!_loc7_)
                           {
                              if(!_loc7_)
                              {
                                 if(!_loc4_)
                                 {
                                    §§push(0);
                                    if(!_loc8_)
                                    {
                                       §§push(--(§§pop() * 86 + 105 + 1 + 1) - 1);
                                    }
                                 }
                              }
                           }
                        }
                        addr166:
                        if(!_loc7_)
                        {
                           for each(_loc3_ in §§pop())
                           {
                              if(!_loc7_)
                              {
                                 if(!_loc3_.isDirectory)
                                 {
                                    continue;
                                 }
                              }
                              _loc4_ = this.searchDmFile(_loc3_);
                              if(_loc4_)
                              {
                                 break;
                              }
                           }
                        }
                        return _loc4_;
                     }
                     addr165:
                     §§goto(addr166);
                     §§push(_loc2_);
                  }
                  §§goto(addr165);
               }
               return _loc4_;
            }
         }
         return null;
      }
      
      public function set trustedModuleScripts(param1:Array) : void
      {
         this._trustedModuleScripts = param1;
      }
   }
}
