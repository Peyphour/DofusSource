package ui
{
   import com.ankamagames.arena.dofusmodule.adapter.ChatDofusCommnunicator;
   import com.ankamagames.arena.dofusmodule.adapter.GeneralDofusCommunicator;
   import com.ankamagames.arena.dofusmodule.adapter.OptionDofusCommunicator;
   import com.ankamagames.arena.dofusmodule.adapter.SSODofusCommunicator;
   import d2actions.KrosmasterPlayingStatus;
   import d2api.ConfigApi;
   import d2api.FileApi;
   import d2api.SoundApi;
   import d2api.SystemApi;
   import d2api.TimeApi;
   import d2api.UiApi;
   import d2components.ButtonContainer;
   import d2components.SwfApplication;
   import d2components.Texture;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class ArenaGameUi extends EventDispatcher
   {
      
      public static const ARENA_PATH_DEBUG:String = "http://arena-game.ankama.lan/arena/release/arena-client/";
      
      public static const ARENA_FILE_PATH_DEBUG:String = ARENA_PATH_DEBUG + "url.xml";
      
      public static const ARENA_PATH_INTERNAL:String = "http://arena-game.ankama.lan/arena/release/arena-client/";
      
      public static const ARENA_FILE_PATH_INTERNAL:String = ARENA_PATH_INTERNAL + "url.xml";
      
      public static const ARENA_PATH_TESTING:String = "http://arena-game.ankama.lan/arena/release/arena-client/";
      
      public static const ARENA_FILE_PATH_TESTING:String = ARENA_PATH_TESTING + "url.xml";
      
      public static const ARENA_PATH_ALPHA:String = "http://dl.ak.ankama.com/games/krosmaster_arena/preprod/arena-client/";
      
      public static const ARENA_FILE_PATH_ALPHA:String = ARENA_PATH_ALPHA + "url.xml";
      
      public static const ARENA_PATH_BETA:String = "http://dl.ak.ankama.com/games/krosmaster_arena/preprod/arena-client/";
      
      public static const ARENA_FILE_PATH_BETA:String = ARENA_PATH_BETA + "url.xml";
      
      public static const ARENA_PATH_RELEASE:String = "http://dl.ak.ankama.com/games/krosmaster_arena/prod/arena-client/";
      
      public static const ARENA_FILE_PATH_RELEASE:String = ARENA_PATH_RELEASE + "url.xml";
      
      public static const EVT_MAXIMISE:String = "ui.ArenaGameUi.EVT_MAXIMISE";
      
      public static const EVT_MINIMISE:String = "ui.ArenaGameUi.EVT_MINIMISE";
      
      private static var _gaugeWidthCategory:int;
       
      
      public const MODULE_NAME:String = "Module ArenaUi";
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fileApi:FileApi;
      
      public var timeApi:TimeApi;
      
      public var soundApi:SoundApi;
      
      public var configApi:ConfigApi;
      
      public var game:SwfApplication;
      
      public var closeButton:ButtonContainer;
      
      public var minusButton:ButtonContainer;
      
      public var plusButton:ButtonContainer;
      
      public var tx_progress:Texture;
      
      public var tx_progress_bkg:Texture;
      
      private var _gaugeColorTransform:ColorTransform;
      
      private var _chatCommunicator:ChatDofusCommnunicator;
      
      private var _ssoCommunicator:SSODofusCommunicator;
      
      private var _optionCommunicator:OptionDofusCommunicator;
      
      private var _generalCommunicator:GeneralDofusCommunicator;
      
      public function ArenaGameUi()
      {
         super();
         this._gaugeColorTransform = new ColorTransform();
      }
      
      public function main(param1:Object) : void
      {
         this._generalCommunicator = new GeneralDofusCommunicator(this.sysApi,this.timeApi);
         this._generalCommunicator.addEventListener(GeneralDofusCommunicator.EVT_CLOSE_ARENA_IN_DOFUS_REQUEST,this.closeArenaRequestHandler,false,0,true);
         this._chatCommunicator = new ChatDofusCommnunicator(this.sysApi,this.timeApi);
         this._ssoCommunicator = new SSODofusCommunicator(this.sysApi);
         this._optionCommunicator = new OptionDofusCommunicator(this.sysApi,this.soundApi,this.configApi);
         _gaugeWidthCategory = int(this.uiApi.me().getConstant("gauge_width_category"));
         this.uiApi.addComponentHook(this.closeButton,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.closeButton,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.minusButton,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.minusButton,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.plusButton,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.plusButton,ComponentHookList.ON_ROLL_OUT);
         switch(this.sysApi.getBuildType())
         {
            case BuildTypeEnum.DEBUG:
               this.loadArenaPath(ARENA_FILE_PATH_DEBUG);
               break;
            case BuildTypeEnum.INTERNAL:
               this.loadArenaPath(ARENA_FILE_PATH_INTERNAL);
               break;
            case BuildTypeEnum.TESTING:
               this.loadArenaPath(ARENA_FILE_PATH_TESTING);
               break;
            case BuildTypeEnum.ALPHA:
               this.loadArenaPath(ARENA_FILE_PATH_ALPHA);
               break;
            case BuildTypeEnum.BETA:
               this.loadArenaPath(ARENA_FILE_PATH_BETA);
               break;
            case BuildTypeEnum.RELEASE:
               this.loadArenaPath(ARENA_FILE_PATH_RELEASE);
               break;
            default:
               this.closeArena();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1 == this.closeButton)
         {
            _loc2_ = this._generalCommunicator.getText(GeneralDofusCommunicator.CLOSE_ARENA_KEY);
         }
         if(param1 == this.minusButton)
         {
            _loc2_ = this._generalCommunicator.getText(GeneralDofusCommunicator.REDUCE_ARENA_KEY);
         }
         if(param1 == this.plusButton)
         {
            _loc2_ = this._generalCommunicator.getText(GeneralDofusCommunicator.RESTORE_ARENA_KEY);
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function unload() : void
      {
      }
      
      public function onLoadSwfApplicationReady(param1:SwfApplication) : void
      {
         if(this.game.bindApi("generalCommunicator",this._generalCommunicator))
         {
         }
         if(this.game.bindApi("chatCommunicator",this._chatCommunicator))
         {
         }
         if(this.game.bindApi("ssoCommunicator",this._ssoCommunicator))
         {
         }
         if(this.game.bindApi("optionCommunicator",this._optionCommunicator))
         {
         }
         this.openArena();
      }
      
      public function onLoadSwfApplicationError(param1:SwfApplication, param2:*) : void
      {
         this.closeArena();
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.closeButton:
               this._generalCommunicator.dispatchEvent(new Event(GeneralDofusCommunicator.EVT_DOFUS_CLOSE_BUTTON_CLICKED));
               break;
            case this.minusButton:
               this.game.visible = false;
               this.sysApi.showWorld(true);
               this._optionCommunicator.minimise();
               this._generalCommunicator.dispatchEvent(new Event(EVT_MINIMISE));
               this.uiApi.getUi("banner").visible = true;
               this.uiApi.getUi("chat").visible = true;
               this.minusButton.visible = false;
               this.plusButton.visible = true;
               break;
            case this.plusButton:
               this.game.visible = true;
               this.sysApi.showWorld(false);
               this._optionCommunicator.maximise();
               this._generalCommunicator.dispatchEvent(new Event(EVT_MAXIMISE));
               this.uiApi.getUi("banner").visible = false;
               this.uiApi.getUi("chat").visible = false;
               this.minusButton.visible = true;
               this.plusButton.visible = false;
         }
      }
      
      public function openArena() : void
      {
         this.sysApi.showWorld(false);
         this.game.mouseEnabled = true;
         this.game.mouseChildren = true;
         this.uiApi.getUi("banner").visible = false;
         this.uiApi.getUi("chat").visible = false;
         this.plusButton.visible = false;
         this.sysApi.sendAction(new KrosmasterPlayingStatus(true));
         this._optionCommunicator.maximise();
         this.hideProgressBar();
      }
      
      public function closeArena() : void
      {
         this.sysApi.showWorld(true);
         this._optionCommunicator.minimise();
         this.uiApi.getUi("banner").visible = true;
         this.uiApi.getUi("chat").visible = true;
         this._generalCommunicator.destroy();
         this.sysApi.sendAction(new KrosmasterPlayingStatus(false));
         this.uiApi.unloadUi("ArenaGameUi");
         this.hideProgressBar();
      }
      
      private function hideProgressBar() : void
      {
         if(this.tx_progress)
         {
            this.tx_progress.visible = false;
         }
         if(this.tx_progress_bkg)
         {
            this.tx_progress_bkg.visible = false;
         }
      }
      
      private function loadArenaPath(param1:String) : void
      {
         this.fileApi.trustedLoadXmlFile(param1,this.loadSuccessHandler,this.loadErrorHandler);
      }
      
      private function closeArenaRequestHandler(param1:Event) : void
      {
         this.closeArena();
      }
      
      private function loadErrorHandler(param1:uint, param2:String) : void
      {
         this.closeArena();
      }
      
      private function loadSuccessHandler(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(this.sysApi.getBuildType())
         {
            case BuildTypeEnum.DEBUG:
               _loc2_ = ARENA_PATH_DEBUG + param1.game[0].@url;
               break;
            case BuildTypeEnum.INTERNAL:
               _loc2_ = ARENA_PATH_INTERNAL + param1.game[0].@url;
               break;
            case BuildTypeEnum.TESTING:
               _loc2_ = ARENA_PATH_TESTING + param1.game[0].@url;
               break;
            case BuildTypeEnum.ALPHA:
               _loc2_ = ARENA_PATH_ALPHA + param1.game[0].@url;
               break;
            case BuildTypeEnum.BETA:
               _loc2_ = ARENA_PATH_BETA + param1.game[0].@url;
               break;
            case BuildTypeEnum.RELEASE:
               _loc2_ = ARENA_PATH_RELEASE + param1.game[0].@url;
         }
         this.game.loadedHandler = this.onLoadSwfApplicationReady;
         this.game.loadErrorHandler = this.onLoadSwfApplicationError;
         this.game.loadProgressHandler = this.onLoadProgressHandler;
         this.game.uri = this.uiApi.createUri(_loc2_);
      }
      
      private function onLoadProgressHandler(param1:SwfApplication, param2:Object) : void
      {
         this._gaugeColorTransform.color = 16761925;
         this.tx_progress.transform.colorTransform = this._gaugeColorTransform;
         this.tx_progress.width = int(param2.bytesLoaded / param2.bytesTotal * _gaugeWidthCategory);
      }
   }
}
