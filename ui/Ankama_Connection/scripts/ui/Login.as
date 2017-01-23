package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.InputComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.WebBrowser;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.StateContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.BrowserDomainReady;
   import d2actions.LoginAsGuest;
   import d2actions.LoginValidation;
   import d2actions.LoginWithSteam;
   import d2actions.SubscribersGiftListRequest;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.WebLocationEnum;
   import d2hooks.KeyUp;
   import d2hooks.NicknameRegistration;
   import d2hooks.QualitySelectionRequired;
   import d2hooks.SelectedServerFailed;
   import d2hooks.SubscribersList;
   import d2hooks.UiUnloaded;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Login
   {
      
      private static const GAMEMODE_NONE:uint = 0;
      
      private static const GAMEMODE_LOG_IN:uint = 1;
      
      private static const GAMEMODE_PLAY_AS_GUEST:uint = 2;
      
      private static const GAMEMODE_LOG_IN_OAUTH:uint = 3;
      
      private static const GAMEMODE_LOG_IN_STEAM:uint = 4;
       
      
      public var dataApi:DataApi;
      
      public var sysApi:SystemApi;
      
      public var configApi:ConfigApi;
      
      public var uiApi:UiApi;
      
      public var soundApi:SoundApi;
      
      public var connectionApi:ConnectionApi;
      
      public var tooltipApi:TooltipApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _guestModeAvailable:Boolean = false;
      
      private var _oauthLoginAvailable:Boolean = false;
      
      private var _currentMode:uint = 0;
      
      private var _aPorts:Array;
      
      private var _aPortsName:Array;
      
      private var _componentsList:Dictionary;
      
      private var _previousFocus:Input;
      
      private var _ankamaAuthUrl:String;
      
      private var _ankamaAuthBaseUrl:String;
      
      private var _domain:int = -1;
      
      private var _mustDisableConnectionButton:Boolean = false;
      
      private var _timeoutId:uint;
      
      public var ctr_welcome:GraphicContainer;
      
      public var ctr_tabs:GraphicContainer;
      
      public var btn_registeredTab:ButtonContainer;
      
      public var btn_guestTab:ButtonContainer;
      
      public var ctr_center:GraphicContainer;
      
      public var ctr_links:GraphicContainer;
      
      public var ctr_inputs:StateContainer;
      
      public var ctr_login:GraphicContainer;
      
      public var ctr_pass:GraphicContainer;
      
      public var cbx_login:InputComboBox;
      
      public var input_pass:Input;
      
      public var lbl_login:Label;
      
      public var lbl_pass:Label;
      
      public var lbl_capsLock:Label;
      
      public var ctr_capsLockMsg:GraphicContainer;
      
      public var btn_passForgotten:ButtonContainer;
      
      public var btn_createAccount:ButtonContainer;
      
      public var ctr_guestMode:GraphicContainer;
      
      public var lbl_guestModeInfo:Label;
      
      public var btn_play:ButtonContainer;
      
      public var btn_options:ButtonContainer;
      
      public var ctr_options:GraphicContainer;
      
      public var btn_rememberLogin:ButtonContainer;
      
      public var cb_connectionType:ComboBox;
      
      public var cb_socket:ComboBox;
      
      public var ctr_gifts:GraphicContainer;
      
      public var btn_members:ButtonContainer;
      
      public var btn_lowa:ButtonContainer;
      
      public var gd_shop:Grid;
      
      public var ctr_oauthServices:GraphicContainer;
      
      public var btn_login_ankama:ButtonContainer;
      
      public var btn_login_facebook:ButtonContainer;
      
      public var btn_login_twitter:ButtonContainer;
      
      public var btn_login_google:ButtonContainer;
      
      public var ctr_steam:GraphicContainer;
      
      public var btn_login_steam:ButtonContainer;
      
      public var ctr_webLogin:GraphicContainer;
      
      public var wb_webLogin:WebBrowser;
      
      public var btn_webLoginClose:ButtonContainer;
      
      public var btn_oauth:ButtonContainer;
      
      public function Login()
      {
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         if(param1.length > 0)
         {
            _loc2_ = param1[0];
         }
         if(param1.length > 1)
         {
            this._mustDisableConnectionButton = param1[1];
         }
         var _loc3_:uint = this.sysApi.getSetData("loginUiMode",GAMEMODE_NONE);
         this.sysApi.log(2,"HZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
         if(this.sysApi.isStreaming())
         {
            this._guestModeAvailable = true;
         }
         this.btn_play.soundId = "-1";
         this.soundApi.playIntroMusic();
         this.sysApi.addHook(NicknameRegistration,this.onNicknameRegistration);
         this.sysApi.addHook(SubscribersList,this.onSubscribersList);
         this.sysApi.addHook(UiUnloaded,this.onUiUnloaded);
         this.sysApi.addHook(SelectedServerFailed,this.onSelectedServerFailed);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_rememberLogin,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_rememberLogin,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_oauth,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_oauth,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_rememberLogin,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.cb_connectionType,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_socket,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.input_pass,"onChange");
         if(!this.sysApi.isSteamEmbed())
         {
            this.sysApi.sendAction(new SubscribersGiftListRequest());
         }
         this.ctr_gifts.visible = false;
         this.ctr_tabs.visible = this._guestModeAvailable;
         this.ctr_welcome.visible = !this._guestModeAvailable;
         if(!this._oauthLoginAvailable)
         {
            this.btn_oauth.visible = false;
         }
         this.uiApi.addComponentHook(this.cbx_login,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cbx_login.input,"onChange");
         this.ctr_options.visible = false;
         if(this.connectionApi.hasGuestAccount())
         {
            this.lbl_guestModeInfo.text = this.uiApi.getText("ui.guest.guestAccountExisting");
         }
         else
         {
            this.lbl_guestModeInfo.text = this.uiApi.getText("ui.guest.guestModeInfo");
         }
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_registeredTab,this.uiApi.me());
         this.btn_registeredTab.selected = true;
         this.cbx_login.input.tabEnabled = true;
         this.input_pass.tabEnabled = true;
         var _loc4_:Boolean = false;
         var _loc5_:int = this.sysApi.getPort();
         this._aPorts = new Array();
         this._aPortsName = new Array();
         var _loc6_:String = this.sysApi.getConfigKey("connection.port");
         for each(_loc7_ in _loc6_.split(","))
         {
            this._aPorts.push(int(_loc7_));
            this._aPortsName.push("" + _loc7_);
            if(_loc5_ == int(_loc7_))
            {
               _loc4_ = true;
            }
         }
         this.cb_socket.dataProvider = this._aPortsName;
         if(_loc5_ && _loc4_)
         {
            _loc8_ = _loc5_;
         }
         else
         {
            _loc8_ = this._aPorts[0];
            this.sysApi.setPort(this._aPorts[0]);
         }
         this.cb_socket.value = this._aPortsName[this._aPorts.indexOf(_loc8_)];
         this.cb_connectionType.dataProvider = [{
            "label":this.uiApi.getText("ui.connection.connectionToServerChoice"),
            "type":0
         },{
            "label":this.uiApi.getText("ui.connection.connectionToCharacterChoice"),
            "type":1
         },{
            "label":this.uiApi.getText("ui.connection.connectionDirectAccess"),
            "type":2
         }];
         var _loc9_:uint = this.configApi.getConfigProperty("dofus","autoConnectType");
         this.cb_connectionType.value = this.cb_connectionType.dataProvider[_loc9_];
         if(!this.sysApi.isStreaming() && this._oauthLoginAvailable)
         {
            this.wb_webLogin = this.uiApi.createComponent("WebBrowser") as WebBrowser;
            this.wb_webLogin.x = 12;
            this.wb_webLogin.y = 10;
            this.wb_webLogin.width = 1179;
            this.wb_webLogin.height = 660;
            this.wb_webLogin.displayScrollBar = false;
            this.wb_webLogin.finalize();
            this.uiApi.addChildAt(this.ctr_webLogin,this.wb_webLogin,0);
            this.uiApi.addComponentHook(this.wb_webLogin,"onBrowserSessionTimeout");
            this.uiApi.addComponentHook(this.wb_webLogin,"onBrowserDomReady");
            this._domain = WebLocationEnum.WEB_LOCATION_WEB_AUTHENTIFICATION;
         }
         this.cbx_login.input.restrict = "A-Za-z0-9\\-\\|.@_[]";
         if(this.sysApi.isEventMode())
         {
            this.uiApi.setFullScreen(true,true);
            this.cbx_login.input.text = this.uiApi.getText("ui.connection.eventModeLogin");
            this.input_pass.text = "**********";
            this.cbx_login.disabled = true;
            this.input_pass.disabled = true;
            this.ctr_inputs.state = "DISABLED";
            this.btn_rememberLogin.disabled = true;
            this.btn_rememberLogin.mouseEnabled = false;
            this.cb_connectionType.disabled = true;
         }
         else
         {
            if(this.sysApi.getConfigKey("boo") == "1" && this.sysApi.getBuildType() > 1)
            {
               this.input_pass.text = !!this.sysApi.getData("LastPassword")?this.sysApi.getData("LastPassword"):"";
            }
            else
            {
               this.lbl_pass.text = this.uiApi.getText("ui.login.password");
            }
            _loc10_ = this.sysApi.getData("saveLogin");
            if(_loc10_ == 0)
            {
               Connection.loginMustBeSaved = 1;
               this.btn_rememberLogin.selected = true;
               this.sysApi.setData("saveLogin",1);
            }
            else
            {
               Connection.loginMustBeSaved = _loc10_;
               this.btn_rememberLogin.selected = _loc10_ == 1;
            }
            _loc11_ = this.sysApi.getData("LastLogins");
            if(_loc11_ && _loc11_.length > 0)
            {
               if(_loc11_.length >= this.sysApi.getNumberOfClients())
               {
                  this.cbx_login.input.text = _loc11_[this.sysApi.getClientId() - 1];
               }
               else
               {
                  this.cbx_login.input.text = _loc11_[0];
               }
               this.cbx_login.dataProvider = _loc11_;
               this.input_pass.focus();
            }
            else
            {
               _loc12_ = this.sysApi.getData("LastLogin");
               if(_loc12_ && _loc12_.length > 0)
               {
                  this.sysApi.setData("LastLogin","");
                  _loc13_ = new Array();
                  _loc13_.push(_loc12_);
                  this.sysApi.setData("LastLogins",_loc13_);
                  this.sysApi.setData("saveLogin",1);
                  Connection.loginMustBeSaved = 1;
                  this.btn_rememberLogin.selected = true;
                  this.cbx_login.input.text = _loc12_;
                  this.cbx_login.dataProvider = _loc13_;
                  this.input_pass.focus();
               }
               else
               {
                  this.lbl_login.text = this.uiApi.getText("ui.login.username");
                  this.cbx_login.input.focus();
               }
            }
         }
         if(_loc2_ == "unexpectedSocketClosure")
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.unexpectedSocketClosure"),this.uiApi.getText("ui.popup.unexpectedSocketClosure.text"),[this.uiApi.getText("ui.common.ok")]);
         }
         this.lbl_capsLock.multiline = false;
         this.lbl_capsLock.wordWrap = false;
         this.lbl_capsLock.fullWidth();
         this.ctr_capsLockMsg.width = this.lbl_capsLock.textfield.width + 12;
         if(!Keyboard.capsLock || this.sysApi.getOs() == "Mac OS")
         {
            this.lbl_capsLock.visible = false;
            this.ctr_capsLockMsg.visible = false;
         }
         this.sysApi.dispatchHook(QualitySelectionRequired);
         if(this.sysApi.isSteamEmbed())
         {
            _loc3_ = GAMEMODE_LOG_IN_STEAM;
         }
         else if(_loc3_ == GAMEMODE_NONE || _loc3_ == GAMEMODE_LOG_IN_STEAM)
         {
            if(this.cbx_login.dataProvider && this.cbx_login.dataProvider.length)
            {
               _loc3_ = GAMEMODE_LOG_IN;
            }
            else if(this._guestModeAvailable && this.connectionApi.hasGuestAccount())
            {
               _loc3_ = GAMEMODE_PLAY_AS_GUEST;
            }
            else if(this._oauthLoginAvailable)
            {
               _loc3_ = GAMEMODE_LOG_IN_OAUTH;
            }
            else
            {
               _loc3_ = GAMEMODE_LOG_IN;
            }
         }
         else if(!this._guestModeAvailable && _loc3_ == GAMEMODE_PLAY_AS_GUEST || !this._oauthLoginAvailable && _loc3_ == GAMEMODE_LOG_IN_OAUTH)
         {
            _loc3_ = GAMEMODE_LOG_IN;
         }
         this._timeoutId = setTimeout(this.switchUiMode,1,_loc3_);
      }
      
      public function unload() : void
      {
         clearTimeout(this._timeoutId);
         if(this.uiApi)
         {
            this.uiApi.hideTooltip();
         }
      }
      
      public function disableUi(param1:Boolean) : void
      {
         this.cbx_login.input.mouseEnabled = !param1;
         this.cbx_login.input.mouseChildren = !param1;
         this.input_pass.mouseEnabled = !param1;
         this.input_pass.mouseChildren = !param1;
         if(param1)
         {
            this.ctr_inputs.state = "DISABLED";
            if(this.cbx_login.input.haveFocus)
            {
               this._previousFocus = this.cbx_login.input;
            }
            else if(this.input_pass.haveFocus)
            {
               this._previousFocus = this.input_pass;
            }
            this.btn_play.focus();
         }
         else
         {
            this.ctr_inputs.state = "NORMAL";
            if(this._previousFocus)
            {
               this._previousFocus.focus();
               this._previousFocus = null;
            }
         }
         this.btn_play.disabled = param1;
         this.btn_login_steam.disabled = param1;
         this.btn_rememberLogin.disabled = param1;
         this.btn_rememberLogin.mouseEnabled = !param1;
         this.cbx_login.disabled = param1;
         this.cb_connectionType.disabled = param1;
         this.btn_oauth.disabled = param1;
         this.btn_login_ankama.disabled = param1;
         this.btn_login_facebook.disabled = param1;
         this.btn_login_twitter.disabled = param1;
         this.btn_login_google.disabled = param1;
      }
      
      public function updateLoginLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:String = !!param2.hasOwnProperty("btn_removeLogin")?"":"2";
         if(!this._componentsList[param2["btn_removeLogin" + _loc4_].name])
         {
            this.uiApi.addComponentHook(param2["btn_removeLogin" + _loc4_],"onRelease");
            this.uiApi.addComponentHook(param2["btn_removeLogin" + _loc4_],"onRollOut");
            this.uiApi.addComponentHook(param2["btn_removeLogin" + _loc4_],"onRollOver");
         }
         this._componentsList[param2["btn_removeLogin" + _loc4_].name] = param1;
         if(param1)
         {
            param2["lbl_loginName" + _loc4_].text = param1;
            param2["btn_removeLogin" + _loc4_].visible = true;
            if(param3)
            {
               param2["btn_login" + _loc4_].selected = true;
            }
            else
            {
               param2["btn_login" + _loc4_].selected = false;
            }
         }
         else
         {
            param2["lbl_loginName" + _loc4_].text = "";
            param2["btn_removeLogin" + _loc4_].visible = false;
            param2["btn_login" + _loc4_].selected = false;
         }
      }
      
      private function login() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:* = false;
         this.soundApi.playSound(SoundTypeEnum.OK_BUTTON);
         if(this._currentMode == GAMEMODE_LOG_IN || !this._guestModeAvailable)
         {
            _loc1_ = this.cbx_login.input.text;
            _loc2_ = this.input_pass.text;
            if(_loc1_.length == 0 || _loc2_.length == 0)
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.wrongCredentials"),[this.uiApi.getText("ui.common.ok")],[]);
               this.disableUi(false);
            }
            else
            {
               if(this.sysApi.getConfigKey("boo") == "1" && this.sysApi.getBuildType() > BuildTypeEnum.BETA)
               {
                  this.sysApi.setData("LastPassword",_loc2_);
               }
               else
               {
                  this.sysApi.setData("LastPassword",null);
               }
               if(this.sysApi.isEventMode())
               {
                  _loc3_ = this.sysApi.getData("EventModeLogins");
                  if(!_loc3_ || _loc3_.length == 0)
                  {
                     _loc3_ = "$";
                     _loc4_ = 10 + Math.random() * 10;
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_)
                     {
                        _loc3_ = _loc3_ + String.fromCharCode(Math.floor(97 + Math.random() * 26));
                        _loc5_++;
                     }
                     this.sysApi.setData("EventModeLogins",_loc3_);
                  }
                  this.sysApi.sendAction(new LoginValidation(_loc3_,"pass",true));
               }
               else
               {
                  _loc6_ = this.cb_connectionType.selectedItem.type == 2;
                  if(_loc6_)
                  {
                     this.connectionApi.allowAutoConnectCharacter(true);
                  }
                  this.sysApi.sendAction(new LoginValidation(_loc1_,_loc2_,this.cb_connectionType.selectedItem.type != 0));
               }
            }
         }
         else
         {
            this.sysApi.sendAction(new LoginAsGuest());
         }
      }
      
      public function updateShopGift(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(param1)
         {
            if(!this._componentsList[param2.tx_bgArticle.name])
            {
               this.uiApi.addComponentHook(param2.tx_bgArticle,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.tx_bgArticle,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_bgArticle,ComponentHookList.ON_ROLL_OUT);
            }
            this._componentsList[param2.tx_bgArticle.name] = param1;
            if(param1.visualUri)
            {
               param2.tx_article.uri = this.uiApi.createUri(param1.visualUri);
            }
            param2.tx_bgArticle.handCursor = true;
            param2.tx_bgArticle.mouseEnabled = true;
            _loc4_ = param1.price;
            if(param1.priceCrossed)
            {
               _loc4_ = param1.priceCrossed.split(".")[0];
            }
            if(param1.priceCrossed && _loc4_ > param1.price)
            {
               param2.lbl_banner.text = param1.price;
               param2.tx_banner.gotoAndStop = 2;
               param2.lbl_price.text = _loc4_;
               param2.ctr_crossprice.visible = true;
               param2.tx_money.visible = true;
               param2.lbl_banner.x = 15;
            }
            else
            {
               if(param1.promotionTag)
               {
                  param2.lbl_banner.text = this.uiApi.getText("ui.shop.sales");
                  param2.tx_banner.gotoAndStop = 2;
               }
               else if(param1.newTag)
               {
                  param2.lbl_banner.text = this.uiApi.getText("ui.common.new");
                  param2.tx_banner.gotoAndStop = 1;
               }
               else
               {
                  param2.tx_banner.visible = false;
                  param2.lbl_banner.visible = false;
               }
               param2.lbl_price.text = param1.price;
            }
         }
         else
         {
            param2.ctr_article.visible = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         switch(param1)
         {
            case this.btn_oauth:
               this.switchUiMode(this._currentMode == GAMEMODE_LOG_IN_OAUTH?uint(GAMEMODE_LOG_IN):uint(GAMEMODE_LOG_IN_OAUTH));
               break;
            case this.btn_play:
               if(!this.btn_play.disabled)
               {
                  this.disableUi(true);
                  this.login();
               }
               break;
            case this.btn_rememberLogin:
               _loc2_ = !!this.btn_rememberLogin.selected?1:-1;
               Connection.loginMustBeSaved = _loc2_;
               this.sysApi.setData("saveLogin",_loc2_);
               break;
            case this.btn_passForgotten:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.cantlogin"));
               break;
            case this.btn_createAccount:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.createAccount"));
               break;
            case this.btn_options:
               if(this.ctr_options.visible)
               {
                  this.ctr_options.visible = false;
               }
               else
               {
                  this.ctr_options.visible = true;
               }
               break;
            case this.btn_members:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.members"));
               break;
            case this.btn_lowa:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.lowa"));
               break;
            case this.btn_guestTab:
               this.switchUiMode(GAMEMODE_PLAY_AS_GUEST);
               break;
            case this.btn_registeredTab:
               if(this._currentMode == GAMEMODE_PLAY_AS_GUEST)
               {
                  this.switchUiMode(GAMEMODE_LOG_IN);
               }
               break;
            case this.btn_webLoginClose:
               this.wb_webLogin.clearLocation();
               this.ctr_webLogin.visible = false;
               this.disableUi(false);
               break;
            case this.btn_login_ankama:
               this.switchUiMode(GAMEMODE_LOG_IN);
               break;
            case this.btn_login_facebook:
            case this.btn_login_twitter:
            case this.btn_login_google:
               _loc3_ = param1.name.replace("btn_login_","");
               if(_loc3_)
               {
                  this.disableUi(true);
                  this._ankamaAuthUrl = this.sysApi.goToWebAuthentification(this.wb_webLogin,_loc3_);
                  this._ankamaAuthBaseUrl = this._ankamaAuthUrl.substring(0,this._ankamaAuthUrl.indexOf(_loc3_)) + _loc3_;
               }
               break;
            case this.btn_login_steam:
               this.disableUi(true);
               if(this.cb_connectionType.selectedItem.type == 2)
               {
                  this.connectionApi.allowAutoConnectCharacter(true);
               }
               this.sysApi.sendAction(new LoginWithSteam());
               break;
            default:
               if(param1.name.indexOf("btn_removeLogin") != -1)
               {
                  _loc4_ = this._componentsList[param1.name];
                  _loc5_ = this.sysApi.getData("LastLogins");
                  _loc6_ = new Array();
                  for each(_loc7_ in _loc5_)
                  {
                     if(_loc7_ != _loc4_)
                     {
                        _loc6_.push(_loc7_);
                     }
                  }
                  this.sysApi.setData("LastLogins",_loc6_);
                  this.cbx_login.dataProvider = _loc6_;
                  this.cbx_login.selectedIndex = 0;
               }
               else if(param1.name.indexOf("tx_bgArticle") != -1)
               {
                  if(this._componentsList[param1.name].onCliqueUri)
                  {
                     this.sysApi.goToUrl(this._componentsList[param1.name].onCliqueUri);
                  }
                  else
                  {
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.loginAdsIGShop.title"),this.uiApi.getText("ui.popup.loginAdsIGShop.text"),[this.uiApi.getText("ui.common.ok")],[]);
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 6;
         var _loc4_:uint = 1;
         switch(param1)
         {
            case this.btn_oauth:
               _loc2_ = this.uiApi.getText("ui.connection.connectionTypeChoice");
               break;
            case this.btn_rememberLogin:
               _loc2_ = this.uiApi.getText("ui.connection.rememberLogin.info");
               break;
            default:
               if(param1.name.indexOf("btn_removeLogin") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.login.deleteLogin");
                  this.cbx_login.closeOnClick = false;
               }
               else if(param1.name.indexOf("tx_bgArticle") != -1)
               {
                  _loc3_ = 7;
                  _loc4_ = 1;
                  _loc2_ = this._componentsList[param1.name].name;
               }
         }
         if(_loc2_ && _loc2_.length > 1)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,0,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
         if(param1.name.indexOf("btn_removeLogin") != -1)
         {
            this.cbx_login.closeOnClick = true;
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.cb_socket:
               this.sysApi.setPort(this._aPorts[this.cb_socket.selectedIndex]);
               break;
            case this.cb_connectionType:
               this.configApi.setConfigProperty("dofus","autoConnectType",this.cb_connectionType.selectedItem.type);
               break;
            case this.cbx_login:
               if(param2 != GridItemSelectMethodEnum.AUTO)
               {
                  this.lbl_login.text = "";
               }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(!this.btn_play.disabled)
               {
                  this.disableUi(true);
                  this.login();
                  return true;
               }
               break;
         }
         return false;
      }
      
      private function onNicknameRegistration() : void
      {
         this.disableUi(true);
         this.uiApi.loadUi("pseudoChoice");
      }
      
      private function onUiUnloaded(param1:String) : void
      {
         if(param1.indexOf("popup") == 0 && this._previousFocus)
         {
            this._previousFocus.focus();
            this._previousFocus = null;
         }
      }
      
      private function onSubscribersList(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.ctr_gifts.visible = true;
         if(param1.length < 4)
         {
            _loc2_ = this.gd_shop.slotWidth * param1.length;
            this.gd_shop.x = this.gd_shop.x + (this.gd_shop.width - _loc2_) / 2;
         }
         this.gd_shop.dataProvider = param1;
      }
      
      public function onSelectedServerFailed() : void
      {
         this.disableUi(false);
      }
      
      public function onChange(param1:Object) : void
      {
         if(param1 == this.input_pass)
         {
            if(this.lbl_pass.text != "" && this.input_pass.text != "")
            {
               this.lbl_pass.text = "";
            }
            if(this.lbl_pass.text == "" && this.input_pass.text == "")
            {
               this.lbl_pass.text = this.uiApi.getText("ui.login.password");
            }
         }
         if(param1 == this.cbx_login.input)
         {
            if(this.lbl_login.text != "" && this.cbx_login.input.text != "")
            {
               this.lbl_login.text = "";
            }
            if(this.lbl_login.text == "" && this.cbx_login.input.text == "")
            {
               this.lbl_login.text = this.uiApi.getText("ui.login.username");
            }
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(param2 == 9)
         {
            if(this.cbx_login.input.haveFocus)
            {
               this.input_pass.focus();
               this.input_pass.setSelection(0,this.input_pass.text.length);
            }
            else if(this.input_pass.haveFocus)
            {
               this.cbx_login.input.focus();
               this.cbx_login.input.setSelection(0,this.cbx_login.input.text.length);
            }
         }
         else if(param2 == 20)
         {
            if(Keyboard.capsLock)
            {
               this.ctr_capsLockMsg.visible = true;
               this.lbl_capsLock.visible = true;
            }
            else
            {
               this.ctr_capsLockMsg.visible = false;
               this.lbl_capsLock.visible = false;
            }
         }
      }
      
      public function onBrowserDomReady(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = this.wb_webLogin.location;
         if(_loc2_ && this._ankamaAuthBaseUrl && _loc2_.length > this._ankamaAuthBaseUrl.length)
         {
            _loc3_ = _loc2_.substr(0,this._ankamaAuthBaseUrl.length);
            if(this._ankamaAuthBaseUrl == _loc3_)
            {
               this.sysApi.sendAction(new BrowserDomainReady(this.wb_webLogin));
               this.ctr_webLogin.visible = false;
               this.disableUi(true);
            }
            else if(!this.ctr_webLogin.visible && _loc2_ != this._ankamaAuthUrl)
            {
               this.ctr_webLogin.visible = true;
            }
         }
      }
      
      public function onBrowserSessionTimeout(param1:*) : void
      {
         this.sysApi.refreshUrl(this.wb_webLogin,this._domain);
      }
      
      private function switchUiMode(param1:uint) : void
      {
         clearTimeout(this._timeoutId);
         this._currentMode = param1;
         this.sysApi.setData("loginUiMode",param1);
         if(param1 == GAMEMODE_LOG_IN)
         {
            this.ctr_center.visible = true;
            this.ctr_links.visible = true;
            this.ctr_login.visible = true;
            this.ctr_pass.visible = true;
            this.ctr_guestMode.visible = false;
            this.ctr_oauthServices.visible = false;
            this.ctr_steam.visible = false;
            if(this._oauthLoginAvailable)
            {
               this.btn_oauth.visible = true;
            }
            this.cb_connectionType.disabled = false;
            this.btn_rememberLogin.disabled = false;
         }
         else if(param1 == GAMEMODE_LOG_IN_OAUTH)
         {
            this.ctr_center.visible = false;
            this.ctr_links.visible = false;
            this.ctr_guestMode.visible = false;
            this.ctr_oauthServices.visible = true;
            this.ctr_steam.visible = false;
            this.btn_oauth.visible = false;
            this.cb_connectionType.disabled = false;
            this.btn_rememberLogin.disabled = true;
         }
         else if(param1 == GAMEMODE_LOG_IN_STEAM)
         {
            this.ctr_center.visible = false;
            this.ctr_links.visible = false;
            this.ctr_guestMode.visible = false;
            this.ctr_oauthServices.visible = false;
            this.ctr_steam.visible = true;
            this.btn_login_steam.disabled = this._mustDisableConnectionButton;
            this.btn_options.disabled = this._mustDisableConnectionButton;
            this.cb_connectionType.disabled = false;
            this.btn_rememberLogin.disabled = true;
         }
         else if(param1 == GAMEMODE_PLAY_AS_GUEST)
         {
            this.ctr_center.visible = true;
            this.ctr_links.visible = false;
            this.ctr_login.visible = false;
            this.ctr_pass.visible = false;
            this.ctr_guestMode.visible = true;
            this.ctr_oauthServices.visible = false;
            this.ctr_steam.visible = false;
            if(!this.btn_guestTab.selected)
            {
               this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_guestTab,this.uiApi.me());
               this.btn_guestTab.selected = true;
               this.onRelease(this.btn_guestTab);
            }
            if(this._oauthLoginAvailable)
            {
               this.btn_oauth.visible = false;
            }
            this.cb_connectionType.disabled = true;
            this.btn_rememberLogin.disabled = true;
         }
      }
   }
}
