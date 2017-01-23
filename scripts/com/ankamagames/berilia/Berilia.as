package com.ankamagames.berilia
{
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.managers.AutoReloadUiManager;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.UIEventManager;
   import com.ankamagames.berilia.managers.UiGroupManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.BeriliaOptions;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.UiRenderAskEvent;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.berilia.types.graphic.ChatTextContainer;
   import com.ankamagames.berilia.types.graphic.ExternalUi;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.TimeoutHTMLLoader;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.utils.EmbedIcons;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.cache.Cache;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.interfaces.IInterfaceListener;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.types.DynamicSecureObject;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class Berilia extends EventDispatcher
   {
      
      private static var _self:Berilia;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Berilia));
      
      public static var _uiCache:Dictionary = new Dictionary();
      
      public static var embedIcons:Class = EmbedIcons;
       
      
      private const _cache:Cache = new Cache(Cache.CHECK_SYSTEM_MEMORY,500000000,300000000);
      
      private var _UISoundListeners:Array;
      
      private var _bOptions:BeriliaOptions;
      
      private var _applicationVersion:uint;
      
      private var _checkModuleAuthority:Boolean = true;
      
      private var _uiSavedModificationPresetName:String = "default";
      
      private var _docMain:Sprite;
      
      private var _aUiList:Dictionary;
      
      private var _highestModalDepth:int;
      
      private var _aContainerList:Array;
      
      private var _autoReloadUiOnChange:Boolean;
      
      private var _docStrataWorld:Sprite;
      
      private var _docStrataLow:Sprite;
      
      private var _docStrataMedium:Sprite;
      
      private var _docStrataHigh:Sprite;
      
      private var _docStrataTop:Sprite;
      
      private var _docStrataTooltip:Sprite;
      
      private var _docStrataSuperTooltip:Sprite;
      
      private var _handler:MessageHandler;
      
      private var _aLoadingUi:Array;
      
      private var _globalScale:Number = 1;
      
      private var _verboseException:Boolean = false;
      
      public var useIME:Boolean;
      
      private var _autoReloadUiManagers:Dictionary;
      
      public function Berilia()
      {
         this._UISoundListeners = new Array();
         this._autoReloadUiManagers = new Dictionary();
         super();
         if(_self != null)
         {
            throw new SingletonError("Berilia is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : Berilia
      {
         if(_self == null)
         {
            _self = new Berilia();
         }
         return _self;
      }
      
      public function get uiSavedModificationPresetName() : String
      {
         return !!this._uiSavedModificationPresetName?this._uiSavedModificationPresetName:"default";
      }
      
      public function set uiSavedModificationPresetName(param1:String) : void
      {
         if(this._uiSavedModificationPresetName != param1)
         {
            this.resetUiSavedUserModification(null,false,!!param1?param1:"default");
         }
      }
      
      public function get autoReloadUiOnChange() : Boolean
      {
         return this._autoReloadUiOnChange;
      }
      
      public function set autoReloadUiOnChange(param1:Boolean) : void
      {
         var _loc3_:UiRootContainer = null;
         var _loc4_:AutoReloadUiManager = null;
         var _loc2_:* = param1 != this._autoReloadUiOnChange;
         this._autoReloadUiOnChange = param1;
         if(_loc2_)
         {
            if(this._autoReloadUiOnChange)
            {
               for each(_loc3_ in this._aUiList)
               {
                  if(!this._autoReloadUiManagers[_loc3_.uiData])
                  {
                     this._autoReloadUiManagers[_loc3_.uiData] = new AutoReloadUiManager(_loc3_.uiData);
                  }
               }
            }
            else
            {
               for each(_loc4_ in this._autoReloadUiManagers)
               {
                  AutoReloadUiManager(_loc4_).destroy();
               }
               this._autoReloadUiManagers = new Dictionary();
            }
         }
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(param1:MessageHandler) : void
      {
         this._handler = param1;
      }
      
      public function get docMain() : Sprite
      {
         return this._docMain;
      }
      
      public function get uiList() : Dictionary
      {
         return this._aUiList;
      }
      
      public function get highestModalDepth() : int
      {
         return this._highestModalDepth;
      }
      
      public function get containerList() : Array
      {
         return this._aContainerList;
      }
      
      public function get strataLow() : DisplayObjectContainer
      {
         return this._docStrataLow;
      }
      
      public function get strataMedium() : DisplayObjectContainer
      {
         return this._docStrataMedium;
      }
      
      public function get strataHigh() : DisplayObjectContainer
      {
         return this._docStrataHigh;
      }
      
      public function get strataTop() : DisplayObjectContainer
      {
         return this._docStrataTop;
      }
      
      public function get strataTooltip() : DisplayObjectContainer
      {
         return this._docStrataTooltip;
      }
      
      public function get strataSuperTooltip() : DisplayObjectContainer
      {
         return this._docStrataSuperTooltip;
      }
      
      public function get loadingUi() : Array
      {
         return this._aLoadingUi;
      }
      
      public function get scale() : Number
      {
         return this._globalScale;
      }
      
      public function set scale(param1:Number) : void
      {
         this._globalScale = param1;
         this.updateUiScale();
      }
      
      public function get cache() : Cache
      {
         return this._cache;
      }
      
      public function get verboseException() : Boolean
      {
         return this._verboseException;
      }
      
      public function set verboseException(param1:Boolean) : void
      {
         this._verboseException = param1;
      }
      
      public function get UISoundListeners() : Array
      {
         return this._UISoundListeners;
      }
      
      public function get options() : BeriliaOptions
      {
         return this._bOptions;
      }
      
      public function get applicationVersion() : uint
      {
         return this._applicationVersion;
      }
      
      public function get checkModuleAuthority() : Boolean
      {
         return this._checkModuleAuthority;
      }
      
      public function setDisplayOptions(param1:BeriliaOptions) : void
      {
         this._bOptions = param1;
      }
      
      public function addUIListener(param1:IInterfaceListener) : void
      {
         FpsManager.getInstance().startTracking("ui",16525567);
         var _loc2_:int = this._UISoundListeners.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._UISoundListeners.push(param1);
         }
         FpsManager.getInstance().stopTracking("ui");
      }
      
      public function removeUIListener(param1:IInterfaceListener) : void
      {
         FpsManager.getInstance().startTracking("ui",16525567);
         var _loc2_:int = this._UISoundListeners.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._UISoundListeners.splice(_loc2_,1);
         }
         FpsManager.getInstance().stopTracking("ui");
      }
      
      public function init(param1:Sprite, param2:Boolean, param3:uint, param4:Boolean = true) : void
      {
         this._docMain = param1;
         this._docMain.mouseEnabled = false;
         this._applicationVersion = param3;
         this._checkModuleAuthority = param4;
         this._docStrataWorld = new Sprite();
         this._docStrataWorld.name = "strataWorld";
         this._docStrataLow = new Sprite();
         this._docStrataLow.name = "strataLow";
         this._docStrataMedium = new Sprite();
         this._docStrataMedium.name = "strataMedium";
         this._docStrataHigh = new Sprite();
         this._docStrataHigh.name = "strataHigh";
         this._docStrataTop = new Sprite();
         this._docStrataTop.name = "strataTop";
         this._docStrataTooltip = new Sprite();
         this._docStrataTooltip.name = "strataTooltip";
         this._docStrataSuperTooltip = new Sprite();
         this._docStrataSuperTooltip.name = "strataSuperTooltip";
         this._docStrataWorld.mouseEnabled = false;
         this._docStrataLow.mouseEnabled = false;
         this._docStrataMedium.mouseEnabled = false;
         this._docStrataHigh.mouseEnabled = false;
         this._docStrataTop.mouseEnabled = false;
         this._docStrataTooltip.mouseChildren = false;
         this._docStrataTooltip.mouseEnabled = false;
         this._docStrataSuperTooltip.mouseChildren = false;
         this._docStrataSuperTooltip.mouseEnabled = false;
         this._docMain.addChild(this._docStrataWorld);
         this._docMain.addChild(this._docStrataLow);
         this._docMain.addChild(this._docStrataMedium);
         this._docMain.addChild(this._docStrataHigh);
         this._docMain.addChild(this._docStrataTop);
         this._docMain.addChild(this._docStrataTooltip);
         this._docMain.addChild(this._docStrataSuperTooltip);
         this._aUiList = new Dictionary();
         this._aContainerList = new Array();
         this._aLoadingUi = new Array();
         BeriliaHookList.MouseClick;
         if(SystemManager.getSingleton().os == OperatingSystem.LINUX)
         {
            Label.HEIGHT_OFFSET = 1;
         }
      }
      
      public function reset() : void
      {
         var _loc1_:* = null;
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc4_:UiModule = null;
         var _loc5_:UiRootContainer = null;
         TimeoutHTMLLoader.resetCache();
         FpsManager.getInstance().startTracking("ui",16525567);
         for(_loc1_ in _uiCache)
         {
            _loc5_ = _uiCache[_loc1_];
            this._aUiList[_loc1_] = _loc5_;
            _loc5_.cached = false;
         }
         _uiCache = new Dictionary();
         _loc2_ = [];
         for(_loc3_ in this._aUiList)
         {
            _loc2_.push(_loc3_);
         }
         for each(_loc3_ in _loc2_)
         {
            this.unloadUi(_loc3_);
         }
         for each(_loc4_ in UiModuleManager.getInstance().getModules())
         {
            KernelEventsManager.getInstance().removeAllEventListeners("__module_" + _loc4_.id);
            BindsManager.getInstance().removeAllEventListeners("__module_" + _loc4_.id);
         }
         UiGroupManager.getInstance().destroy();
         FpsManager.getInstance().stopTracking("ui");
      }
      
      public function loadUi(param1:UiModule, param2:UiData, param3:String, param4:* = null, param5:Boolean = false, param6:int = 1, param7:Boolean = false, param8:String = null, param9:Boolean = false, param10:Boolean = true, param11:Boolean = true) : UiRootContainer
      {
         var container:UiRootContainer = null;
         var highestDepth:int = 0;
         var uiContainer:Sprite = null;
         var i:uint = 0;
         var t:int = 0;
         var eui:ExternalUi = null;
         var uiModule:UiModule = param1;
         var uiData:UiData = param2;
         var sName:String = param3;
         var properties:* = param4;
         var bReplace:Boolean = param5;
         var nStrata:int = param6;
         var hide:Boolean = param7;
         var cacheName:String = param8;
         var externalUi:Boolean = param9;
         var restoreSnapshot:Boolean = param10;
         var useCache:Boolean = param11;
         FpsManager.getInstance().startTracking("ui",16525567);
         if(cacheName)
         {
            container = _uiCache[cacheName];
            if(container)
            {
               container.name = sName;
               container.strata = nStrata;
               container.restoreSnapshotAfterLoading = restoreSnapshot;
               highestDepth = int.MIN_VALUE;
               uiContainer = Sprite(this._docMain.getChildAt(nStrata + 1));
               i = 0;
               while(i < uiContainer.numChildren)
               {
                  if(uiContainer.getChildAt(i) is UiRootContainer && UiRootContainer(uiContainer.getChildAt(i)).depth > highestDepth)
                  {
                     highestDepth = UiRootContainer(uiContainer.getChildAt(i)).depth;
                  }
                  i++;
               }
               if(highestDepth < 0)
               {
                  highestDepth = 0;
               }
               container.depth = nStrata * 10000 + highestDepth + 1;
               container.uiModule = uiModule;
               if(externalUi)
               {
                  new ExternalUi().uiRootContainer = container;
               }
               else
               {
                  DisplayObjectContainer(this._docMain.getChildAt(nStrata + 1)).addChild(container);
               }
               this._aUiList[sName] = container;
               try
               {
                  t = getTimer();
                  FpsManager.getInstance().startTracking("hook",7108545);
                  container.uiClass.main(properties);
                  FpsManager.getInstance().stopTracking("hook");
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiLoaded,sName);
               }
               catch(e:Error)
               {
                  ErrorManager.addError("Impossible d\'utiliser le cache d\'interface pour " + container.name + " du module " + (!!container.uiModule?container.uiModule.id:"???"),e);
                  delete _uiCache[cacheName];
                  container.cached = false;
                  unloadUi(sName);
               }
               return null;
            }
         }
         container = new UiRootContainer(this._docMain.stage,uiData,Sprite(this._docMain.getChildAt(nStrata + 1)));
         container.name = sName;
         container.strata = nStrata;
         container.restoreSnapshotAfterLoading = restoreSnapshot;
         highestDepth = int.MIN_VALUE;
         uiContainer = Sprite(this._docMain.getChildAt(nStrata + 1));
         i = 0;
         while(i < uiContainer.numChildren)
         {
            if(uiContainer.getChildAt(i) is UiRootContainer && UiRootContainer(uiContainer.getChildAt(i)).depth > highestDepth)
            {
               highestDepth = UiRootContainer(uiContainer.getChildAt(i)).depth;
            }
            i++;
         }
         if(highestDepth < 0)
         {
            highestDepth = 0;
         }
         container.depth = nStrata * 10000 + highestDepth % 10000 + 1;
         container.uiModule = uiModule;
         if(cacheName)
         {
            container.cached = true;
            _uiCache[cacheName] = container;
         }
         if(!container.parent && !hide)
         {
            if(externalUi)
            {
               eui = new ExternalUi();
               eui.uiRootContainer = container;
            }
            else
            {
               DisplayObjectContainer(this._docMain.getChildAt(nStrata + 1)).addChild(container);
            }
         }
         this.loadUiInside(uiData,sName,container,properties,bReplace,useCache);
         FpsManager.getInstance().stopTracking("ui");
         return container;
      }
      
      public function giveFocus(param1:UiRootContainer) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         if(param1.strata == 1)
         {
            _loc2_ = true;
            for each(_loc3_ in this._aUiList)
            {
               if(_loc3_.visible && _loc3_.depth > param1.depth && _loc3_.strata == 1)
               {
                  _loc2_ = false;
               }
            }
            if(param1.visible && _loc2_)
            {
               StageShareManager.stage.focus = param1;
            }
         }
      }
      
      public function loadUiInside(param1:UiData, param2:String, param3:UiRootContainer, param4:* = null, param5:Boolean = false, param6:Boolean = true) : UiRootContainer
      {
         if(param5)
         {
            this.unloadUi(param2);
         }
         if(this.isRegisteredUiName(param2))
         {
            throw new BeriliaError(param2 + " is already used by an other UI");
         }
         if(this._autoReloadUiOnChange && !this._autoReloadUiManagers[param1])
         {
            this._autoReloadUiManagers[param1] = new AutoReloadUiManager(param1);
         }
         dispatchEvent(new UiRenderAskEvent(param2,param1));
         param3.name = param2;
         this._aLoadingUi[param2] = true;
         this._aUiList[param2] = param3;
         param3.addEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
         UiRenderManager.getInstance().loadUi(param1,param3,param4,param6);
         return param3;
      }
      
      public function unloadUi(param1:String, param2:Boolean = false) : Boolean
      {
         var ui:UiRootContainer = null;
         var j:Object = null;
         var linkCursor:LinkedCursorData = null;
         var currObj:Object = null;
         var i:Object = null;
         var topUi:Object = null;
         var variables:Array = null;
         var varName:String = null;
         var holder:Object = null;
         var rootContainer:UiRootContainer = null;
         var u:Object = null;
         var sName:String = param1;
         var forceUnload:Boolean = param2;
         var startTimer:int = getTimer();
         FpsManager.getInstance().startTracking("ui",16525567);
         dispatchEvent(new UiUnloadEvent(UiUnloadEvent.UNLOAD_UI_STARTED,sName));
         ui = this._aUiList[sName];
         if(ui == null)
         {
            return false;
         }
         if(this._autoReloadUiManagers[ui.uiData])
         {
            AutoReloadUiManager(this._autoReloadUiManagers[ui.uiData]).destroy();
            delete this._autoReloadUiManagers[ui.uiData];
         }
         var obj:DynamicSecureObject = new DynamicSecureObject();
         obj.cancel = false;
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiUnloading,sName,obj);
         if(!forceUnload && obj.cancel)
         {
            return false;
         }
         if(ui.ready)
         {
            ui.makeSnapshot();
         }
         if(ui.cached)
         {
            if(ui.parent)
            {
               ui.parent.removeChild(ui);
            }
            this.unloadUiEvents(sName,true);
            ui.hideAfterLoading = true;
            delete this._aUiList[sName];
            if(ui.uiClass && ui.uiClass.hasOwnProperty("unload") && ui.uiClass.unload)
            {
               try
               {
                  ui.uiClass.unload();
               }
               catch(e:Error)
               {
                  ErrorManager.addError("Une erreur est survenu dans la fonction unload() de l\'interface " + ui.name + " du module " + (!!ui.uiModule?ui.uiModule.id:"???"));
               }
            }
            if(ui.transmitFocus && (!StageShareManager.stage.focus || !(StageShareManager.stage.focus is TextField || StageShareManager.stage.focus is ChatTextContainer)))
            {
               StageShareManager.stage.focus = topUi == null?StageShareManager.stage:InteractiveObject(topUi);
            }
            KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiUnloaded,sName);
            return true;
         }
         ui.disableRender = true;
         delete this._aLoadingUi[sName];
         var doIt:DisplayObject = StageShareManager.stage.focus;
         while(doIt)
         {
            if(doIt is UiRootContainer && doIt == ui)
            {
               StageShareManager.stage.focus = null;
               break;
            }
            doIt = doIt.parent;
         }
         if(UiRootContainer(ui).uiClass)
         {
            if(Object(UiRootContainer(ui).uiClass).hasOwnProperty("unload"))
            {
               UiRootContainer(ui).uiClass.unload();
            }
            variables = DescribeTypeCache.getVariables(UiRootContainer(ui).uiClass,true,false);
            for each(varName in variables)
            {
               if(UiRootContainer(ui).uiClass[varName] is Object)
               {
                  if(getQualifiedClassName(UiRootContainer(ui).uiClass[varName]).indexOf("Api") && UiRootContainer(ui).uiClass[varName] is Object && Object(UiRootContainer(ui).uiClass[varName]).hasOwnProperty("destroy"))
                  {
                     if(UiRootContainer(ui).uiModule.trusted)
                     {
                        UiRootContainer(ui).uiClass[varName].destroy();
                     }
                     else
                     {
                        UiRootContainer(ui).uiClass[varName].destroy(SecureCenter.ACCESS_KEY);
                     }
                  }
                  UiRootContainer(ui).uiClass[varName] = null;
               }
            }
            UiRootContainer(ui).uiClass = null;
         }
         for(j in UIEventManager.getInstance().instances)
         {
            if(j != "null" && UIEventManager.getInstance().instances[j].instance.getUi() == ui)
            {
               UIEventManager.getInstance().instances[j] = null;
               delete UIEventManager.getInstance().instances[j];
            }
         }
         linkCursor = LinkedCursorSpriteManager.getInstance().getItem("DragAndDrop");
         if(linkCursor && linkCursor.data.hasOwnProperty("currentHolder"))
         {
            holder = linkCursor.data.currentHolder;
            rootContainer = holder.getUi();
            if(rootContainer == ui)
            {
               LinkedCursorSpriteManager.getInstance().removeItem("DragAndDrop");
               HumanInputHandler.getInstance().resetClick();
            }
         }
         UiRootContainer(ui).remove();
         for(i in ui.getElements())
         {
            currObj = ui.getElements()[i];
            if(currObj is GraphicContainer)
            {
               this._aContainerList[currObj["name"]] = null;
               delete this._aContainerList[currObj["name"]];
            }
            ui.getElements()[i] = null;
            delete ui.getElements()[i];
         }
         KernelEventsManager.getInstance().removeAllEventListeners(sName);
         BindsManager.getInstance().removeAllEventListeners(sName);
         UiRenderManager.getInstance().cancelRender(ui.uiData);
         SecureCenter.destroy(ui);
         ui.destroyUi(SecureCenter.ACCESS_KEY);
         if(ApiBinder.getApiData("currentUi") == ui)
         {
            ApiBinder.removeApiData("currentUi");
         }
         UiRootContainer(ui).free();
         delete this._aUiList[sName];
         this.updateHighestModalDepth();
         topUi = null;
         if(ui.strata > 0 && ui.strata < 4)
         {
            for each(u in this._aUiList)
            {
               if(topUi == null)
               {
                  if(u.strata == 1 && u.visible)
                  {
                     topUi = u;
                  }
               }
               else if(u.depth > topUi.depth && u.strata == 1 && u.visible)
               {
                  topUi = u;
               }
            }
            if(!StageShareManager.stage.focus || ui.transmitFocus && !(StageShareManager.stage.focus is TextField || StageShareManager.stage.focus is ChatTextContainer))
            {
               StageShareManager.stage.focus = topUi == null?StageShareManager.stage:InteractiveObject(topUi);
            }
         }
         FpsManager.getInstance().stopTracking("ui");
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiUnloaded,sName);
         dispatchEvent(new UiUnloadEvent(UiUnloadEvent.UNLOAD_UI_COMPLETE,sName));
         var stopTimer:int = getTimer();
         _log.info(sName + " correctly unloaded in " + (stopTimer - startTimer) + "ms");
         return true;
      }
      
      public function unloadUiEvents(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         FpsManager.getInstance().startTracking("ui",16525567);
         if(this._aUiList[param1] == null)
         {
            return;
         }
         for(_loc4_ in this._aUiList[param1].getElements())
         {
            _loc3_ = this._aUiList[param1].getElements()[_loc4_];
            if(_loc3_ is GraphicContainer)
            {
               this._aContainerList[_loc3_["name"]] = null;
               delete this._aContainerList[_loc3_["name"]];
            }
            if(!param2)
            {
               this._aUiList[param1].getElements()[_loc4_] = null;
               delete this._aUiList[param1].getElements()[_loc4_];
            }
         }
         KernelEventsManager.getInstance().removeAllEventListeners(param1);
         BindsManager.getInstance().removeAllEventListeners(param1);
         for(_loc5_ in UIEventManager.getInstance().instances)
         {
            if((_loc5_ != null || _loc5_ != "null") && UIEventManager.getInstance().instances[_loc5_] && UIEventManager.getInstance().instances[_loc5_].instance && UIEventManager.getInstance().instances[_loc5_].instance.topParent && UIEventManager.getInstance().instances[_loc5_].instance.topParent.name == param1)
            {
               if(UIEventManager.getInstance().instances[_loc5_].instance.topParent.name == param1)
               {
                  UIEventManager.getInstance().instances[_loc5_] = null;
                  delete UIEventManager.getInstance().instances[_loc5_];
               }
            }
         }
         FpsManager.getInstance().stopTracking("ui");
      }
      
      public function getUi(param1:String) : UiRootContainer
      {
         return this._aUiList[param1];
      }
      
      public function isUiDisplayed(param1:String) : Boolean
      {
         return this._aUiList[param1] != null;
      }
      
      public function updateUiRender() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.uiList)
         {
            UiRootContainer(this.uiList[_loc1_]).render();
         }
      }
      
      public function updateUiScale() : void
      {
         var _loc1_:UiRootContainer = null;
         var _loc2_:* = null;
         for(_loc2_ in this.uiList)
         {
            _loc1_ = UiRootContainer(this.uiList[_loc2_]);
            if(_loc1_.scalable)
            {
               _loc1_.scale = this.scale;
               _loc1_.render();
            }
         }
      }
      
      public function isRegisteredContainerId(param1:String) : Boolean
      {
         return this._aContainerList[param1] != null;
      }
      
      public function registerContainerId(param1:String, param2:DisplayObjectContainer) : Boolean
      {
         if(this.isRegisteredContainerId(param1))
         {
            return false;
         }
         this._aContainerList[param1] = param2;
         return true;
      }
      
      public function resetUiSavedUserModification(param1:String = null, param2:Boolean = true, param3:String = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:UiRootContainer = null;
         var _loc14_:String = null;
         var _loc15_:GraphicContainer = null;
         var _loc16_:Point = null;
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:Dictionary = new Dictionary();
         var _loc9_:Dictionary = new Dictionary();
         var _loc10_:Array = StoreDataManager.getInstance().getKeys(BeriliaConstants.DATASTORE_UI_POSITIONS);
         for each(_loc11_ in _loc10_)
         {
            if(!param1 || _loc11_.indexOf(param1 + "##") == 0)
            {
               _loc12_ = _loc11_.split("##");
               _loc5_ = _loc12_[0];
               _loc6_ = _loc12_[2];
               _loc4_ = _loc12_[3];
               _loc13_ = this.getUi(_loc5_);
               _loc14_ = _loc5_ + "_" + _loc6_;
               if(_loc13_ && _loc4_ != this.uiSavedModificationPresetName)
               {
                  if(_loc4_ == param3 && _loc5_.length)
                  {
                     _loc9_[_loc14_] = _loc13_.getElement(_loc6_);
                     _loc7_[_loc5_] = true;
                  }
               }
               else
               {
                  if(!_loc8_[_loc14_] && _loc13_ && _loc13_.getElement(_loc6_))
                  {
                     _loc8_[_loc14_] = true;
                     _loc9_[_loc14_] = _loc13_.getElement(_loc6_);
                     _loc13_.getElement(_loc6_).resetSavedInformations(param2);
                  }
                  _loc7_[_loc5_] = true;
                  if(param2)
                  {
                     StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_POSITIONS,_loc11_,null);
                  }
               }
            }
         }
         if(!param1 && param2)
         {
            StoreDataManager.getInstance().clear(BeriliaConstants.DATASTORE_UI_POSITIONS);
         }
         if(param3)
         {
            this._uiSavedModificationPresetName = param3;
            for each(_loc15_ in _loc9_)
            {
               _loc16_ = _loc15_.getSavedPosition();
               if(_loc16_)
               {
                  _loc15_.xNoCache = _loc16_.x;
                  _loc15_.yNoCache = _loc16_.y;
               }
            }
         }
         for(_loc5_ in _loc7_)
         {
            if(this.getUi(_loc5_))
            {
               this.getUi(_loc5_).render();
               this.getUi(_loc5_).render();
            }
         }
      }
      
      private function onUiLoaded(param1:UiRenderEvent) : void
      {
         delete this._aLoadingUi[param1.uiTarget.name];
         this.updateHighestModalDepth();
         dispatchEvent(param1);
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiLoaded,param1.uiTarget.name);
      }
      
      private function updateHighestModalDepth() : void
      {
         var _loc1_:UiRootContainer = null;
         this._highestModalDepth = -1;
         for each(_loc1_ in this._aUiList)
         {
            if(_loc1_.modal && this._highestModalDepth < _loc1_.depth)
            {
               this._highestModalDepth = _loc1_.depth;
            }
         }
      }
      
      private function isRegisteredUiName(param1:String) : Boolean
      {
         return this._aUiList[param1] != null;
      }
   }
}
