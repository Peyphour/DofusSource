package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.BuildTypeParser;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementListMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.resources.adapters.impl.BitmapAdapter;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class LoadingScreen extends UiRootContainer implements FinalizableUIComponent, IResourceObserver
   {
      
      public static const INFO:uint = 0;
      
      public static const IMPORTANT:uint = 1;
      
      public static const ERROR:uint = 2;
      
      public static const WARNING:uint = 3;
      
      public static const USE_FORGROUND:Boolean = false;
       
      
      private var _loader:IResourceLoader;
      
      private var _value:Number = 0;
      
      private var _levelColor:Array;
      
      private var _background:Class;
      
      private var _bandeau_bas:Class;
      
      private var _foreground:Class;
      
      private var _logoFr:Class;
      
      private var _progessAnim:Class;
      
      private var _tipsBackground:Class;
      
      private var _logBackgroundTx:Class;
      
      private var _btnLogTx:Class;
      
      private var _btnContinue:Class;
      
      private var _txProgressBar:Class;
      
      private var _txProgressBarBackground:Class;
      
      private var _fontProgress:Class;
      
      private var _fontVersion:Class;
      
      private var _tipsBackgroundTexture:TextureBitmap;
      
      private var _progressTf:TextField;
      
      private var _backgroundBitmap:Bitmap;
      
      private var _foregroundBitmap:Bitmap;
      
      private var _backgroundContainer:Sprite;
      
      private var _foregroundContainer:Sprite;
      
      private var _tipsTextField:TextField;
      
      private var _achievementLabel:TextField;
      
      private var _achievementNumbersLabel:TextField;
      
      private var _btnContinueClip:DisplayObject;
      
      private var _continueCallBack:Function;
      
      private var _progressBar:DisplayObject;
      
      private var _progressBarBackground:DisplayObject;
      
      private var _enableTipsScrollBar:Boolean;
      
      private var _lsl:LoadingScreenLight;
      
      private var _bottom:Sprite;
      
      private var _buildsInfo:TextField;
      
      private var _buildsInfoBig:TextField;
      
      private var _btnLog:DisplayObject;
      
      private var _logTf:TextField;
      
      private var _showDetailledVersion:Boolean;
      
      private var _beforeLogin:Boolean;
      
      private var _customLoadingScreen:CustomLoadingScreen;
      
      private var _workerbufferSize:int = -1;
      
      private var _connectionBufferSize:int = -1;
      
      public var logCallbackHandler:Function;
      
      private var _logBg:TextureBitmap;
      
      private var _bandeauBas:Bitmap;
      
      public function LoadingScreen(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false)
      {
         var adapter:BitmapAdapter = null;
         var showDetailledVersion:Boolean = param1;
         var beforeLogin:Boolean = param2;
         var displayMiniUi:Boolean = param3;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._levelColor = new Array(8158332,9216860,11556943,16737792);
         this._background = LoadingScreen__background;
         this._bandeau_bas = LoadingScreen__bandeau_bas;
         this._foreground = LoadingScreen__foreground;
         this._logoFr = LoadingScreen__logoFr;
         this._progessAnim = LoadingScreen__progessAnim;
         this._tipsBackground = LoadingScreen__tipsBackground;
         this._logBackgroundTx = LoadingScreen__logBackgroundTx;
         this._btnLogTx = LoadingScreen__btnLogTx;
         this._btnContinue = LoadingScreen__btnContinue;
         this._txProgressBar = LoadingScreen__txProgressBar;
         this._txProgressBarBackground = LoadingScreen__txProgressBarBackground;
         this._fontProgress = LoadingScreen__fontProgress;
         this._fontVersion = LoadingScreen__fontVersion;
         super(null,null);
         listenResize(true);
         this._showDetailledVersion = showDetailledVersion;
         this._beforeLogin = beforeLogin;
         if(displayMiniUi && AirScanner.hasAir())
         {
            this._lsl = new LoadingScreenLight();
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this._customLoadingScreen = CustomLoadingScreenManager.getInstance().currentLoadingScreen;
         if(this._customLoadingScreen && this._customLoadingScreen.canBeReadOnScreen(beforeLogin))
         {
            try
            {
               adapter = new BitmapAdapter();
               if(this._customLoadingScreen.backgroundImg)
               {
                  adapter.loadFromData(new Uri(this._customLoadingScreen.backgroundUrl),this._customLoadingScreen.backgroundImg,this,false);
               }
               adapter = new BitmapAdapter();
               if(this._customLoadingScreen.foregroundImg)
               {
                  adapter.loadFromData(new Uri(this._customLoadingScreen.foregroundUrl),this._customLoadingScreen.foregroundImg,this,false);
               }
               this._customLoadingScreen.dataStore = CustomLoadingScreenManager.getInstance().dataStore;
               this._customLoadingScreen.isViewing();
            }
            catch(e:Error)
            {
               _log.error("Failed to initialize custom loading screen : " + e);
               _customLoadingScreen = null;
               finalizeInitialization();
            }
         }
         else
         {
            this._customLoadingScreen = null;
         }
         this.finalizeInitialization();
      }
      
      override public function get finalized() : Boolean
      {
         return true;
      }
      
      override public function set finalized(param1:Boolean) : void
      {
      }
      
      public function get closeMiniUiRequestHandler() : Function
      {
         if(this._lsl)
         {
            return this._lsl.closeRequestHandler;
         }
         return null;
      }
      
      public function set closeMiniUiRequestHandler(param1:Function) : void
      {
         if(this._lsl)
         {
            this._lsl.closeRequestHandler = param1;
         }
      }
      
      public function set value(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 100)
         {
            param1 = 100;
         }
         Dofus.getInstance().strProgress = param1;
         if(this._lsl)
         {
            this._lsl.progression = param1 / 100;
         }
         this._value = param1;
         this._progressTf.text = Math.round(param1) + "%";
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      override public function finalize() : void
      {
      }
      
      private function finalizeInitialization() : void
      {
         this._backgroundContainer = new Sprite();
         if(this._customLoadingScreen && this._customLoadingScreen.linkUrl)
         {
            this._backgroundContainer.buttonMode = true;
            this._backgroundContainer.useHandCursor = true;
            this._backgroundContainer.addEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(!this._backgroundBitmap && !this._customLoadingScreen)
         {
            this._backgroundBitmap = this._backgroundContainer.addChild(new this._background()) as Bitmap;
            this._backgroundBitmap.smoothing = true;
            this._backgroundBitmap.x = (StageShareManager.startWidth - this._backgroundBitmap.width) / 2;
            this._backgroundBitmap.y = (StageShareManager.startHeight - this._backgroundBitmap.height) / 2;
         }
         addChild(this._backgroundContainer);
         this._foregroundContainer = new Sprite();
         this._foregroundContainer.mouseEnabled = false;
         this._foregroundContainer.mouseChildren = false;
         if(USE_FORGROUND)
         {
            if(!this._foregroundBitmap && !this._customLoadingScreen)
            {
               this._foregroundBitmap = this._foregroundContainer.addChild(new this._foreground()) as Bitmap;
               this._foregroundBitmap.smoothing = true;
            }
         }
         this._logBg = new TextureBitmap();
         this._logBg.width = 2000;
         this._logBg.x = (StageShareManager.startWidth - this._logBg.width) / 2;
         this._logBg.loadBitmapData(Bitmap(new this._logBackgroundTx()).bitmapData);
         this._logBg.visible = false;
         addChild(this._logBg);
         this._bottom = new Sprite();
         addChild(this._bottom);
         this._logTf = new TextField();
         this._logTf.width = StageShareManager.startWidth;
         this._logTf.x = 10;
         var _loc1_:String = FontManager.initialized && FontManager.getInstance().getFontInfo("Tahoma")?FontManager.getInstance().getFontInfo("Tahoma").className:"Tahoma";
         this._logTf.defaultTextFormat = new TextFormat(_loc1_);
         this._logTf.multiline = true;
         this._bottom.addChild(this._logTf);
         this._logTf.visible = false;
         this._bandeauBas = new this._bandeau_bas();
         this._bandeauBas.y = StageShareManager.startHeight - this._bandeauBas.height;
         this._bandeauBas.x = (StageShareManager.startWidth - this._bandeauBas.width) / 2;
         this._bandeauBas.smoothing = true;
         this._bottom.addChild(this._bandeauBas);
         this._tipsBackgroundTexture = new TextureBitmap();
         this._tipsBackgroundTexture.scale9Grid = new Rectangle();
         this._tipsBackgroundTexture.loadBitmapData(Bitmap(new this._tipsBackground()).bitmapData);
         this._tipsBackgroundTexture.x = 89;
         this._tipsBackgroundTexture.y = 922;
         this._tipsBackgroundTexture.height = 89;
         this._bottom.addChild(this._tipsBackgroundTexture);
         this._tipsBackgroundTexture.visible = false;
         this._tipsTextField = new TextField();
         this._tipsTextField.defaultTextFormat = new TextFormat("LoadingScreenFont",16,13092805,null,null,null,null,null,"center");
         this._tipsTextField.embedFonts = true;
         this._tipsTextField.selectable = false;
         this._tipsTextField.visible = false;
         this._tipsTextField.multiline = true;
         this._tipsTextField.wordWrap = true;
         this._tipsTextField.width = 1000;
         this._tipsTextField.x = (StageShareManager.startWidth - this._tipsTextField.width) / 2;
         this._tipsTextField.height = this._tipsBackgroundTexture.height;
         this._bottom.addChild(this._tipsTextField);
         addChild(this._foregroundContainer);
         this._tipsBackgroundTexture.visible = false;
         var _loc2_:Bitmap = new this._logoFr();
         _loc2_.x = 435;
         _loc2_.y = 653;
         _loc2_.smoothing = true;
         this._bottom.addChild(_loc2_);
         var _loc3_:TextFormat = new TextFormat("LoadingScreenFont",26,6908264,null,null,null,null,null);
         this._progressTf = new TextField();
         this._progressTf.x = 610;
         this._progressTf.y = 871;
         this._progressTf.embedFonts = true;
         this._progressTf.defaultTextFormat = _loc3_;
         this._progressTf.filters = [new DropShadowFilter(1,122,0,1,3,3)];
         this._bottom.addChild(this._progressTf);
         var _loc4_:MovieClip = new this._progessAnim() as MovieClip;
         _loc4_.x = this._progressTf.x - 3 - _loc4_.width;
         _loc4_.y = this._progressTf.y + 9;
         this._bottom.addChild(_loc4_);
         this._buildsInfo = new TextField();
         this._buildsInfo.appendText("Dofus " + BuildInfos.BUILD_VERSION + "\n");
         this._buildsInfo.appendText("Mode " + BuildTypeParser.getTypeName(BuildInfos.BUILD_TYPE) + "\n");
         this._buildsInfo.appendText(BuildInfos.BUILD_DATE + "\n");
         this._buildsInfo.appendText("Player " + Capabilities.version);
         this._buildsInfo.height = 200;
         this._buildsInfo.width = 300;
         this._buildsInfo.setTextFormat(new TextFormat("LoadingScreenFont2",14,6908264,null,true));
         this._buildsInfo.embedFonts = true;
         this._buildsInfo.y = 832;
         this._bottom.addChild(this._buildsInfo);
         this._btnLog = new this._btnLogTx();
         this._btnLog.y = 832;
         this._btnLog.addEventListener(MouseEvent.CLICK,this.onLogClick);
         this._bottom.addChild(this._btnLog);
         this._btnContinueClip = new this._btnContinue() as SimpleButton;
         this._btnContinueClip.x = this._progressTf.x + (this._progressTf.width - this._btnContinueClip.width) / 2;
         this._btnContinueClip.y = this._progressTf.y + this._progressTf.height + 30;
         this._btnContinueClip.addEventListener(MouseEvent.CLICK,this.onContinueClick);
         this._btnContinueClip.visible = false;
         this._bottom.addChild(this._btnContinueClip);
         graphics.beginFill(0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         if(BuildInfos.BUILD_TYPE > BuildTypeEnum.RELEASE)
         {
            this._buildsInfoBig = new TextField();
            this._buildsInfoBig.appendText(BuildTypeParser.getTypeName(BuildInfos.BUILD_TYPE) + " version");
            this._buildsInfoBig.y = 832;
            this._buildsInfoBig.width = 400;
            this._buildsInfoBig.selectable = false;
            this._buildsInfoBig.embedFonts = true;
            this._buildsInfoBig.setTextFormat(new TextFormat("LoadingScreenFont2",40,BuildTypeParser.getTypeColor(BuildInfos.BUILD_TYPE),true));
            this._bottom.addChild(this._buildsInfoBig);
         }
         this.hideTips();
         this.onResize();
         iAmFinalized(this);
      }
      
      public function hideMiniUi() : void
      {
         if(this._lsl)
         {
            this._lsl.destroy();
            this._lsl = null;
         }
      }
      
      private function displayAchievmentProgressBar(param1:AchievementListMessage) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:AchievementCategory = null;
         var _loc7_:int = 0;
         var _loc8_:AchievementCategory = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc2_:Array = AchievementCategory.getAchievementCategories();
         var _loc3_:Boolean = false;
         while(!_loc3_)
         {
            _loc4_ = Math.round(Math.random() * (_loc2_.length - 1));
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.parentId > 0)
            {
               _loc2_.splice(_loc4_,1);
            }
            else
            {
               _loc3_ = true;
            }
         }
         _loc2_ = AchievementCategory.getAchievementCategories();
         var _loc6_:int = 0;
         _loc7_ = 0;
         for each(_loc8_ in _loc2_)
         {
            if(_loc8_.parentId == _loc5_.id || _loc8_.id == _loc5_.id)
            {
               for each(_loc9_ in _loc8_.achievementIds)
               {
                  if(param1.finishedAchievementsIds.indexOf(_loc9_) != -1)
                  {
                     _loc6_++;
                  }
                  _loc7_++;
               }
            }
         }
         this._progressBar = new this._txProgressBar();
         this._progressBarBackground = new this._txProgressBarBackground();
         this._achievementLabel = new TextField();
         this._achievementNumbersLabel = new TextField();
         this._tipsBackgroundTexture.y = this._tipsBackgroundTexture.y - 18;
         this._tipsBackgroundTexture.height = this._tipsBackgroundTexture.height - 200;
         this._tipsTextField.y = this._tipsBackgroundTexture.y + 10;
         _loc10_ = FontManager.initialized && FontManager.getInstance().getFontInfo("Tahoma")?FontManager.getInstance().getFontInfo("Tahoma").className:"Tahoma";
         this._achievementLabel.x = this._tipsBackgroundTexture.x;
         this._achievementLabel.defaultTextFormat = new TextFormat(_loc10_,19,16777215,null,null,null,null,null,"center");
         this._achievementLabel.embedFonts = true;
         this._achievementLabel.selectable = false;
         this._achievementLabel.visible = true;
         this._achievementLabel.multiline = false;
         this._achievementLabel.text = I18n.getUiText("ui.achievement.achievement") + I18n.getUiText("ui.common.colon") + _loc5_.name;
         this._achievementLabel.autoSize = TextFieldAutoSize.LEFT;
         this._achievementNumbersLabel.defaultTextFormat = new TextFormat(_loc10_,19,16777215,null,null,null,null,null,"center");
         this._achievementNumbersLabel.embedFonts = true;
         this._achievementNumbersLabel.selectable = false;
         this._achievementNumbersLabel.visible = true;
         this._achievementNumbersLabel.multiline = false;
         this._achievementNumbersLabel.text = _loc6_ + " / " + _loc7_;
         this._achievementNumbersLabel.autoSize = TextFieldAutoSize.LEFT;
         this._achievementNumbersLabel.x = this._tipsBackgroundTexture.x + this._tipsBackgroundTexture.width - this._achievementNumbersLabel.width;
         this._progressBarBackground.height = -3;
         this._progressBarBackground.x = this._achievementLabel.x + this._achievementLabel.width + 5;
         this._progressBarBackground.y = this._tipsBackgroundTexture.y + this._tipsBackgroundTexture.height + 5;
         this._achievementLabel.y = this._progressBarBackground.y - this._achievementLabel.height / 4;
         this._achievementLabel.height = this._progressBarBackground.height;
         this._achievementNumbersLabel.height = this._progressBarBackground.height;
         this._achievementNumbersLabel.y = this._progressBarBackground.y - this._achievementNumbersLabel.height / 4;
         this._progressBar.x = this._progressBarBackground.x;
         this._progressBar.y = this._progressBarBackground.y;
         this._progressBarBackground.width = this._tipsBackgroundTexture.x + this._tipsBackgroundTexture.width - this._achievementNumbersLabel.width - this._progressBarBackground.x - 5;
         var _loc11_:ColorTransform = new ColorTransform();
         _loc11_.color = uint(_loc5_.color);
         this._progressBar.transform.colorTransform = _loc11_;
         var _loc12_:Number = _loc6_ / _loc7_;
         this._progressBar.width = _loc12_ * this._progressBarBackground.width;
         this._progressBar.visible = true;
         this._progressBarBackground.visible = true;
         addChild(this._progressBarBackground);
         addChild(this._progressBar);
         addChild(this._achievementLabel);
         addChild(this._achievementNumbersLabel);
      }
      
      public function log(param1:String, param2:uint) : void
      {
         var _loc3_:ColorTransform = null;
         if(param2 == ERROR || param2 == WARNING)
         {
            _loc3_ = new ColorTransform();
            _loc3_.color = this._levelColor[param2];
            this._progressTf.transform.colorTransform = _loc3_;
            this.showLog(true);
         }
         this._logTf.htmlText = this._logTf.htmlText + ("<p><font color=\"#" + uint(this._levelColor[param2]).toString(16) + "\">" + param1 + "</font></p>");
         this._logTf.scrollV = this._logTf.maxScrollV;
         if(this.logCallbackHandler != null)
         {
            this.logCallbackHandler(param1,param2);
         }
      }
      
      public function showLog(param1:Boolean) : void
      {
         this._logBg.visible = param1;
         this._logTf.visible = param1;
      }
      
      public function hideTips() : void
      {
         this._bottom.y = 102;
         this._tipsTextField.visible = false;
         this._tipsBackgroundTexture.visible = false;
      }
      
      public function set tip(param1:String) : void
      {
         var _loc2_:Scrollbar = null;
         this._bottom.y = 0;
         this._tipsTextField.visible = true;
         this._tipsBackgroundTexture.visible = true;
         this._tipsTextField.htmlText = param1;
         this._tipsTextField.y = this._tipsBackgroundTexture.y + (this._tipsBackgroundTexture.height - this._tipsTextField.textHeight) / 2;
         if(this._tipsTextField.numLines > 3 && this._enableTipsScrollBar)
         {
            _loc2_ = new Scrollbar(this._tipsTextField);
            _loc2_.y = this._tipsBackgroundTexture.y;
            _loc2_.x = 1170;
            addChild(_loc2_);
         }
      }
      
      public function set tipSelectable(param1:Boolean) : void
      {
         this._tipsTextField.selectable = param1;
      }
      
      public function set enableTipsScrollBar(param1:Boolean) : void
      {
         this._enableTipsScrollBar = param1;
      }
      
      public function set continueCallbak(param1:Function) : void
      {
         this._btnContinueClip.visible = true;
         this.showLog(true);
         this.hideTips();
         this._continueCallBack = param1;
      }
      
      private function onLogClick(param1:Event) : void
      {
         this.showLog(!this._logTf.visible);
      }
      
      private function onContinueClick(param1:Event) : void
      {
         this._continueCallBack();
      }
      
      public function onLoaded(param1:Uri, param2:uint, param3:*) : void
      {
         if(this._customLoadingScreen)
         {
            switch(param1.toString())
            {
               case new Uri(this._customLoadingScreen.backgroundUrl).toString():
                  if(this._backgroundBitmap)
                  {
                     this._backgroundContainer.removeChild(this._backgroundBitmap);
                  }
                  this._backgroundBitmap = new Bitmap(param3 as BitmapData);
                  this._backgroundBitmap.smoothing = true;
                  this._backgroundBitmap.x = (StageShareManager.startWidth - this._backgroundBitmap.width) / 2;
                  this._backgroundBitmap.y = (StageShareManager.startHeight - this._backgroundBitmap.height) / 2;
                  this._backgroundContainer.addChild(this._backgroundBitmap);
                  break;
               case new Uri(this._customLoadingScreen.foregroundUrl).toString():
                  if(this._foregroundBitmap)
                  {
                     this._foregroundContainer.removeChild(this._foregroundBitmap);
                  }
                  this._foregroundBitmap = new Bitmap(param3 as BitmapData);
                  this._foregroundBitmap.smoothing = true;
                  this._backgroundBitmap.x = (StageShareManager.startWidth - this._backgroundBitmap.width) / 2;
                  this._backgroundBitmap.y = (StageShareManager.startHeight - this._backgroundBitmap.height) / 2;
                  this._foregroundContainer.addChild(this._foregroundBitmap);
            }
         }
      }
      
      public function onClick(param1:MouseEvent) : void
      {
         if(this._customLoadingScreen && this._customLoadingScreen.canBeReadOnScreen(this._beforeLogin) && this._customLoadingScreen.linkUrl)
         {
            navigateToURL(new URLRequest(this._customLoadingScreen.linkUrl));
         }
      }
      
      public function onFailed(param1:Uri, param2:String, param3:uint) : void
      {
         _log.error("Failed to load custom loading screen picture (" + param1.toString() + ")");
      }
      
      public function onProgress(param1:Uri, param2:uint, param3:uint) : void
      {
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Vector.<Message> = Kernel.getWorker().pausedQueue;
         var _loc3_:Array = ConnectionsHandler.getConnection().getPauseBuffer();
         var _loc4_:AchievementListMessage = null;
         if(_loc2_.length > this._workerbufferSize)
         {
            if(this._workerbufferSize <= 0)
            {
               _loc5_ = 0;
            }
            else
            {
               _loc5_ = this._workerbufferSize - 1;
            }
            this._workerbufferSize = _loc2_.length;
            while(_loc5_ < this._workerbufferSize)
            {
               if(_loc2_[_loc5_] is AchievementListMessage)
               {
                  _loc4_ = _loc2_[_loc5_] as AchievementListMessage;
                  break;
               }
               _loc5_++;
            }
         }
         if(!_loc4_ && _loc3_.length > this._connectionBufferSize)
         {
            if(this._connectionBufferSize <= 0)
            {
               _loc5_ = 0;
            }
            else
            {
               _loc5_ = this._connectionBufferSize - 1;
            }
            this._connectionBufferSize = _loc3_.length;
            while(_loc5_ < this._connectionBufferSize)
            {
               if(_loc3_[_loc5_] is AchievementListMessage)
               {
                  _loc4_ = _loc3_[_loc5_] as AchievementListMessage;
                  break;
               }
               _loc5_++;
            }
         }
         if(_loc4_)
         {
            EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
            this.displayAchievmentProgressBar(_loc4_);
         }
      }
      
      public function refreshSize() : void
      {
         this.onResize();
      }
      
      override protected function onResize(param1:Event = null) : void
      {
         var _loc2_:Rectangle = null;
         if(this._logTf)
         {
            _loc2_ = StageShareManager.stageVisibleBounds;
            this._logTf.x = _loc2_.left + 10;
            this._buildsInfo.x = _loc2_.left + 50;
            if(this._buildsInfoBig)
            {
               this._buildsInfoBig.x = _loc2_.right - this._buildsInfoBig.textWidth - 10;
            }
            this._btnLog.x = _loc2_.left + 10;
            this._tipsBackgroundTexture.width = _loc2_.width - 100;
            this._tipsBackgroundTexture.x = _loc2_.left + (_loc2_.width - this._tipsBackgroundTexture.width) / 2;
            this._logTf.y = -this._bottom.y;
            this._logTf.height = this._bottom.y + this._bandeauBas.y - 5;
         }
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(this._lsl)
         {
            this._lsl.destroy();
         }
      }
   }
}

