package
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.CharacterWheel;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.MapViewer;
   import com.ankamagames.berilia.interfaces.IApplicationContainer;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiPerformanceManager;
   import com.ankamagames.berilia.utils.web.HttpServer;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.console.moduleLUA.ConsoleLUA;
   import com.ankamagames.dofus.console.moduleLogger.Console;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.RegSoundManager;
   import com.ankamagames.dofus.logic.connection.frames.InitializationFrame;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.common.managers.SteamManager;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.interClient.AppIdModifier;
   import com.ankamagames.dofus.misc.interClient.InterClientManager;
   import com.ankamagames.dofus.misc.utils.CursorConstant;
   import com.ankamagames.dofus.misc.utils.EmbedAssets;
   import com.ankamagames.dofus.misc.utils.HaapiDebugManager;
   import com.ankamagames.dofus.misc.utils.errormanager.DofusErrorHandler;
   import com.ankamagames.dofus.misc.utils.errormanager.WebServiceDataHandler;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.PartStateEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.updater.ContentPart;
   import com.ankamagames.dofus.types.DofusOptions;
   import com.ankamagames.dofus.types.entities.AnimStatiqueSubEntityBehavior;
   import com.ankamagames.dofus.types.entities.BreedSkinModifier;
   import com.ankamagames.dofus.types.entities.CustomBreedAnimationModifier;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Worker;
   import com.ankamagames.jerakine.resources.adapters.impl.SignedFileAdapter;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.Version;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.utils.crypto.SignatureKey;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.performance.Benchmark;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.desktop.NativeApplication;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.display.Screen;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.InvokeEvent;
   import flash.events.NativeWindowBoundsEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.external.ExternalInterface;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class Dofus extends Sprite implements IApplicationContainer
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Dofus));
      
      private static var _self:Dofus;
      
      public static var USE_MINI_LOADER:Boolean = false;
       
      
      private var _uiContainer:Sprite;
      
      private var _worldContainer:Sprite;
      
      private var _buildType:String;
      
      private var _instanceId:uint;
      
      private var _doOptions:DofusOptions;
      
      private var _blockLoading:Boolean;
      
      private var _initialized:Boolean = false;
      
      private var _windowInitialized:Boolean = false;
      
      private var _forcedLang:String;
      
      private var _stageWidth:int;
      
      private var _stageHeight:int;
      
      private var _displayState:String;
      
      private var _returnCode:int;
      
      public var REG_LOCAL_CONNECTION_ID:uint = 0;
      
      public var strProgress:Number = 0;
      
      public var strComplete:Boolean = false;
      
      public function Dofus()
      {
         var versionNumber:Array = null;
         var file:File = null;
         super();
         var i:uint = 0;
         while(i < numChildren)
         {
            getChildAt(i).visible = false;
            i++;
         }
         MapViewer.FLAG_CURSOR = EmbedAssets.getClass("FLAG_CURSOR");
         var stage:Stage = this.stage;
         if(!stage)
         {
            stage = loaderInfo.loader.stage;
            AirScanner.init(getQualifiedClassName(loaderInfo.loader.parent) == "DofusLoader");
         }
         else
         {
            AirScanner.init(false);
         }
         _self = this;
         var hasAir:Boolean = AirScanner.hasAir();
         if(!hasAir)
         {
            stage.showDefaultContextMenu = false;
            Security.allowDomain("*");
            new DofusErrorHandler();
         }
         if(hasAir)
         {
            this._blockLoading = name != "root1";
         }
         ErrorManager.registerLoaderInfo(loaderInfo);
         mouseEnabled = false;
         tabChildren = false;
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
         if(hasAir)
         {
            try
            {
               new AppIdModifier();
            }
            catch(e:Error)
            {
               _log.error("Erreur sur la gestion du multicompte :\n" + e.getStackTrace());
            }
            NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.onExiting);
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,this.onCall);
            stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE,this.onResize);
            versionNumber = NativeApplication.nativeApplication.runtimeVersion.split(".");
            file = new File(File.applicationDirectory.nativePath + File.separator + "steam_appid.txt");
            if(SteamManager.hasSteamApi() && file.exists)
            {
               _log.debug("Initializing SteamManager");
               SteamManager.getInstance().init();
               if(SteamManager.getInstance().isSteamEmbed())
               {
                  SteamManager.getInstance().addOverlayWorkaround(this.stage);
               }
            }
         }
      }
      
      public static function getInstance() : Dofus
      {
         return _self;
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function getRawSignatureData() : ByteArray
      {
         var _loc1_:FileStream = new FileStream();
         var _loc2_:File = File.applicationDirectory.resolvePath("DofusInvoker.d2sf");
         _loc1_.open(_loc2_,FileMode.READ);
         var _loc3_:ByteArray = new ByteArray();
         _loc1_.readBytes(_loc3_);
         _loc1_.close();
         return _loc3_;
      }
      
      private function onCall(param1:InvokeEvent) : void
      {
         var file:File = null;
         var stream:FileStream = null;
         var content:String = null;
         var xml:XMLDocument = null;
         var gameNode:XMLNode = null;
         var upperVersion:String = null;
         var configNode:XMLNode = null;
         var versionSplitted:Array = null;
         var version:String = null;
         var part:ContentPart = null;
         var e:InvokeEvent = param1;
         if(!this._initialized)
         {
            CommandLineArguments.getInstance().setArguments(e.arguments);
            new DofusErrorHandler();
            try
            {
               file = new File(File.applicationDirectory.nativePath + File.separator + "uplauncherComponents.xml");
               if(file.exists)
               {
                  PartManager.getInstance().createEmptyPartList();
                  stream = new FileStream();
                  stream.open(file,FileMode.READ);
                  content = stream.readMultiByte(file.size,"utf-8");
                  xml = new XMLDocument();
                  xml.ignoreWhite = true;
                  xml.parseXML(content);
                  gameNode = xml.firstChild;
                  upperVersion = null;
                  for each(configNode in gameNode.childNodes)
                  {
                     version = configNode.attributes["version"];
                     part = new ContentPart();
                     part.id = configNode.attributes["name"];
                     part.state = !!version?uint(PartStateEnum.PART_UP_TO_DATE):uint(PartStateEnum.PART_NOT_INSTALLED);
                     PartManager.getInstance().updatePart(part);
                     if(version && upperVersion == null || version > upperVersion)
                     {
                        upperVersion = version;
                     }
                  }
                  versionSplitted = upperVersion.split(".");
                  if(versionSplitted.length >= 5)
                  {
                     BuildInfos.BUILD_VERSION = new Version(versionSplitted[0],versionSplitted[1],versionSplitted[2]);
                     BuildInfos.BUILD_VERSION.revision = versionSplitted[3];
                     BuildInfos.BUILD_REVISION = versionSplitted[3];
                     BuildInfos.BUILD_VERSION.patch = versionSplitted[4];
                     BuildInfos.BUILD_PATCH = versionSplitted[4];
                  }
               }
               else
               {
                  file = new File(File.applicationDirectory.nativePath + File.separator + "games_base.xml");
                  if(file.exists)
                  {
                     stream = new FileStream();
                     stream.open(file,FileMode.READ);
                     content = stream.readMultiByte(file.size,"utf-8");
                     xml = new XMLDocument();
                     xml.ignoreWhite = true;
                     xml.parseXML(content);
                     gameNode = xml.firstChild.firstChild;
                     for each(configNode in gameNode.childNodes)
                     {
                        if(configNode.nodeName == "version")
                        {
                           version = configNode.firstChild.nodeValue;
                           version = version.split("_")[0];
                           versionSplitted = version.split(".");
                           if(versionSplitted.length >= 5)
                           {
                              BuildInfos.BUILD_VERSION = new Version(versionSplitted[0],versionSplitted[1],versionSplitted[2]);
                              BuildInfos.BUILD_VERSION.revision = versionSplitted[3];
                              BuildInfos.BUILD_REVISION = versionSplitted[3];
                              BuildInfos.BUILD_VERSION.patch = versionSplitted[4];
                              BuildInfos.BUILD_PATCH = versionSplitted[4];
                           }
                        }
                     }
                  }
                  else
                  {
                     BuildInfos.BUILD_VERSION.revision = BuildInfos.BUILD_REVISION;
                     BuildInfos.BUILD_VERSION.patch = BuildInfos.BUILD_PATCH;
                  }
               }
            }
            catch(e:Error)
            {
               BuildInfos.BUILD_VERSION.revision = BuildInfos.BUILD_REVISION;
               BuildInfos.BUILD_VERSION.patch = BuildInfos.BUILD_PATCH;
            }
            if(BuildInfos.BUILD_TYPE < BuildTypeEnum.INTERNAL)
            {
               Uri.enableSecureURI();
            }
            if(this.stage)
            {
               this.init(this.stage);
            }
            try
            {
               file = new File(CustomSharedObject.getCustomSharedObjectDirectory() + File.separator + "path.d2p");
               if(!file.exists)
               {
                  stream = new FileStream();
                  stream.open(file,FileMode.WRITE);
                  stream.writeUTF(File.applicationDirectory.nativePath);
                  stream.close();
               }
            }
            catch(e:Error)
            {
            }
            this._initialized = true;
         }
      }
      
      private function onResize(param1:NativeWindowBoundsEvent) : void
      {
         if(stage.nativeWindow.displayState != NativeWindowDisplayState.MINIMIZED)
         {
            this._displayState = stage.nativeWindow.displayState;
         }
         if(this._displayState == NativeWindowDisplayState.NORMAL && !StageShareManager.isGoingFullScreen)
         {
            this._stageWidth = stage.nativeWindow.width;
            this._stageHeight = stage.nativeWindow.height;
         }
      }
      
      private function onFullScreen(param1:FullScreenEvent) : void
      {
         var _loc2_:Boolean = false;
         if(AirScanner.isStreamingVersion())
         {
            _loc2_ = OptionManager.getOptionManager("dofus").fullScreen;
            if(_loc2_ != param1.fullScreen)
            {
               OptionManager.getOptionManager("dofus").fullScreen = param1.fullScreen;
            }
            StageShareManager.justExitFullScreen = !param1.fullScreen;
         }
         else if(AirScanner.hasAir())
         {
            stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
            setTimeout(stage.nativeWindow.activate,100);
         }
      }
      
      private function initWindow(param1:Boolean) : void
      {
         if(this._windowInitialized)
         {
            return;
         }
         this._windowInitialized = true;
         var _loc2_:Number = stage.stageWidth / stage.stageHeight;
         var _loc3_:NativeWindow = stage.nativeWindow;
         var _loc4_:Number = _loc3_.width - stage.stageWidth;
         var _loc5_:Number = _loc3_.height - stage.stageHeight;
         var _loc6_:String = SystemManager.getSingleton().os;
         if(_loc6_ == OperatingSystem.MAC_OS)
         {
            _loc5_ = 25;
         }
         StageShareManager.chrome.x = _loc4_;
         StageShareManager.chrome.y = _loc5_;
         var _loc7_:CustomSharedObject = CustomSharedObject.getLocal("clientData");
         var _loc8_:Boolean = false;
         if(_loc7_.data != null && (_loc7_.data.width > 0 && _loc7_.data.height > 0))
         {
            if(_loc7_.data.width > 0 && _loc7_.data.height > 0)
            {
               _loc3_.width = _loc7_.data.width;
               if(_loc6_ == OperatingSystem.LINUX)
               {
                  _loc3_.height = _loc7_.data.height - 28;
               }
               else
               {
                  _loc3_.height = _loc7_.data.height;
               }
               this._stageWidth = _loc3_.width;
               this._stageHeight = _loc3_.height;
               _loc8_ = true;
            }
            if(!param1 && _loc7_.data.displayState == NativeWindowDisplayState.MAXIMIZED)
            {
               this._displayState = NativeWindowDisplayState.MAXIMIZED;
            }
         }
         else
         {
            _loc3_.width = Screen.mainScreen.visibleBounds.width * 0.8;
            _loc3_.height = Screen.mainScreen.visibleBounds.height * 0.8;
            this._displayState = NativeWindowDisplayState.MAXIMIZED;
         }
         this._stageWidth = _loc3_.width;
         this._stageHeight = _loc3_.height;
         _loc3_.x = (Screen.mainScreen.visibleBounds.width - _loc3_.width) / 2 + Screen.mainScreen.visibleBounds.x;
         _loc3_.y = Math.max(0,(Screen.mainScreen.visibleBounds.height - _loc3_.height) / 2 + Screen.mainScreen.visibleBounds.y);
         if(!param1)
         {
            if(this._displayState != NativeWindowDisplayState.MAXIMIZED)
            {
               _loc3_.activate();
               this.updateLoadingScreenLayout();
            }
            else if(this._displayState == NativeWindowDisplayState.MAXIMIZED)
            {
               _loc3_.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.onDisplayStateChanged);
               _loc3_.maximize();
            }
         }
      }
      
      protected function onDisplayStateChanged(param1:NativeWindowDisplayStateEvent) : void
      {
         stage.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.onDisplayStateChanged);
         stage.nativeWindow.activate();
         this.updateLoadingScreenLayout();
      }
      
      private function updateLoadingScreenLayout() : void
      {
         var _loc1_:InitializationFrame = Kernel.getWorker().getFrame(InitializationFrame) as InitializationFrame;
         if(_loc1_)
         {
            _loc1_.updateLoadingScreenSize();
         }
      }
      
      public function getUiContainer() : DisplayObjectContainer
      {
         return this._uiContainer;
      }
      
      public function getWorldContainer() : DisplayObjectContainer
      {
         return this._worldContainer;
      }
      
      public function get options() : DofusOptions
      {
         return this._doOptions;
      }
      
      public function get instanceId() : uint
      {
         return this._instanceId;
      }
      
      public function get forcedLang() : String
      {
         return this._forcedLang;
      }
      
      public function setDisplayOptions(param1:DofusOptions) : void
      {
         if(AirScanner.hasAir())
         {
            this.initWindow(param1.fullScreen);
         }
         this._doOptions = param1;
         this._doOptions.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onOptionChange);
         this._doOptions.flashQuality = this._doOptions.flashQuality;
         this._doOptions.fullScreen = this._doOptions.fullScreen;
      }
      
      public function init(param1:DisplayObject, param2:uint = 0, param3:String = null, param4:Array = null) : void
      {
         if(param4)
         {
            CommandLineArguments.getInstance().setArguments(param4);
         }
         this._instanceId = param2;
         this._forcedLang = param3;
         var _loc5_:Sprite = new Sprite();
         _loc5_.name = "catchMouseEventCtr";
         _loc5_.graphics.beginFill(0);
         _loc5_.graphics.drawRect(0,0,StageShareManager.startWidth,StageShareManager.startHeight);
         _loc5_.graphics.endFill();
         addChild(_loc5_);
         var _loc6_:CustomSharedObject = CustomSharedObject.getLocal("appVersion");
         if(!_loc6_.data.lastBuildVersion || _loc6_.data.lastBuildVersion != BuildInfos.BUILD_REVISION && BuildInfos.BUILD_TYPE < BuildTypeEnum.INTERNAL)
         {
            this.clearCache(true);
         }
         _loc6_ = CustomSharedObject.getLocal("appVersion");
         _loc6_.data.lastBuildVersion = BuildInfos.BUILD_REVISION;
         _loc6_.flush();
         _loc6_.close();
         UiPerformanceManager.getInstance().currentVersion = BuildInfos.BUILD_VERSION;
         SignedFileAdapter.defaultSignatureKey = SignatureKey.fromByte(new Constants.SIGNATURE_KEY_DATA() as ByteArray);
         this.initKernel(this.stage,param1);
         this.initWorld();
         this.initUi();
         if(AirScanner.hasAir())
         {
            stage["nativeWindow"].addEventListener(Event.CLOSE,this.onClosed);
         }
         TiphonEventsManager.addListener(Tiphon.getInstance(),TiphonEvent.EVT_EVENT);
         SoundManager.getInstance().manager = new RegSoundManager();
         (SoundManager.getInstance().manager as RegSoundManager).forceSoundsDebugMode = true;
         Atouin.getInstance().addListener(SoundManager.getInstance().manager);
      }
      
      private function onExiting(param1:Event) : void
      {
         this.saveClientSize();
         if(WebServiceDataHandler.getInstance().quit())
         {
            param1.preventDefault();
            param1.stopPropagation();
            WebServiceDataHandler.getInstance().addEventListener(WebServiceDataHandler.ALL_DATA_SENT,this.quitHandler);
         }
         else if(UiPerformanceManager.getInstance().needUiLoadStatsSubmission)
         {
            param1.preventDefault();
            param1.stopPropagation();
            this.sendUiLoadStats();
         }
      }
      
      public function quit(param1:int = 0) : void
      {
         this._returnCode = param1;
         if(!WebServiceDataHandler.getInstance().quit())
         {
            this.quitHandler();
         }
         else
         {
            _log.trace("We have data to send to the webservice. waiting...");
            WebServiceDataHandler.getInstance().addEventListener(WebServiceDataHandler.ALL_DATA_SENT,this.quitHandler);
            WebServiceDataHandler.getInstance().sendWaitingException();
         }
      }
      
      private function quitHandler(param1:Event = null) : void
      {
         if(param1 != null)
         {
            param1.currentTarget.removeEventListener(WebServiceDataHandler.ALL_DATA_SENT,this.quitHandler);
            _log.trace("Data sent. Good to go. Bye bye");
         }
         if(Constants.EVENT_MODE)
         {
            this.reboot();
         }
         else if(AirScanner.hasAir())
         {
            stage.nativeWindow.close();
            if(NativeApplication.nativeApplication.openedWindows.length == 0)
            {
               NativeApplication.nativeApplication.exit(this._returnCode);
            }
         }
      }
      
      private function sendUiLoadStats() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc1_:Object = UiPerformanceManager.getInstance().averageUiLoadStats;
         var _loc2_:String = Benchmark.getResults();
         var _loc3_:Array = _loc2_.split(";");
         for each(_loc4_ in _loc3_)
         {
            _loc6_ = _loc4_.split(":");
            if(_loc6_.length == 2)
            {
               if(!(_loc6_[1] == "none" || _loc6_[0] != "readDiskTest" && _loc6_[0] != "displayPerfTest"))
               {
                  if(_loc6_[1] == "error")
                  {
                     _loc6_[1] = "-1";
                  }
                  _loc1_["client_benchmark_" + _loc6_[0]] = parseInt(_loc6_[1]);
               }
            }
         }
         _loc1_["client_buildType"] = BuildInfos.BUILD_TYPE;
         _loc1_["client_version"] = BuildInfos.BUILD_VERSION.major + "." + BuildInfos.BUILD_VERSION.minor;
         _loc5_ = by.blooddy.crypto.serialization.JSON.encode(_loc1_);
         HaapiDebugManager.getInstance().submitData(HaapiDebugManager.UI_DATA_TYPE,_loc5_,this.onUiLoadStatsSentComplete,this.onUiLoadStatsSentError);
      }
      
      private function onUiLoadStatsSentComplete() : void
      {
         UiPerformanceManager.getInstance().markCurrentVersionAsUploaded();
         this.quitHandler();
      }
      
      private function onUiLoadStatsSentError() : void
      {
         this.quitHandler();
      }
      
      public function clearCache(param1:Boolean = false, param2:Boolean = false) : void
      {
         var soList:Array = null;
         var file:File = null;
         var fileName:String = null;
         var selective:Boolean = param1;
         var reboot:Boolean = param2;
         var soFolder:File = new File(CustomSharedObject.getCustomSharedObjectDirectory());
         if(soFolder && soFolder.exists)
         {
            CustomSharedObject.closeAll();
            CustomSharedObject.resetCache();
            soList = soFolder.getDirectoryListing();
            for each(file in soList)
            {
               fileName = FileUtils.getFileStartName(file.name);
               if(fileName != "Dofus_Guest")
               {
                  if(fileName != "Berilia_binds")
                  {
                     if(fileName != "Dofus_Surveys")
                     {
                        if(fileName.indexOf("playerData_") != 0)
                        {
                           if(file.name != "ui")
                           {
                              if(selective)
                              {
                                 switch(true)
                                 {
                                    case fileName.indexOf("Module_") != -1:
                                    case fileName == "dofus":
                                    case fileName.indexOf("Dofus_") == 0:
                                    case fileName == "atouin":
                                    case fileName == "berilia":
                                    case fileName == "chat":
                                    case fileName == "tiphon":
                                    case fileName == "tubul":
                                    case fileName.indexOf("externalNotifications_") == 0:
                                    case fileName == "averagePrices":
                                    case fileName == "Berilia_binds":
                                    case fileName == "Berilia_ui_stats":
                                    case fileName == "Berilia_ui_positions":
                                    case fileName == "Jerakine_classAlias":
                                    case fileName == "maps":
                                    case fileName == "logs":
                                    case fileName == "uid":
                                    case fileName == "appVersion":
                                    case fileName == "clientData":
                                       continue;
                                 }
                              }
                              try
                              {
                                 if(file.isDirectory)
                                 {
                                    file.deleteDirectory(true);
                                 }
                                 else
                                 {
                                    file.deleteFile();
                                 }
                              }
                              catch(e:Error)
                              {
                                 continue;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         if(reboot)
         {
            if(AirScanner.hasAir())
            {
               AppIdModifier.getInstance().invalideCache();
               CustomSharedObject.clearedCacheAndRebooting = true;
               this.reboot();
            }
            else if(ExternalInterface.available)
            {
               ExternalInterface.call("eval","window.location.reload()");
            }
         }
      }
      
      public function reboot() : void
      {
         this.saveClientSize();
         var _loc1_:Worker = Kernel.getWorker();
         if(_loc1_)
         {
            _loc1_.clear();
         }
         _log.fatal("REBOOT");
         if(AirScanner.hasAir())
         {
            NativeApplication.nativeApplication["exit"](42);
            return;
         }
         throw new Error("Reboot not implemented with flash");
      }
      
      public function renameApp(param1:String) : void
      {
         if(AirScanner.hasAir())
         {
            stage["nativeWindow"].title = param1;
         }
      }
      
      private function initKernel(param1:Stage, param2:DisplayObject) : void
      {
         Kernel.getInstance().init(param1,param2);
         LangManager.getInstance().handler = Kernel.getWorker();
         FontManager.getInstance().handler = Kernel.getWorker();
         Berilia.getInstance().handler = Kernel.getWorker();
         LangManager.getInstance().lang = "frFr";
      }
      
      private function initWorld() : void
      {
         if(this._worldContainer)
         {
            removeChild(this._worldContainer);
         }
         this._worldContainer = new Sprite();
         addChildAt(this._worldContainer,numChildren - 1);
         this._worldContainer.mouseEnabled = false;
      }
      
      private function initUi() : void
      {
         if(this._uiContainer)
         {
            removeChild(this._uiContainer);
         }
         this._uiContainer = new Sprite();
         this._uiContainer.name = "uiContainer";
         this._uiContainer.mouseEnabled = false;
         addChildAt(this._uiContainer,numChildren - 1);
         var _loc1_:* = BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG;
         Berilia.getInstance().verboseException = _loc1_;
         CursorConstant.init();
         UiModuleManager.getInstance().trustedModuleScripts = Constants.scripts;
         Berilia.getInstance().init(this._uiContainer,_loc1_,BuildInfos.BUILD_REVISION,!_loc1_);
         if(AirScanner.isStreamingVersion())
         {
            Berilia.embedIcons.SLOT_DEFAULT_ICON = EmbedAssets.getBitmap("DefaultBeriliaSlotIcon",true).bitmapData;
         }
         EntityDisplayer.setAnimationModifier(1,new CustomBreedAnimationModifier());
         EntityDisplayer.setAnimationModifier(2,new CustomBreedAnimationModifier());
         EntityDisplayer.setSkinModifier(1,new BreedSkinModifier());
         EntityDisplayer.setSkinModifier(2,new BreedSkinModifier());
         EntityDisplayer.setSubEntityDefaultBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET,new AnimStatiqueSubEntityBehavior());
         EntityDisplayer.setSubEntityDefaultBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         CharacterWheel.setAnimationModifier(1,new CustomBreedAnimationModifier());
         CharacterWheel.setAnimationModifier(2,new CustomBreedAnimationModifier());
         CharacterWheel.setSkinModifier(1,new BreedSkinModifier());
         CharacterWheel.setSkinModifier(2,new BreedSkinModifier());
         CharacterWheel.setSubEntityDefaultBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET,new AnimStatiqueSubEntityBehavior());
         CharacterWheel.setSubEntityDefaultBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         EntityDisplayer.lookAdaptater = EntityLookAdapter.tiphonizeLook;
      }
      
      private function onClosed(param1:Event) : void
      {
         Console.getInstance().close();
         ConsoleLUA.getInstance().close();
         HttpServer.getInstance().close();
         InterClientManager.destroy();
      }
      
      private function onOptionChange(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "flashQuality")
         {
            if(param1.propertyValue == 0)
            {
               StageShareManager.stage.quality = StageQuality.LOW;
            }
            else if(param1.propertyValue == 1)
            {
               StageShareManager.stage.quality = StageQuality.MEDIUM;
            }
            else if(param1.propertyValue == 2)
            {
               StageShareManager.stage.quality = StageQuality.HIGH;
            }
         }
         if(param1.propertyName == "fullScreen")
         {
            StageShareManager.setFullScreen(param1.propertyValue,false);
         }
      }
      
      private function saveClientSize() : void
      {
         var _loc1_:CustomSharedObject = CustomSharedObject.getLocal("clientData");
         _loc1_.data.height = this._stageHeight;
         _loc1_.data.width = this._stageWidth;
         _loc1_.data.displayState = this._displayState;
         _loc1_.flush();
         _loc1_.close();
      }
      
      public function strLoaderComplete() : void
      {
         this.strComplete = true;
      }
      
      public function getLoadingProgress() : Number
      {
         return this.strProgress;
      }
   }
}
