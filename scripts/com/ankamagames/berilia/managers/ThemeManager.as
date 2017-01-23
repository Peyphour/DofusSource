package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.Theme;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.messages.NoThemeErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadedMessage;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.utils.ThemeFlashProtocol;
   import com.ankamagames.berilia.utils.ThemeProtocol;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.protocols.ProtocolFactory;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class ThemeManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ThemeManager));
      
      public static const OFFICIAL_THEME_NAME:String = "darkStone";
      
      private static var _self:ThemeManager;
       
      
      private var _loader:IResourceLoader;
      
      private var _themes:Array;
      
      private var _themeNames:Array;
      
      private var _dtFileToLoad:uint = 0;
      
      private var _themeCount:uint = 0;
      
      private var _themesRoot:File;
      
      private var _currentTheme:Theme;
      
      private var _applyWaiting:String = "";
      
      private var _themeDataCache:Dictionary;
      
      private var _customThemesPath:String = "";
      
      private var _officialThemesPath:String = "";
      
      private var _needAdditionalCheck:Boolean;
      
      public function ThemeManager()
      {
         this._themeDataCache = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad,false,0,true);
         if(AirScanner.isStreamingVersion())
         {
            ProtocolFactory.addProtocol("theme",ThemeFlashProtocol);
         }
         else
         {
            ProtocolFactory.addProtocol("theme",ThemeProtocol);
         }
      }
      
      public static function getInstance() : ThemeManager
      {
         if(!_self)
         {
            _self = new ThemeManager();
         }
         return _self;
      }
      
      public function get customThemesPath() : String
      {
         return this._customThemesPath;
      }
      
      public function get themesRoot() : File
      {
         return this._themesRoot;
      }
      
      public function get themeCount() : uint
      {
         return this._themeCount;
      }
      
      public function get currentTheme() : String
      {
         return this._currentTheme.fileName;
      }
      
      public function get themeData() : Object
      {
         return this._currentTheme.data;
      }
      
      public function init(param1:String, param2:String, param3:Boolean = false) : void
      {
         this._needAdditionalCheck = param3;
         this._themes = new Array();
         this._themeNames = new Array();
         this._themeCount = 0;
         this._dtFileToLoad = 0;
         this._officialThemesPath = param1;
         this._customThemesPath = param2;
         this.initPath(this._officialThemesPath,true);
         this.initPath(this._customThemesPath,false);
      }
      
      private function initPath(param1:String, param2:Boolean) : void
      {
         var _loc4_:File = null;
         var _loc3_:File = new File(param1);
         if(_loc3_.exists)
         {
            if(param2)
            {
               this._themesRoot = _loc3_;
            }
            for each(_loc4_ in _loc3_.getDirectoryListing())
            {
               this.initTheme(_loc4_,param2);
            }
         }
      }
      
      public function initTheme(param1:File, param2:Boolean = false) : void
      {
         var _loc3_:Uri = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:FileStream = null;
         var _loc9_:XML = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         if(!param1.isDirectory || param1.name.charAt(0) == ".")
         {
            return;
         }
         if(this._needAdditionalCheck && param2 && param1.name != ThemeManager.OFFICIAL_THEME_NAME)
         {
            _log.warn("Won\'t load unofficial theme from " + param1.nativePath);
            return;
         }
         var _loc4_:* = XmlConfig.getInstance().getBooleanEntry("config.dev.mode") == "true";
         if(!param2 && !_loc4_ && !ThemeInstallerSecurity.checkSecurity(param1))
         {
            Berilia.getInstance().handler.process(new ThemeLoadErrorMessage(param1.name));
            return;
         }
         var _loc5_:File = this.searchDtFile(param1);
         if(_loc5_)
         {
            this._dtFileToLoad++;
            if(_loc5_.url.indexOf("app:/") == 0)
            {
               _loc6_ = "app:/".length;
               _loc7_ = _loc5_.url.substring(_loc6_,_loc5_.url.length);
               _loc3_ = new Uri(_loc7_);
            }
            else
            {
               _loc3_ = new Uri(_loc5_.nativePath,false);
            }
            _loc3_.tag = _loc5_;
            if(SystemManager.getSingleton().os == OperatingSystem.MAC_OS)
            {
               _log.debug("Using FileStream to load " + _loc5_.nativePath + " on MAC OS X!");
               _loc8_ = new FileStream();
               _loc8_.open(_loc5_,FileMode.READ);
               _loc9_ = XML(_loc8_.readUTFBytes(_loc8_.bytesAvailable));
               _loc8_.close();
               _loc10_ = _loc3_.path.split("/");
               _loc11_ = _loc3_.path.slice(0,_loc3_.path.lastIndexOf("/") + 1);
               this.loadDT(_loc9_,_loc3_.fileName.split(".")[0],_loc10_[_loc10_.length - 2],_loc11_);
            }
            else
            {
               this._loader.load(_loc3_);
            }
         }
         else if(!(param2 && (param1.name == "dofus1" || param1.name == "black")))
         {
            _log.error("Impossible de trouver le fichier de description de thème dans le dossier " + param1.nativePath);
            Berilia.getInstance().handler.process(new ThemeLoadErrorMessage(param1.name));
         }
      }
      
      public function getThemes() : Array
      {
         return this._themes;
      }
      
      public function getTheme(param1:String) : Theme
      {
         return this._themes[param1];
      }
      
      public function getThemeByAuthorAndName(param1:String) : Theme
      {
         var _loc2_:Theme = null;
         for each(_loc2_ in this._themes)
         {
            if(param1 == _loc2_.author + "_" + _loc2_.name)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function applyTheme(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Theme = null;
         if(this._dtFileToLoad == this._themeCount)
         {
            if(this._themeNames.length == 0)
            {
               Berilia.getInstance().handler.process(new NoThemeErrorMessage());
            }
            else
            {
               this._applyWaiting = null;
               if(!this._themes[param1])
               {
                  for each(_loc3_ in this._themes)
                  {
                     if(_loc3_.official && _loc3_.type == 1)
                     {
                        param1 = _loc3_.id;
                        break;
                     }
                  }
                  OptionManager.getOptionManager("dofus")["currentUiSkin"] = param1;
                  UiRenderManager.getInstance().clearCache();
               }
               this._currentTheme = this._themes[param1];
               if(this._currentTheme.type == Theme.TYPE_OLD)
               {
                  _log.error("Specified theme is no more compatible (skinType 1).");
                  return;
               }
               if(!this._currentTheme.official && !AirScanner.isStreamingVersion())
               {
                  Uri.unescapeThemePath = unescape(new File(this._currentTheme.folderFullPath).nativePath);
               }
               _loc2_ = !!AirScanner.isStreamingVersion()?LangManager.getInstance().getEntry("config.ui.common.themes") + param1 + "/":this._currentTheme.folderFullPath;
               LangManager.getInstance().setEntry("config.ui.skin",_loc2_,"string");
               XmlConfig.getInstance().setEntry("config.ui.skin",_loc2_);
               LangManager.getInstance().loadFile(_loc2_ + "colors.xml");
               this.loadThemeData(param1);
            }
         }
         else
         {
            this._applyWaiting = param1;
         }
      }
      
      public function loadThemeData(param1:String = null) : void
      {
         var _loc7_:File = null;
         var _loc2_:String = !!param1?this._themes[param1].folderFullPath:this._currentTheme.folderFullPath;
         var _loc3_:Uri = new Uri(_loc2_);
         var _loc4_:File = _loc3_.toFile();
         var _loc5_:Array = _loc4_.getDirectoryListing();
         var _loc6_:Array = new Array();
         for each(_loc7_ in _loc5_)
         {
            if(_loc7_.extension && _loc7_.extension.toLowerCase() == "json")
            {
               _loc6_.push(new Uri(_loc7_.nativePath));
            }
         }
         this._loader.load(_loc6_);
      }
      
      public function applyThemeData(param1:GraphicContainer, param2:String = null) : Boolean
      {
         var targetInfo:Dictionary = null;
         var userData:Object = null;
         var key:String = null;
         var value:* = undefined;
         var l:int = 0;
         var obj:* = undefined;
         var i:int = 0;
         var filteClassName:* = undefined;
         var target:GraphicContainer = param1;
         var forceThemeDataId:String = param2;
         if(target == null)
         {
            return false;
         }
         if(forceThemeDataId == null)
         {
            forceThemeDataId = target.themeDataId;
            if(forceThemeDataId == null)
            {
               return false;
            }
         }
         if(!this.themeData || !this.themeData[forceThemeDataId])
         {
            return false;
         }
         var wantedThemeData:Dictionary = this._themeDataCache[forceThemeDataId];
         if(!wantedThemeData)
         {
            wantedThemeData = new Dictionary();
            this._themeDataCache[forceThemeDataId] = wantedThemeData;
         }
         userData = this.themeData[forceThemeDataId];
         for(key in userData)
         {
            if(target.hasOwnProperty(key))
            {
               if(wantedThemeData[key])
               {
                  target[key] = wantedThemeData[key];
               }
               else
               {
                  if(!targetInfo)
                  {
                     targetInfo = DescribeTypeCache.getVariableAndAccessorType(target);
                  }
                  if(targetInfo[key])
                  {
                     switch(targetInfo[key])
                     {
                        case "uint":
                        case "int":
                           value = userData[key] is String?parseInt(LangManager.getInstance().replaceKey(userData[key])):userData[key];
                           break;
                        case "Number":
                           value = userData[key] is String?parseFloat(LangManager.getInstance().replaceKey(userData[key])):userData[key];
                           break;
                        case "Boolean":
                           value = userData[key] is String?LangManager.getInstance().replaceKey(userData[key]).toLowerCase() == "true":userData[key] == 1;
                           break;
                        case "String":
                           value = LangManager.getInstance().replaceKey(userData[key]);
                           break;
                        case "Array":
                           value = [];
                           l = userData[key].length;
                           i = 0;
                           while(i < l)
                           {
                              for(filteClassName in userData[key][0])
                              {
                                 obj = new getDefinitionByName(filteClassName)();
                              }
                              this.setMembers(obj,userData[key][i][filteClassName]);
                              value.push(obj);
                              i++;
                           }
                           break;
                        case "com.ankamagames.jerakine.types::Uri":
                           try
                           {
                              value = new Uri(LangManager.getInstance().replaceKey(userData[key]));
                           }
                           catch(e:Error)
                           {
                              _log.error(e);
                           }
                           break;
                        case "flash.geom::Point":
                        case "flash.geom::Rectangle":
                        case "flash.geom::ColorTransform":
                        case "com.ankamagames.berilia.types.data::Margin":
                           try
                           {
                              value = new getDefinitionByName(targetInfo[key])();
                              this.setMembers(value,userData[key]);
                           }
                           catch(e:Error)
                           {
                              _log.error(e);
                           }
                           break;
                        default:
                           _log.warn("Trying to set " + key + " on " + target + " (data from themeData [" + forceThemeDataId + "]) but " + targetInfo[key] + " is not supported through JSon file");
                           continue;
                     }
                     wantedThemeData[key] = value;
                     target[key] = wantedThemeData[key];
                  }
                  else
                  {
                     _log.warn("Trying to set " + key + " but it don\'t exist on " + target + " (data from themeData [" + forceThemeDataId + "])");
                  }
               }
            }
         }
         return true;
      }
      
      public function clearThemeData() : void
      {
         this._themeDataCache = new Dictionary();
         this._currentTheme.data = null;
      }
      
      public function deleteTheme(param1:String) : void
      {
         delete this._themes[param1];
         this._themeNames.splice(this._themeNames.indexOf(param1),1);
      }
      
      private function setMembers(param1:Object, param2:Object) : void
      {
         var rectKey:String = null;
         var value:Object = param1;
         var userData:Object = param2;
         if(!value)
         {
            return;
         }
         for(rectKey in userData)
         {
            if(Object(value).hasOwnProperty(rectKey))
            {
               try
               {
                  if(userData[rectKey] is Boolean)
                  {
                     value[rectKey] = userData[rectKey];
                  }
                  else
                  {
                     value[rectKey] = parseFloat(LangManager.getInstance().replaceKey(userData[rectKey]));
                     value[rectKey] = !!isNaN(value[rectKey])?0:value[rectKey];
                  }
               }
               catch(e:Error)
               {
                  _log.error(e.toString());
                  continue;
               }
            }
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         var _loc3_:File = null;
         _log.error("Cannot load " + param1.uri + "(" + param1.errorMsg + ")");
         if(param1.uri.fileType.toLowerCase() == "json")
         {
            return;
         }
         var _loc2_:String = param1.uri.toString();
         try
         {
            _loc3_ = param1.uri.toFile();
            _loc2_ = _loc2_ + ("(" + _loc3_.nativePath + ")");
         }
         catch(e:Error)
         {
         }
         ErrorManager.addError("Cannot load " + _loc2_);
         Berilia.getInstance().handler.process(new ThemeLoadErrorMessage(param1.uri.fileName));
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         switch(param1.uri.fileType.toLowerCase())
         {
            case "dt":
               this.onDTLoad(param1);
               break;
            case "json":
               if(!this._currentTheme.data)
               {
                  this._themeDataCache = new Dictionary();
                  this._currentTheme.data = param1.resource;
               }
               else
               {
                  _loc2_ = param1.resource;
                  for(_loc3_ in _loc2_)
                  {
                     if(this._currentTheme.data[_loc3_])
                     {
                        _log.warn("Overwriting property " + _loc3_ + " in themeData with values from " + param1.uri.fileName);
                     }
                     this._currentTheme.data[_loc3_] = _loc2_[_loc3_];
                  }
               }
         }
      }
      
      private function onDTLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = param1.resource as XML;
         var _loc3_:String = param1.uri.fileName.split(".")[0];
         var _loc4_:Array = param1.uri.path.split("/");
         var _loc5_:String = _loc4_[_loc4_.length - 2];
         var _loc6_:String = param1.uri.path.slice(0,param1.uri.path.lastIndexOf("/") + 1);
         this.loadDT(_loc2_,_loc3_,_loc5_,_loc6_);
      }
      
      private function loadDT(param1:XML, param2:String, param3:String, param4:String) : void
      {
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         this._themeCount++;
         var _loc5_:String = param1.name;
         var _loc6_:String = param1.description;
         var _loc7_:File = new File(this._officialThemesPath);
         var _loc8_:File = new File(param4);
         var _loc9_:* = _loc8_.nativePath.indexOf(_loc7_.nativePath) != -1;
         var _loc10_:uint = !!_loc9_?uint(parseInt(param1.skinType)):uint(1);
         var _loc11_:String = !!param1.author?param1.author:"";
         var _loc12_:String = !!param1.creationDate?param1.creationDate:"";
         var _loc13_:String = !!param1.modificationDate?param1.modificationDate:"";
         if(param1.version && param1.version.toString().indexOf(".") != -1)
         {
            _loc14_ = String(param1.version).split(".");
            _loc14_ = _loc14_.length > 3?_loc14_.slice(0,3):_loc14_;
            while(_loc14_.length < 3)
            {
               _loc14_.push(0);
            }
         }
         else
         {
            _loc14_ = ["0","0","0"];
         }
         if(param1.dofusVersion && param1.dofusVersion.toString().indexOf(".") != -1)
         {
            _loc15_ = String(param1.dofusVersion).split(".");
            _loc15_ = _loc15_.length > 3?_loc15_.slice(0,3):_loc15_;
            while(_loc15_.length < 3)
            {
               _loc15_.push(0);
            }
         }
         else
         {
            _loc15_ = ["0","0","0"];
         }
         var _loc16_:String = !!_loc9_?_loc8_.name:param4;
         var _loc17_:Theme = new Theme(_loc16_,param2,param4,_loc5_,_loc11_,_loc6_,param1.previewUri,_loc10_,_loc9_,_loc14_,_loc15_,_loc12_,_loc13_);
         this._themes[_loc16_] = _loc17_;
         this._themeNames.push(_loc16_);
         if(this._applyWaiting && this._applyWaiting != "")
         {
            this.applyTheme(this._applyWaiting);
         }
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.ThemeInstallationProgress,1);
         Berilia.getInstance().handler.process(new ThemeLoadedMessage(param3));
      }
      
      private function searchDtFile(param1:File) : File
      {
         var _loc3_:File = null;
         var _loc4_:File = null;
         if(param1.nativePath.indexOf(".svn") != -1)
         {
            return null;
         }
         var _loc2_:Array = param1.getDirectoryListing();
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.isDirectory && _loc3_.extension.toLowerCase() == "dt")
            {
               return _loc3_;
            }
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.isDirectory)
            {
               _loc4_ = this.searchDtFile(_loc3_);
               if(_loc4_)
               {
                  break;
               }
            }
         }
         return _loc4_;
      }
   }
}