import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
import com.ankamagames.jerakine.utils.display.StageShareManager;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

class Scrollbar extends Sprite
{
    
   
   private var _sbDownArrow:Class;
   
   private var _sbUpArrow:Class;
   
   private var _sbCursor:Class;
   
   private var _textfield:TextField;
   
   private var _cursor:MovieClip;
   
   private var _cursorY:Number;
   
   private var _lastCursorY:Number;
   
   private var _scrollStep:Number;
   
   private var _scrollHeight:Number;
   
   function Scrollbar(param1:TextField)
   {
      var dragBounds:Rectangle = null;
      var pTextfield:TextField = param1;
      this._sbDownArrow = Scrollbar__sbDownArrow;
      this._sbUpArrow = Scrollbar__sbUpArrow;
      this._sbCursor = Scrollbar__sbCursor;
      super();
      this._textfield = pTextfield;
      var upArrow:MovieClip = new this._sbUpArrow();
      var downArrow:MovieClip = new this._sbDownArrow();
      this._cursor = new this._sbCursor();
      upArrow.gotoAndStop(0);
      upArrow.buttonMode = true;
      downArrow.gotoAndStop(0);
      downArrow.buttonMode = true;
      this._cursor.gotoAndStop(0);
      this._cursor.buttonMode = true;
      this._cursorY = upArrow.height;
      addChild(upArrow);
      downArrow.y = this._textfield.height - downArrow.height;
      addChild(downArrow);
      addChild(this._cursor);
      this._scrollHeight = downArrow.y - this._cursor.height - this._cursorY;
      this._scrollStep = this._scrollHeight / (this._textfield.maxScrollV - 1);
      this.updateCursorPos();
      upArrow.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
      {
         if(_textfield.scrollV > 1)
         {
            _textfield.scrollV--;
         }
         updateCursorPos();
      });
      downArrow.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
      {
         if(_textfield.scrollV < _textfield.maxScrollV)
         {
            _textfield.scrollV++;
         }
         updateCursorPos();
      });
      this._textfield.addEventListener(Event.SCROLL,function(param1:Event):void
      {
         updateCursorPos();
      });
      dragBounds = new Rectangle(0,this._cursorY,0,this._scrollHeight);
      this._cursor.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
      {
         _cursor.startDrag(false,dragBounds);
      });
      StageShareManager.stage.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
      {
         _cursor.stopDrag();
      });
      EnterFrameDispatcher.addEventListener(this.updateScroll,"LoadingScreenScrollbar");
   }
   
   private function updateCursorPos() : void
   {
      this._cursor.y = this._cursorY + (this._textfield.scrollV - 1) * this._scrollStep;
   }
   
   private function updateScroll(param1:Event) : void
   {
      var _loc2_:Number = this._cursorY + (this._textfield.scrollV - 1) * this._scrollStep;
      if(this._cursor.y <= _loc2_ - this._scrollStep && this._textfield.scrollV > 1)
      {
         this._textfield.scrollV--;
      }
      else if(this._cursor.y >= _loc2_ + this._scrollStep && this._textfield.scrollV < this._textfield.maxScrollV)
      {
         this._textfield.scrollV++;
      }
   }
}
