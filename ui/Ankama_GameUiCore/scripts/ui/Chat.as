package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.MapViewer;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBase;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.internalDatacenter.appearance.OrnamentWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.internalDatacenter.dare.DareWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HavenbagFurnitureWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.IdolsPresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.PresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ShortcutWrapper;
   import com.ankamagames.dofus.internalDatacenter.userInterface.ButtonWrapper;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ChannelEnabling;
   import d2actions.ChatCommand;
   import d2actions.ChatLoaded;
   import d2actions.ChatTextOutput;
   import d2actions.OpenSmileys;
   import d2actions.PlayerStatusUpdateRequest;
   import d2actions.SaveMessage;
   import d2actions.TabsUpdate;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.DataStoreEnum;
   import d2enums.EventEnums;
   import d2enums.PlayerStatusEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.AddItemHyperlink;
   import d2hooks.ChannelEnablingChange;
   import d2hooks.ChatFocus;
   import d2hooks.ChatHyperlink;
   import d2hooks.ChatLinkRelease;
   import d2hooks.ChatRollOverLink;
   import d2hooks.ChatSendPreInit;
   import d2hooks.ChatServer;
   import d2hooks.ChatServerCopy;
   import d2hooks.ChatServerCopyWithObject;
   import d2hooks.ChatServerWithObject;
   import d2hooks.ChatSmiley;
   import d2hooks.ChatSpeakingItem;
   import d2hooks.ChatWarning;
   import d2hooks.ClearChat;
   import d2hooks.EmoteEnabledListUpdated;
   import d2hooks.EnabledChannels;
   import d2hooks.FocusChange;
   import d2hooks.GameFightJoin;
   import d2hooks.GameFightLeave;
   import d2hooks.InactivityNotification;
   import d2hooks.InsertHyperlink;
   import d2hooks.InsertRecipeHyperlink;
   import d2hooks.LivingObjectMessage;
   import d2hooks.MouseShiftClick;
   import d2hooks.NewAwayMessage;
   import d2hooks.NewMessage;
   import d2hooks.OpenStatusMenu;
   import d2hooks.PlayerStatusUpdate;
   import d2hooks.PopupWarning;
   import d2hooks.ShowSmilies;
   import d2hooks.TextActionInformation;
   import d2hooks.TextInformation;
   import d2hooks.ToggleChatLog;
   import d2hooks.UpdateChatOptions;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import flash.text.AntiAliasType;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class Chat
   {
      
      private static var _shortcutColor:String;
      
      private static const SMALL_SIZE:uint = 14;
      
      private static const SMALL_SIZE_LINE_HEIGHT:uint = SMALL_SIZE + 1;
      
      private static const MEDIUM_SIZE:uint = 16;
      
      private static const MEDIUM_SIZE_LINE_HEIGHT:uint = MEDIUM_SIZE + 2;
      
      private static const LARGE_SIZE:uint = 18;
      
      private static const LARGE_SIZE_LINE_HEIGHT:uint = LARGE_SIZE + 3;
      
      private static const ITEM_INDEX_CODE:String = String.fromCharCode(65532);
      
      private static const SPLIT_CODE:String = String.fromCharCode(65533);
      
      private static const MAX_CHAT_ITEMS:int = 16;
      
      private static const LINK_CONTENT_REGEXP:RegExp = /<a.*?>\s*(.*?)\s*<\/a>/g;
      
      private static var _currentStatus:int = PlayerStatusEnum.PLAYER_STATUS_AVAILABLE;
       
      
      public var output:Object;
      
      public var bindsApi:BindsApi;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var timeApi:TimeApi;
      
      public var dataApi:DataApi;
      
      public var chatApi:ChatApi;
      
      public var configApi:ConfigApi;
      
      public var tooltipApi:TooltipApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var soundApi:SoundApi;
      
      private var _aChannels:Array;
      
      private var _aTabs:Object;
      
      private var _aTabsPicto:Array;
      
      private var _aMiscReplacement:Array;
      
      private var _aItemReplacement:Array;
      
      private var _dItemIndex:Dictionary;
      
      private var _dGenericItemIndex:Dictionary;
      
      private var _aCheckColors:Array;
      
      private var _aChecks:Array;
      
      private var _aCheckChans:Array;
      
      private var _aTabsViewStamp:Array;
      
      private var _maxCmdHistoryIndex:uint = 100;
      
      private var _aHistory:Array;
      
      private var _nHistoryIndex:int = 0;
      
      private var _privateHistory:PrivateHistory;
      
      private var _nCurrentTab:uint = 0;
      
      private var _tabsCache:Dictionary;
      
      private var _tmpLabel:Object;
      
      private var _refreshingChat:Boolean;
      
      private var _sFrom:String;
      
      private var _sTo:String;
      
      private var _sChan:String = "/s";
      
      private var _sChanLocked:String = "/s";
      
      private var _sChanLockedBeforeSpec:String = "/s";
      
      private var _sLastChan:String;
      
      private var _sDest:String;
      
      private var _sText:String;
      
      private var _sCssClass:String = "p0";
      
      private var _focusTimer:Timer;
      
      private var tx_backgroundMinHeight:int;
      
      private var _nOffsetYResize:int = 300;
      
      private var _nOffsetYSmallResize:int = 100;
      
      private var _bNormalSize:uint = 0;
      
      private var _smileyOpened:Boolean = false;
      
      private var _emoteOpened:Boolean = false;
      
      private var _bCurrentChannelSelected:Boolean = false;
      
      private var _bChanCheckChange:Boolean = false;
      
      private var _aTxHighlights:Array;
      
      private var _aBtnTabs:Array;
      
      private var _nFontSize:uint;
      
      private var _timerLowQuality:Timer;
      
      private var _iconsPath:String;
      
      private var _autocompletionCount:int = 0;
      
      private var _autocompletionLastCompletion:String = null;
      
      private var _autocompletionSubString:String = null;
      
      private var _delaySendChat:Boolean = false;
      
      private var _delayWaitingMessage:Boolean = false;
      
      private var _delaySendChatTimer:Timer;
      
      private var _lastText:String = null;
      
      private var _numMessages:int;
      
      private var _isStreaming:Boolean;
      
      private var _init:Boolean;
      
      private var _mainDone:Boolean = false;
      
      private var _chatLog:Boolean = false;
      
      private var _splittedContent:String = "";
      
      private var _tabIconsPath:String;
      
      public var _awayMessage:String = "";
      
      public var _idle:Boolean = false;
      
      private var _currentMainCtrHeight:Number;
      
      public var realTchatCtr:GraphicContainer;
      
      public var tabs_ctr:GraphicContainer;
      
      public var checks_ctr:GraphicContainer;
      
      public var tx_background:GraphicContainer;
      
      public var mainCtr:GraphicContainer;
      
      public var inp_tchatinput:Input;
      
      public var texta_tchat:ChatComponentHandler;
      
      public var ta_chat:TextArea;
      
      public var lbl_btn_menu:Object;
      
      public var btn_lbl_btn_ime:Label;
      
      public var btn_menu:ButtonContainer;
      
      public var btn_ime:ButtonContainer;
      
      public var btn_plus:ButtonContainer;
      
      public var btn_minus:ButtonContainer;
      
      public var btn_smiley:ButtonContainer;
      
      public var btn_tab0:ButtonContainer;
      
      public var btn_tab1:ButtonContainer;
      
      public var btn_tab2:ButtonContainer;
      
      public var btn_tab3:ButtonContainer;
      
      public var tx_tab0:Texture;
      
      public var tx_tab1:Texture;
      
      public var tx_tab2:Texture;
      
      public var tx_tab3:Texture;
      
      public var tx_arrow_btn_menu:Texture;
      
      public var tx_checkColor0:Texture;
      
      public var tx_checkColor1:Texture;
      
      public var tx_checkColor2:Texture;
      
      public var tx_checkColor3:Texture;
      
      public var tx_checkColor4:Texture;
      
      public var tx_checkColor5:Texture;
      
      public var tx_checkColor6:Texture;
      
      public var tx_checkColor7:Texture;
      
      public var iconTexturebtn_status:TextureBitmap;
      
      public var btn_check0:ButtonContainer;
      
      public var btn_check1:ButtonContainer;
      
      public var btn_check2:ButtonContainer;
      
      public var btn_check3:ButtonContainer;
      
      public var btn_check4:ButtonContainer;
      
      public var btn_check5:ButtonContainer;
      
      public var btn_check6:ButtonContainer;
      
      public var btn_check7:ButtonContainer;
      
      public var btn_status:ButtonContainer;
      
      public var tx_separator:TextureBitmap;
      
      private var _needAnotherRender:Boolean = false;
      
      private var _ignoreNextRenderUpdates:uint = 0;
      
      private var updateChatOptionsAgain:Boolean = false;
      
      public function Chat()
      {
         this._aMiscReplacement = new Array();
         this._aItemReplacement = new Array();
         this._dItemIndex = new Dictionary();
         this._dGenericItemIndex = new Dictionary();
         this._tabsCache = new Dictionary();
         this._focusTimer = new Timer(1,1);
         this._timerLowQuality = new Timer(100,1);
         super();
      }
      
      public function main(param1:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:uint = 0;
         this.btn_plus.soundId = SoundEnum.WINDOW_OPEN;
         this.btn_minus.soundId = SoundEnum.WINDOW_OPEN;
         this.btn_menu.soundId = SoundEnum.WINDOW_OPEN;
         this.btn_smiley.soundId = SoundEnum.WINDOW_OPEN;
         this.sysApi.createHook("InsertHyperlink");
         this.sysApi.addHook(ChatServer,this.onChatServer);
         this.sysApi.addHook(NewMessage,this.onNewMessage);
         this.sysApi.addHook(ChatSendPreInit,this.onChatSendPreInit);
         this.sysApi.addHook(ChatServerWithObject,this.onChatServerWithObject);
         this.sysApi.addHook(ChatServerCopy,this.onChatServerCopy);
         this.sysApi.addHook(ChatServerCopyWithObject,this.onChatServerCopyWithObject);
         this.sysApi.addHook(ChatSpeakingItem,this.onChatSpeakingItem);
         this.sysApi.addHook(TextActionInformation,this.onTextActionInformation);
         this.sysApi.addHook(TextInformation,this.onTextInformation);
         this.sysApi.addHook(ChannelEnablingChange,this.onChannelEnablingChange);
         this.sysApi.addHook(EnabledChannels,this.onEnabledChannels);
         this.sysApi.addHook(UpdateChatOptions,this.onUpdateChatOptions);
         this.sysApi.addHook(ChatSmiley,this.onChatSmiley);
         this.sysApi.addHook(ChatFocus,this.onChatFocus);
         this.sysApi.addHook(MouseShiftClick,this.onMouseShiftClick);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this.sysApi.addHook(InsertHyperlink,this.onInsertHyperlink);
         this.sysApi.addHook(InsertRecipeHyperlink,this.onInsertRecipeHyperlink);
         this.sysApi.addHook(ChatHyperlink,this.onChatHyperlink);
         this.sysApi.addHook(AddItemHyperlink,this.onInsertHyperlink);
         this.sysApi.addHook(LivingObjectMessage,this.onLivingObjectMessage);
         this.sysApi.addHook(ChatWarning,this.onChatWarning);
         this.sysApi.addHook(PopupWarning,this.onPopupWarning);
         this.sysApi.addHook(ChatLinkRelease,this.onChatLinkRelease);
         this.sysApi.addHook(EmoteEnabledListUpdated,this.onEmoteEnabledListUpdated);
         this.sysApi.addHook(GameFightLeave,this.onGameFightLeave);
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(ToggleChatLog,this.onToggleChatLog);
         this.sysApi.addHook(d2hooks.ClearChat,this.onClearChat);
         this.sysApi.addHook(ChatRollOverLink,this.onChatRollOverLink);
         this.sysApi.addHook(ShowSmilies,this.onActivateSmilies);
         this.sysApi.addHook(PlayerStatusUpdate,this.onPlayerStatusUpdate);
         this.sysApi.addHook(InactivityNotification,this.onInactivityNotification);
         this.sysApi.addHook(NewAwayMessage,this.onNewAwayMessage);
         this.uiApi.addComponentHook(this.btn_tab0,EventEnums.EVENT_ONROLLOVER);
         this.uiApi.addComponentHook(this.btn_tab0,EventEnums.EVENT_ONROLLOUT);
         this.uiApi.addComponentHook(this.btn_tab0,EventEnums.EVENT_ONRIGHTCLICK);
         this.uiApi.addComponentHook(this.btn_tab1,EventEnums.EVENT_ONROLLOVER);
         this.uiApi.addComponentHook(this.btn_tab1,EventEnums.EVENT_ONROLLOUT);
         this.uiApi.addComponentHook(this.btn_tab1,EventEnums.EVENT_ONRIGHTCLICK);
         this.uiApi.addComponentHook(this.btn_tab2,EventEnums.EVENT_ONROLLOVER);
         this.uiApi.addComponentHook(this.btn_tab2,EventEnums.EVENT_ONROLLOUT);
         this.uiApi.addComponentHook(this.btn_tab2,EventEnums.EVENT_ONRIGHTCLICK);
         this.uiApi.addComponentHook(this.btn_tab3,EventEnums.EVENT_ONROLLOVER);
         this.uiApi.addComponentHook(this.btn_tab3,EventEnums.EVENT_ONROLLOUT);
         this.uiApi.addComponentHook(this.btn_tab3,EventEnums.EVENT_ONRIGHTCLICK);
         this.uiApi.addComponentHook(this.btn_status,EventEnums.EVENT_ONROLLOVER);
         this.uiApi.addComponentHook(this.btn_status,EventEnums.EVENT_ONROLLOUT);
         this.uiApi.addComponentHook(this.btn_status,EventEnums.EVENT_ONRELEASE);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.HISTORY_UP,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.HISTORY_DOWN,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHIFT_UP,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHIFT_DOWN,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHIFT_VALID,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.ALT_VALID,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CTRL_VALID,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.EXTEND_CHAT,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.EXTEND_CHAT2,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SHRINK_CHAT,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_EMOTES,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_ATTITUDES,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CHAT_TAB_0,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CHAT_TAB_1,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CHAT_TAB_2,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CHAT_TAB_3,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.NEXT_CHAT_TAB,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.PREVIOUS_CHAT_TAB,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CHAT_AUTOCOMPLETE,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_GLOBAL,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_TEAM,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_GUILD,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_ALLIANCE,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_PARTY,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_ARENA,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_SALES,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_SEEK,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.TOGGLE_CHANNEL_FIGHT,this.onShortcut,true);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.SWITCH_TEXT_SIZE,this.onShortcut,true);
         this.uiApi.addShortcutHook("focusChat",this.onShortcut);
         if(this.sysApi.getCurrentLanguage() == "ja")
         {
            this.inp_tchatinput.useEmbedFonts = false;
         }
         this.inp_tchatinput.textfield.addEventListener(Event.CHANGE,this.onChatChange);
         this._focusTimer.addEventListener(TimerEvent.TIMER,this.onFocusTimer);
         this._aCheckChans = new Array([0],[9,1,4,13],[10,11],[2],[3],[5],[6],[12]);
         this._aCheckColors = new Array(this.tx_checkColor0,this.tx_checkColor1,this.tx_checkColor2,this.tx_checkColor3,this.tx_checkColor4,this.tx_checkColor5,this.tx_checkColor6,this.tx_checkColor7);
         this._aChecks = new Array(this.btn_check0,this.btn_check1,this.btn_check2,this.btn_check3,this.btn_check4,this.btn_check5,this.btn_check6,this.btn_check7);
         if(this.uiApi.useIME())
         {
            this.btn_ime.visible = true;
            this.uiApi.addComponentHook(this.btn_ime,EventEnums.EVENT_ONRELEASE);
            this.setImeMode(null);
         }
         else
         {
            this.btn_ime.visible = false;
         }
         var _loc2_:* = this.uiApi.me();
         this._tabIconsPath = _loc2_.getConstant("tab_uri");
         this.texta_tchat = new ChatComponentHandler(ChatComponentHandler.CHAT_NORMAL,this.realTchatCtr,this.ta_chat);
         this._tmpLabel = this.uiApi.createComponent("Label");
         this._tmpLabel.useEmbedFonts = false;
         this._tmpLabel.hyperlinkEnabled = true;
         this._tmpLabel.antialias = AntiAliasType.ADVANCED;
         this._tmpLabel.css = this.uiApi.createUri("theme://css/chat.css");
         this._tmpLabel.cssClass = "p";
         this._sFrom = this.uiApi.getText("ui.chat.from");
         this._sTo = this.uiApi.getText("ui.chat.to");
         this._aHistory = this.sysApi.getData("aTchatHistory");
         if(this._aHistory == null)
         {
            this._aHistory = new Array();
         }
         this._nHistoryIndex = this._aHistory.length;
         this._privateHistory = new PrivateHistory(this._maxCmdHistoryIndex);
         this.inp_tchatinput.html = false;
         this.inp_tchatinput.maxChars = 256;
         this.inp_tchatinput.antialias = AntiAliasType.ADVANCED;
         this.inp_tchatinput.textfield.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this._aTxHighlights = [this.tx_tab0,this.tx_tab1,this.tx_tab2,this.tx_tab3];
         this._aBtnTabs = [this.btn_tab0,this.btn_tab1,this.btn_tab2,this.btn_tab3];
         var _loc3_:Object = this.chatApi.getChannelsId();
         this._aChannels = new Array();
         for each(_loc4_ in _loc3_)
         {
            this._aChannels.push(_loc4_);
         }
         this.setTabsChannels();
         this._aTabsPicto = new Array();
         _loc5_ = 0;
         _loc6_ = false;
         _loc7_ = this.sysApi.getOption("tabsNames","chat");
         for each(_loc8_ in _loc7_)
         {
            if(!Number(_loc8_))
            {
               _loc8_ = _loc5_;
               _loc6_ = true;
            }
            this._aTabsPicto.push(_loc8_);
            _loc2_.getElement("iconTexture" + this._aBtnTabs[_loc5_].name).uri = this.uiApi.createUri(this._tabIconsPath + _loc8_ + ".png");
            this["tx_tab" + _loc5_].uri = this.uiApi.createUri(this._tabIconsPath + "hl_" + _loc8_ + ".png");
            _loc5_++;
         }
         if(_loc6_)
         {
            this.sysApi.sendAction(new TabsUpdate(null,this._aTabsPicto));
         }
         this.uiApi.setRadioGroupSelectedItem("tabChatGroup",this.btn_tab0,this.uiApi.me());
         this._init = true;
         this.init();
         this.onUpdateChatOptions();
         this.updateChatOptionsAgain = true;
         this.sysApi.sendAction(new ChatLoaded());
         for each(_loc9_ in this._aChannels)
         {
            if(_loc9_ != ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG)
            {
               this.texta_tchat.setCssColor("#" + this.sysApi.getOption("channelColor" + _loc9_,"chat").toString(16),"p" + _loc9_);
            }
         }
         if(param1)
         {
            this.onEnabledChannels(param1[0]);
            if(param1[1] && param1[1].length != 0)
            {
               for each(_loc10_ in param1[1])
               {
                  this.onTextInformation(_loc10_.content,_loc10_.channel,_loc10_.timestamp,_loc10_.saveMsg);
               }
            }
         }
         this._nFontSize = this.configApi.getConfigProperty("chat","chatFontSize");
         if(this._nFontSize && (this._nFontSize == SMALL_SIZE || this._nFontSize == MEDIUM_SIZE || this._nFontSize == LARGE_SIZE))
         {
            switch(this._nFontSize)
            {
               case SMALL_SIZE:
                  _loc11_ = SMALL_SIZE_LINE_HEIGHT;
                  break;
               case MEDIUM_SIZE:
                  _loc11_ = MEDIUM_SIZE_LINE_HEIGHT;
                  break;
               case LARGE_SIZE:
                  _loc11_ = LARGE_SIZE_LINE_HEIGHT;
            }
            this.textResize(this._nFontSize,_loc11_);
         }
         else
         {
            this.configApi.setConfigProperty("chat","chatFontSize",MEDIUM_SIZE);
         }
         this._delaySendChat = false;
         this._delayWaitingMessage = false;
         this._delaySendChatTimer = new Timer(500,1);
         this._delaySendChatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelaySendChatTimer);
         this.texta_tchat.initSmileyTab(_loc2_.getConstant("smilies_uri"),this.dataApi.getAllSmiley());
         this._iconsPath = _loc2_.getConstant("icons_uri");
         this.chatApi.setExternalChatChannels(this._aTabs[this._nCurrentTab]);
         this._isStreaming = this.sysApi.isStreaming();
         this._init = false;
         this._currentMainCtrHeight = this.sysApi.getSetData("currentMainCtrHeight",this.mainCtr.height,DataStoreEnum.BIND_COMPUTER);
         this.mainCtr.height = this._currentMainCtrHeight;
         this.mainCtr.setSavedDimension(this.mainCtr.width,this._currentMainCtrHeight);
         this._needAnotherRender = true;
         this._mainDone = true;
      }
      
      public function unload() : void
      {
         if(this._delaySendChatTimer)
         {
            this._delaySendChatTimer.stop();
            this._delaySendChatTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelaySendChatTimer);
         }
         if(this._focusTimer)
         {
            this._focusTimer.removeEventListener(TimerEvent.TIMER,this.onFocusTimer);
         }
         if(this.inp_tchatinput && this.inp_tchatinput.textfield)
         {
            this.inp_tchatinput.textfield.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         }
      }
      
      public function renderUpdate() : void
      {
         if(!this._mainDone)
         {
            return;
         }
         if(this._ignoreNextRenderUpdates)
         {
            this._ignoreNextRenderUpdates--;
            return;
         }
         if(this._currentMainCtrHeight != this.mainCtr.height)
         {
            this._bNormalSize = 0;
            this._currentMainCtrHeight = this.mainCtr.height;
            this.sysApi.setData("currentMainCtrHeight",this._currentMainCtrHeight,DataStoreEnum.BIND_COMPUTER);
         }
         if(this._needAnotherRender)
         {
            this._needAnotherRender = false;
            this.uiApi.me().render();
         }
      }
      
      public function resize(param1:int = 1) : void
      {
         if(param1 == -1 && this._bNormalSize == 0)
         {
            this.resizeToPos(2);
         }
         else
         {
            this.resizeToPos((this._bNormalSize + param1) % 3);
         }
      }
      
      public function resizeToPos(param1:int = -1) : void
      {
         if(param1 < 0)
         {
            param1 = (this._bNormalSize + 1) % 3;
         }
         this.tx_backgroundMinHeight = this._currentMainCtrHeight;
         var _loc2_:* = this.uiApi.getVisibleStageBounds();
         if(param1 == 1)
         {
            if(this.tx_backgroundMinHeight + this._nOffsetYSmallResize >= _loc2_.height)
            {
               return;
            }
            this.mainCtr.height = this.tx_backgroundMinHeight + this._nOffsetYSmallResize;
            this._bNormalSize = 1;
            this.btn_plus.selected = false;
         }
         else if(param1 == 2)
         {
            if(this.tx_backgroundMinHeight + this._nOffsetYSmallResize + this._nOffsetYResize >= _loc2_.height)
            {
               return;
            }
            this.mainCtr.height = this.tx_backgroundMinHeight + this._nOffsetYSmallResize + this._nOffsetYResize;
            this._bNormalSize = 2;
            this.btn_plus.selected = true;
         }
         else
         {
            this.mainCtr.height = this.tx_backgroundMinHeight;
            this._bNormalSize = 0;
            this.btn_plus.selected = false;
         }
         this._ignoreNextRenderUpdates = 2;
         this.mainCtr.setSavedDimension(this.mainCtr.width,this.mainCtr.height);
         var _loc3_:* = this.uiApi.me();
         _loc3_.render();
         _loc3_.render();
         this.texta_tchat.scrollV = this.texta_tchat.maxScrollV;
      }
      
      public function sendMessage(param1:String) : void
      {
         this.inp_tchatinput.text = param1;
         this.chanSearch(param1);
         this.inp_tchatinput.focus();
         this.validUiShortcut();
      }
      
      private function getChannelTabs(param1:uint) : Vector.<uint>
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<uint> = new Vector.<uint>(0);
         if(param1 == this.chatApi.getRedChannelId())
         {
            for(_loc3_ in this._aTabs)
            {
               _loc2_.push(_loc3_);
            }
         }
         else
         {
            for(_loc3_ in this._aTabs)
            {
               for each(_loc4_ in this._aTabs[_loc3_])
               {
                  if(_loc4_ == param1)
                  {
                     _loc2_.push(_loc3_);
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function setTabsChannels() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         this._aTabs = new Array();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = this.sysApi.getOption("channelTabs","chat")[_loc1_];
            _loc3_ = new Array();
            if(_loc2_)
            {
               for each(_loc4_ in _loc2_)
               {
                  if(this.chatApi.getDisallowedChannelsId() && this.chatApi.getDisallowedChannelsId().indexOf(_loc4_) == -1)
                  {
                     _loc3_.push(_loc4_);
                  }
               }
            }
            this._aTabs.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function textOutput() : void
      {
         var _loc1_:* = "";
         if(this._sDest.length > 0)
         {
            _loc1_ = this._sDest + " ";
         }
         var _loc2_:String = this._sChan + " " + _loc1_ + this._sText;
         this.addToHistory(_loc2_);
         if(this._sDest.length > 0)
         {
            this._privateHistory.addName(this._sDest);
         }
      }
      
      private function addToHistory(param1:String) : void
      {
         param1 = this.trim(param1);
         var _loc2_:uint = this._aHistory.length;
         if(!_loc2_ || param1 != this._aHistory[_loc2_ - 1])
         {
            this._aHistory.push(param1);
            if(_loc2_ + 1 > this._maxCmdHistoryIndex)
            {
               this._aHistory = this._aHistory.slice(_loc2_ + 10 - this._maxCmdHistoryIndex,_loc2_ + 1);
            }
            this._nHistoryIndex = this._aHistory.length - 1;
            this.sysApi.setData("_nHistoryIndex ",this._nHistoryIndex);
            this.sysApi.setData("aTchatHistory",this._aHistory);
         }
         this._nHistoryIndex++;
      }
      
      private function chanSearch(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1.toLocaleLowerCase().indexOf(this._sChan) != 0)
         {
            if(param1.charAt(0) == "/")
            {
               _loc2_ = param1.toLocaleLowerCase().substring(0,param1.indexOf(" "));
            }
            else
            {
               _loc2_ = this._sChanLocked;
            }
            if(this.sysApi.getOption("channelLocked","chat"))
            {
               this.changeDefaultChannel(_loc2_);
            }
            else
            {
               this.changeCurrentChannel(_loc2_);
            }
         }
      }
      
      private function init() : void
      {
         this._sDest = "";
         this._sText = "";
         this.changeCurrentChannel(this._sChanLocked);
      }
      
      private function appendFakeLine(param1:String, param2:String, param3:Number = 0) : Object
      {
         return this.texta_tchat.appendText(this.addTimeToText(param1,param3),param2,false);
      }
      
      private function appendLine(param1:String, param2:String, param3:Number = 0, param4:Boolean = true, param5:int = 0) : Object
      {
         var _loc9_:int = 0;
         var _loc6_:Boolean = this.texta_tchat.scrollNeeded();
         var _loc7_:int = this.texta_tchat.scrollV;
         var _loc8_:Object = this.texta_tchat.appendText(this.addTimeToText(param1,param3),param2,true);
         if(param4 && _loc6_)
         {
            this.texta_tchat.scrollV = this.texta_tchat.maxScrollV;
         }
         if(this.texta_tchat.maxScrollV > this.chatApi.getMaxMessagesStored())
         {
            _loc9_ = this.texta_tchat.maxScrollV - this.chatApi.getMaxMessagesStored();
            this.texta_tchat.removeLines(_loc9_);
         }
         return _loc8_;
      }
      
      private function appendLineToTabCache(param1:uint, param2:String, param3:Number, param4:String) : void
      {
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         if(!this._tabsCache[param1])
         {
            this._tabsCache[param1] = new TabCache();
         }
         var _loc5_:TabCache = this._tabsCache[param1];
         this._tmpLabel.text = "";
         this._tmpLabel.appendText(this.addTimeToText(param2,param3),param4);
         _loc5_.text = _loc5_.text + this._tmpLabel.htmlText;
         _loc5_.numLines = _loc5_.numLines + this._tmpLabel.maxScrollV;
         var _loc6_:int = _loc5_.numLines - this.chatApi.getMaxMessagesStored();
         if(_loc6_ > 0)
         {
            _loc8_ = _loc5_.text;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc9_ = _loc8_.indexOf("</TEXTFORMAT>") + 13;
               _loc8_ = _loc8_.substr(_loc9_);
               _loc7_++;
            }
            _loc5_.text = _loc8_;
            _loc5_.numLines = _loc5_.numLines - _loc6_;
         }
      }
      
      private function addTimeToText(param1:String, param2:Number) : String
      {
         if(this.sysApi.getOption("showTime","chat"))
         {
            param1 = "[" + this.timeApi.getClock(param2,true) + "] " + param1;
         }
         return param1;
      }
      
      private function textResize(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         var _loc5_:TabCache = null;
         var _loc6_:String = null;
         var _loc7_:RegExp = null;
         this.texta_tchat.setCssSize(param1,param2);
         this._tmpLabel.setCssSize(param1);
         if(this._nFontSize != param1)
         {
            _loc3_ = this._nFontSize;
            this._nFontSize = param1;
            this.configApi.setConfigProperty("chat","chatFontSize",param1);
            if(this.sysApi.getOption("chatExpertMode","chat"))
            {
               _loc7_ = new RegExp("SIZE=\"" + _loc3_ + "\"","g");
               for(_loc4_ in this._aTabs)
               {
                  _loc5_ = this._tabsCache[_loc4_];
                  if(_loc5_)
                  {
                     _loc6_ = _loc5_.text;
                     _loc5_.text = _loc6_.replace(_loc7_,"SIZE=\"" + param1 + "\"");
                  }
               }
            }
         }
         this.refreshChat(false);
      }
      
      private function formatLine(param1:uint = 0, param2:String = "", param3:Number = 0, param4:String = "", param5:Number = 0, param6:String = "", param7:Object = null, param8:String = "", param9:Number = 0, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false) : void
      {
         var _loc15_:* = null;
         var _loc16_:String = null;
         var _loc17_:uint = 0;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:ItemWrapper = null;
         var _loc22_:int = 0;
         var _loc23_:* = undefined;
         var _loc24_:* = null;
         var _loc25_:String = null;
         var _loc26_:Object = null;
         var _loc27_:Vector.<uint> = null;
         var _loc28_:uint = 0;
         var _loc29_:TabCache = null;
         var _loc30_:Object = null;
         var _loc31_:Object = null;
         var _loc32_:String = null;
         var _loc13_:String = param6;
         if(param2 && param2.length > 1)
         {
            param2 = this.chatApi.unEscapeChatString(param2);
         }
         if(param2.indexOf(SPLIT_CODE) != -1)
         {
            if(param2.length > 1)
            {
               this._splittedContent = this._splittedContent + param2.substr(0,param2.length - 1);
               return;
            }
            param2 = this._splittedContent;
            this._splittedContent = "";
         }
         else
         {
            this._splittedContent = "";
         }
         if(param7)
         {
            _loc19_ = param7.length;
            _loc20_ = 0;
            while(_loc20_ < _loc19_)
            {
               _loc21_ = param7[_loc20_];
               _loc22_ = param2.indexOf(ITEM_INDEX_CODE);
               if(_loc22_ == -1)
               {
                  break;
               }
               param2 = param2.substr(0,_loc22_) + this.chatApi.newChatItem(_loc21_) + param2.substr(_loc22_ + 1);
               _loc20_++;
            }
         }
         var _loc14_:Boolean = false;
         if(param1 == this.chatApi.getRedChannelId() || param12)
         {
            _loc14_ = true;
         }
         else
         {
            for each(_loc23_ in this._aTabs[this._nCurrentTab])
            {
               if(param1 == _loc23_)
               {
                  _loc14_ = true;
               }
            }
         }
         _loc15_ = "";
         _loc17_ = param1;
         _loc18_ = "p" + param1;
         if(param8 == "")
         {
            if(param6 == "")
            {
               _loc24_ = "";
               if(param1 == ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO)
               {
                  _loc24_ = "(" + this.uiApi.getText("ui.chat.channel.information") + ") ";
               }
               else if(param1 == ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG)
               {
                  _loc24_ = "(" + this.uiApi.getText("ui.common.fight") + ") ";
                  param1 = ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO;
               }
               if(param1 == this.chatApi.getRedChannelId())
               {
                  _loc24_ = "(" + this.uiApi.getText("ui.chat.channel.important") + ") ";
                  _loc18_ = "p";
               }
               else
               {
                  _loc18_ = "p" + param1;
               }
               if(this.sysApi.getOption("showInfoPrefix","chat"))
               {
                  _loc15_ = _loc24_ + param2;
               }
               else
               {
                  _loc15_ = param2;
               }
            }
            else
            {
               if(!param10 && param5 != 0)
               {
                  param6 = "{player," + escape(param6) + "," + param5 + "," + param3 + "," + param4 + "," + param1 + "::<b>" + param6 + "</b>}";
               }
               if(!this.dataApi.getChatChannel(param1).isPrivate && param1 != ChatActivableChannelsEnum.CHANNEL_GLOBAL)
               {
                  _loc25_ = !!param11?"p":"p" + param1;
                  if(!this.sysApi.getOption("showShortcut","chat"))
                  {
                     _loc15_ = "(" + this.dataApi.getChatChannel(param1).name + ") " + param6 + this.uiApi.getText("ui.common.colon") + param2;
                     _loc18_ = _loc25_;
                  }
                  else
                  {
                     _loc15_ = "(" + this.dataApi.getChatChannel(param1).shortcut + ") " + param6 + this.uiApi.getText("ui.common.colon") + param2;
                     _loc18_ = _loc25_;
                  }
               }
               else if(param1 == ChatActivableChannelsEnum.CHANNEL_GLOBAL)
               {
                  if(param2.substr(0,4).toLowerCase() == "/me")
                  {
                     param2 = param2.substr(3);
                     _loc15_ = param6 + this.uiApi.getText("ui.common.colon") + " <i>" + param2 + "</i>";
                     _loc18_ = "p" + param1;
                  }
                  else if(param2.substr(0,6).toLowerCase() == "/think")
                  {
                     param2 = param2.substr(7);
                     _loc15_ = param6 + " " + this.uiApi.getText("ui.chat.think") + this.uiApi.getText("ui.common.colon") + "<i>" + param2 + "</i>";
                     _loc18_ = "p" + param1;
                  }
                  else if(param2.length > 1 && param2.charAt(0) == "*" && param2.charAt(param2.length - 1) == "*")
                  {
                     param2 = param2.substr(1,param2.length - 2);
                     _loc15_ = "<i>" + param6 + " " + param2 + "</i>";
                     _loc18_ = "p" + param1;
                  }
                  else if(param2.substr(0,3).toLowerCase() == "/me")
                  {
                     param2 = param2.substr(4);
                     _loc15_ = "<i>" + param6 + " " + param2 + "</i>";
                     _loc18_ = "p" + param1;
                  }
                  else
                  {
                     _loc15_ = param6 + this.uiApi.getText("ui.common.colon") + param2;
                     _loc18_ = "p" + param1;
                  }
               }
               else if(param6 != "")
               {
                  if(!param10)
                  {
                     this._privateHistory.addName(_loc13_);
                  }
                  _loc15_ = this._sFrom + " " + param6 + this.uiApi.getText("ui.common.colon") + param2;
               }
            }
         }
         else
         {
            _loc15_ = this._sTo + " {player," + param8 + "," + param9 + "::<b>" + param8 + "</b>}" + this.uiApi.getText("ui.common.colon") + param2;
         }
         if(_loc15_ != "")
         {
            if(!this._tabsCache[this._nCurrentTab])
            {
               this._tabsCache[this._nCurrentTab] = new TabCache();
            }
            _loc29_ = this._tabsCache[this._nCurrentTab];
            if(_loc14_)
            {
               _loc26_ = this.appendLine(_loc15_,_loc18_,param3,true,_loc17_);
               if(this.sysApi.getOption("chatExpertMode","chat"))
               {
                  _loc29_.text = this.texta_tchat.htmlText;
                  _loc29_.numLines = this.texta_tchat.maxScrollV;
                  if(!_loc29_.needUpdate)
                  {
                     _loc27_ = this.getChannelTabs(_loc17_);
                     for each(_loc28_ in _loc27_)
                     {
                        if(_loc28_ != this._nCurrentTab)
                        {
                           this.appendLineToTabCache(_loc28_,_loc15_,param3,_loc18_);
                        }
                     }
                  }
               }
            }
            else
            {
               _loc26_ = this.appendFakeLine(_loc15_,_loc18_,param3);
               if(this.sysApi.getOption("chatExpertMode","chat"))
               {
                  if(!_loc29_.needUpdate)
                  {
                     _loc27_ = this.getChannelTabs(_loc17_);
                     for each(_loc28_ in _loc27_)
                     {
                        if(_loc28_ != this._nCurrentTab)
                        {
                           this.appendLineToTabCache(_loc28_,_loc15_,param3,_loc18_);
                        }
                     }
                  }
               }
            }
            this.chatApi.addParagraphToHistory(_loc17_,_loc26_);
            if(!this._refreshingChat)
            {
               _loc30_ = this.sysApi.getOption("externalChatEnabledChannels","chat");
               if(_loc30_.indexOf(_loc17_) != -1 || _loc17_ == this.chatApi.getRedChannelId())
               {
                  _loc31_ = LINK_CONTENT_REGEXP.exec(_loc15_);
                  _loc32_ = _loc15_;
                  while(_loc31_)
                  {
                     _loc32_ = _loc32_.replace(_loc31_[0],_loc31_[1]);
                     _loc31_ = LINK_CONTENT_REGEXP.exec(_loc15_);
                  }
                  this.chatApi.logChat(this.chatApi.getStaticHyperlink(_loc32_),_loc18_);
               }
            }
            this._numMessages++;
         }
      }
      
      private function refreshChat(param1:Boolean = true) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:TabCache = this._tabsCache[this._nCurrentTab];
         if(this.sysApi.getOption("chatExpertMode","chat") && _loc2_ && !_loc2_.needUpdate)
         {
            this.texta_tchat.htmlText = _loc2_.text;
            if(param1)
            {
               this.texta_tchat.scrollV = this.texta_tchat.maxScrollV;
            }
            return;
         }
         var _loc3_:Array = new Array();
         for each(_loc4_ in this._aTabs[this._nCurrentTab])
         {
            for each(_loc6_ in this.texta_tchat.getTextForChannel(_loc4_))
            {
               _loc3_.push(_loc6_);
            }
         }
         for each(_loc5_ in this.texta_tchat.getTextForChannel(this.chatApi.getRedChannelId()))
         {
            _loc3_.push(_loc5_);
         }
         _loc3_.sortOn("id",Array.NUMERIC);
         if(_loc3_.length > this.chatApi.getMessagesStoredMax())
         {
            _loc3_.splice(0,_loc3_.length - this.chatApi.getMessagesStoredMax());
         }
         if(this.texta_tchat.type == ChatComponentHandler.CHAT_NORMAL && this.texta_tchat.text == "")
         {
            return;
         }
         this.texta_tchat.clearText();
         if(this.texta_tchat.type == ChatComponentHandler.CHAT_ADVANCED)
         {
            this.texta_tchat.insertParagraphes(_loc3_);
         }
         else
         {
            this._numMessages = 0;
            this._refreshingChat = true;
            for each(_loc7_ in _loc3_)
            {
               switch(Api.chat.getTypeOfChatSentence(_loc7_))
               {
                  case "basicSentence":
                     this.formatLine(_loc7_.channel,_loc7_.msg,_loc7_.timestamp,_loc7_.fingerprint);
                     continue;
                  case "sourceSentence":
                     this.formatLine(_loc7_.channel,_loc7_.msg,_loc7_.timestamp,_loc7_.fingerprint,_loc7_.senderId,_loc7_.senderName,_loc7_.objects,"",0,false,_loc7_.admin);
                     continue;
                  case "recipientSentence":
                     this.formatLine(_loc7_.channel,_loc7_.msg,_loc7_.timestamp,_loc7_.fingerprint,_loc7_.senderId,_loc7_.senderName,_loc7_.objects,_loc7_.receiverName,_loc7_.receiverId);
                     continue;
                  case "informationSentence":
                     this.formatLine(_loc7_.channel,_loc7_.msg,_loc7_.timestamp,_loc7_.fingerprint);
                     continue;
                  default:
                     continue;
               }
            }
            this._refreshingChat = false;
         }
         if(param1)
         {
            this.texta_tchat.scrollV = this.texta_tchat.maxScrollV;
         }
         if(_loc2_)
         {
            _loc2_.needUpdate = false;
         }
      }
      
      private function updateChanColor(param1:int) : void
      {
         var _loc2_:int = this.sysApi.getOption("channelColor" + param1,"chat");
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.color = _loc2_;
         this.tx_arrow_btn_menu.transform.colorTransform = _loc3_;
         this.inp_tchatinput.setCssColor("#" + _loc2_.toString(16),"p" + param1);
      }
      
      private function changeCurrentChannel(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         if(this._sChan != param1)
         {
            _loc3_ = this.chatApi.searchChannel(param1);
            if(_loc3_ != -1)
            {
               this._sCssClass = "p" + _loc3_;
               this._sLastChan = this._sChan;
               this._sChan = param1;
               if(!param2)
               {
                  this._bCurrentChannelSelected = true;
               }
               if(this.inp_tchatinput.cssClass != this._sCssClass)
               {
                  this.inp_tchatinput.cssClass = this._sCssClass;
               }
               this.updateChanColor(_loc3_);
            }
         }
      }
      
      private function changeDefaultChannel(param1:String) : void
      {
         var _loc2_:int = this.chatApi.searchChannel(param1);
         if(_loc2_ != -1)
         {
            this._sChanLocked = param1;
         }
         this.changeCurrentChannel(param1,false);
      }
      
      private function changeDisplayChannel(param1:Object, param2:int) : void
      {
         var _loc3_:TabCache = null;
         if(this._aTabs[param2].indexOf(param1.id) == -1)
         {
            if(this.howManyTimesIsThisChannelUsed(param1.id) == 0)
            {
               this.sysApi.sendAction(new ChannelEnabling(param1.id,true));
            }
            else
            {
               this._bChanCheckChange = false;
            }
            this._aTabs[param2].push(param1.id);
         }
         else
         {
            if(this.howManyTimesIsThisChannelUsed(param1.id) == 1)
            {
               this.sysApi.sendAction(new ChannelEnabling(param1.id,false));
            }
            else
            {
               this._bChanCheckChange = false;
            }
            this._aTabs[param2].splice(this._aTabs[param2].indexOf(param1.id),1);
         }
         _loc3_ = this._tabsCache[param2];
         if(_loc3_)
         {
            _loc3_.needUpdate = true;
         }
         this.refreshChat();
         this.sysApi.sendAction(new TabsUpdate(this._aTabs));
      }
      
      private function howManyTimesIsThisChannelUsed(param1:uint) : uint
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:uint = 0;
         for each(_loc3_ in this._aTabs)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ == param1)
               {
                  _loc2_++;
               }
            }
         }
         return _loc2_;
      }
      
      private function tabpicChange(param1:uint, param2:int) : void
      {
         this.onTabPictoChange(param2 + 1,param1.toString());
      }
      
      private function openOptions() : void
      {
         this.modCommon.openOptionMenu(false,"ui");
      }
      
      private function openExternalChat() : void
      {
         this.chatApi.launchExternalChat();
      }
      
      private function colorCheckBox() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:ColorTransform = null;
         for(_loc1_ in this._aCheckColors)
         {
            _loc2_ = new ColorTransform();
            _loc2_.color = this.configApi.getConfigProperty("chat","channelColor" + this._aCheckChans[_loc1_][0]);
            this._aCheckColors[_loc1_].transform.colorTransform = _loc2_;
         }
      }
      
      private function switchNoobyMode(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         if(param1)
         {
            this._aTabsViewStamp = new Array();
            this.tabs_ctr.visible = false;
            this.checks_ctr.visible = true;
            if(this._nCurrentTab != 0)
            {
               this._nCurrentTab = 0;
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this.refreshChat();
            }
            this.colorCheckBox();
            for(_loc3_ in this._aCheckChans)
            {
               if(this._aTabs[0].indexOf(this._aCheckChans[_loc3_][0]) != -1)
               {
                  if(this._aCheckChans[_loc3_].length > 1)
                  {
                     for each(_loc2_ in this._aCheckChans[_loc3_])
                     {
                        if(this._aTabs[0].indexOf(_loc2_) == -1)
                        {
                           this.changeDisplayChannel(this.dataApi.getChatChannel(_loc2_),this._nCurrentTab);
                           if(this._aTabsViewStamp.indexOf(_loc2_) == -1)
                           {
                              this._aTabsViewStamp.push(_loc2_);
                           }
                        }
                     }
                  }
                  this._aChecks[_loc3_].selected = true;
               }
               else
               {
                  if(this._aCheckChans[_loc3_].length > 1)
                  {
                     for each(_loc2_ in this._aCheckChans[_loc3_])
                     {
                        if(this._aTabs[0].indexOf(_loc2_) != -1)
                        {
                           this.changeDisplayChannel(this.dataApi.getChatChannel(_loc2_),this._nCurrentTab);
                           if(this._aTabsViewStamp.indexOf(_loc2_) == -1)
                           {
                              this._aTabsViewStamp.push(_loc2_);
                           }
                        }
                     }
                  }
                  this._aChecks[_loc3_].selected = false;
               }
            }
         }
         else
         {
            if(this._aTabsViewStamp != null)
            {
               for each(_loc2_ in this._aTabsViewStamp)
               {
                  this.changeDisplayChannel(this.dataApi.getChatChannel(_loc2_),this._nCurrentTab);
               }
               this._aTabsViewStamp = null;
            }
            this.checks_ctr.visible = false;
            this.tabs_ctr.visible = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:uint = 0;
         var _loc12_:* = undefined;
         var _loc13_:Boolean = false;
         var _loc14_:* = undefined;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:* = undefined;
         var _loc18_:Object = null;
         var _loc19_:uint = 0;
         var _loc20_:Object = null;
         switch(param1)
         {
            case this.btn_menu:
               _loc2_ = new Array();
               _loc3_ = new Array();
               _loc4_ = new Array();
               _loc5_ = new Array();
               _loc3_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.small"),this.textResize,[SMALL_SIZE,SMALL_SIZE_LINE_HEIGHT],false,null,this._nFontSize == SMALL_SIZE));
               _loc3_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.medium"),this.textResize,[MEDIUM_SIZE,MEDIUM_SIZE_LINE_HEIGHT],false,null,this._nFontSize == MEDIUM_SIZE));
               _loc3_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.large"),this.textResize,[LARGE_SIZE,LARGE_SIZE_LINE_HEIGHT],false,null,this._nFontSize == LARGE_SIZE));
               _loc6_ = this.uiApi.me().getConstant("tabIcon_uri");
               _loc11_ = 0;
               while(_loc11_ < 12)
               {
                  _loc4_.push(this.modContextMenu.createContextMenuPictureItemObject(_loc6_ + "hl_" + _loc11_ + ".png",this.tabpicChange,[_loc11_,this._nCurrentTab],false,null,_loc11_.toString() == this._aTabsPicto[this._nCurrentTab],true));
                  _loc11_++;
               }
               for each(_loc12_ in this._aChannels)
               {
                  _loc13_ = false;
                  for each(_loc14_ in this._aTabs[this._nCurrentTab])
                  {
                     if(_loc14_ == _loc12_)
                     {
                        _loc13_ = true;
                     }
                  }
                  _loc15_ = this.dataApi.getChatChannel(_loc12_);
                  _loc16_ = null;
                  if(_loc15_.shortcutKey)
                  {
                     _loc16_ = this.bindsApi.getShortcutBindStr(_loc15_.shortcutKey).toString();
                  }
                  if(_loc16_)
                  {
                     _loc5_.push(this.modContextMenu.createContextMenuItemObject(_loc15_.name + " (" + _loc16_ + ")",this.changeDisplayChannel,[_loc15_,this._nCurrentTab],false,null,_loc13_,false));
                  }
                  else
                  {
                     _loc5_.push(this.modContextMenu.createContextMenuItemObject(_loc15_.name,this.changeDisplayChannel,[_loc15_,this._nCurrentTab],false,null,_loc13_,false));
                  }
               }
               _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.option.chat")));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.title.chat") + "...",this.openOptions,null,false,null,false,true));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.externalChat.open"),this.openExternalChat,null,this._isStreaming,null,false,true));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.fontSize"),null,null,false,_loc3_));
               if(!this.checks_ctr.visible)
               {
                  _loc2_.push(this.modContextMenu.createContextMenuSeparatorObject());
                  _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.option.chatTab")));
                  _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.tabPic"),null,null,false,_loc4_));
                  _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.displayedChannels"),null,null,false,_loc5_));
               }
               _loc2_.push(this.modContextMenu.createContextMenuSeparatorObject());
               _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.option.currentChannel")));
               _loc8_ = 0;
               if(!_shortcutColor)
               {
                  _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
                  _shortcutColor = _shortcutColor.replace("0x","#");
               }
               for each(_loc17_ in this._aTabs[this._nCurrentTab])
               {
                  _loc18_ = this.dataApi.getChatChannel(_loc17_);
                  if(_loc18_.shortcut && _loc18_.shortcut != "null")
                  {
                     _loc8_++;
                     if(this._sChanLocked == _loc18_.shortcut)
                     {
                        _loc7_ = true;
                     }
                     else
                     {
                        _loc7_ = false;
                     }
                     _loc2_.push(this.modContextMenu.createContextMenuItemObject(_loc18_.name + " <font color=\'" + _shortcutColor + "\'>(" + _loc18_.shortcut + ")</font>",this.changeDefaultChannel,[_loc18_.shortcut],false,null,_loc7_,true));
                  }
               }
               if(_loc8_ == 0)
               {
                  _loc2_.pop();
                  _loc2_.pop();
               }
               this.modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_plus:
               this.resize(1);
               break;
            case this.btn_minus:
               this.resize(-1);
               break;
            case this.btn_smiley:
               this.sysApi.sendAction(new OpenSmileys(0));
               if(this._smileyOpened)
               {
                  this.btn_smiley.soundId = SoundEnum.WINDOW_OPEN;
               }
               else
               {
                  this.btn_smiley.soundId = SoundEnum.WINDOW_CLOSE;
               }
               this._smileyOpened = !this._smileyOpened;
               break;
            case this.btn_tab0:
               this._nCurrentTab = 0;
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this.refreshChat();
               break;
            case this.btn_tab1:
               this._nCurrentTab = 1;
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this.refreshChat();
               break;
            case this.btn_tab2:
               this._nCurrentTab = 2;
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this.refreshChat();
               break;
            case this.btn_tab3:
               this._nCurrentTab = 3;
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this.refreshChat();
               break;
            case this.inp_tchatinput:
               if(this.uiApi.useIME())
               {
                  this.setImeMode(null);
               }
               break;
            case this.btn_check0:
            case this.btn_check1:
            case this.btn_check2:
            case this.btn_check3:
            case this.btn_check4:
            case this.btn_check5:
            case this.btn_check6:
            case this.btn_check7:
               this._bChanCheckChange = true;
               for each(_loc19_ in this._aCheckChans[int(param1.name.substr(9,1))])
               {
                  _loc20_ = this.dataApi.getChatChannel(_loc19_);
                  if(this._aTabs[this._nCurrentTab].indexOf(_loc20_.id) != -1 != param1.selected)
                  {
                     this.changeDisplayChannel(_loc20_,this._nCurrentTab);
                  }
                  if(this._aTabsViewStamp.indexOf(_loc20_.id) != -1)
                  {
                     this._aTabsViewStamp.splice(this._aTabsViewStamp.indexOf(_loc20_.id),1);
                  }
               }
               break;
            case this.btn_ime:
               _loc9_ = new Array();
               _loc9_.push(this.modContextMenu.createContextMenuItemObject("あ Hiragana",this.setImeMode,[IMEConversionMode.JAPANESE_HIRAGANA],false,null,IME.conversionMode == IMEConversionMode.JAPANESE_HIRAGANA,true));
               _loc9_.push(this.modContextMenu.createContextMenuItemObject("カ Katakana",this.setImeMode,[IMEConversionMode.JAPANESE_KATAKANA_FULL],false,null,IME.conversionMode == IMEConversionMode.JAPANESE_KATAKANA_FULL,true));
               _loc9_.push(this.modContextMenu.createContextMenuItemObject("_カ Half-width Katakana",this.setImeMode,[IMEConversionMode.JAPANESE_KATAKANA_HALF],false,null,IME.conversionMode == IMEConversionMode.JAPANESE_KATAKANA_HALF,true));
               _loc9_.push(this.modContextMenu.createContextMenuItemObject("Ａ Full-width Alphanumeric",this.setImeMode,[IMEConversionMode.ALPHANUMERIC_FULL],false,null,IME.conversionMode == IMEConversionMode.ALPHANUMERIC_FULL,true));
               _loc9_.push(this.modContextMenu.createContextMenuItemObject("_Ａ Half-width Alphanumeric",this.setImeMode,[IMEConversionMode.ALPHANUMERIC_HALF],false,null,IME.conversionMode == IMEConversionMode.ALPHANUMERIC_HALF,true));
               _loc9_.push(this.modContextMenu.createContextMenuItemObject("D Direct input",this.setImeMode,[IMEConversionMode.UNKNOWN],false,null,IME.conversionMode == IMEConversionMode.UNKNOWN,true));
               this.modContextMenu.createContextMenu(_loc9_);
               break;
            case this.btn_status:
               this.sysApi.dispatchHook(OpenStatusMenu);
               _loc10_ = new Array();
               _loc10_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.chat.status.title")));
               _loc10_.push(this.modContextMenu.createContextMenuPictureLabelItemObject(this.uiApi.createUri(this._iconsPath + "green.png"),this.uiApi.getText("ui.chat.status.availiable"),13,false,this.onStatusChange,[PlayerStatusEnum.PLAYER_STATUS_AVAILABLE],false,null,_currentStatus == -1,true,this.uiApi.getText("ui.chat.status.availiabletooltip")));
               _loc10_.push(this.modContextMenu.createContextMenuPictureLabelItemObject(this.uiApi.createUri(this._iconsPath + "yellow.png"),this.uiApi.getText("ui.chat.status.away"),13,false,this.onStatusChange,[PlayerStatusEnum.PLAYER_STATUS_AFK],false,null,_currentStatus == 0,true,this.uiApi.getText("ui.chat.status.awaytooltip")));
               _loc10_.push(this.modContextMenu.createContextMenuPictureLabelItemObject(this.uiApi.createUri(this._iconsPath + "yellow.png"),this.uiApi.getText("ui.chat.status.away") + "...",13,false,this.onStatusChangeWithMessage,[PlayerStatusEnum.PLAYER_STATUS_AFK],false,null,_currentStatus == 0,true,this.uiApi.getText("ui.chat.status.awaymessagetooltip")));
               _loc10_.push(this.modContextMenu.createContextMenuPictureLabelItemObject(this.uiApi.createUri(this._iconsPath + "blue.png"),this.uiApi.getText("ui.chat.status.private"),13,false,this.onStatusChange,[PlayerStatusEnum.PLAYER_STATUS_PRIVATE],false,null,_currentStatus == 1,true,this.uiApi.getText("ui.chat.status.privatetooltip")));
               _loc10_.push(this.modContextMenu.createContextMenuPictureLabelItemObject(this.uiApi.createUri(this._iconsPath + "red.png"),this.uiApi.getText("ui.chat.status.solo"),13,false,this.onStatusChange,[PlayerStatusEnum.PLAYER_STATUS_SOLO],false,null,_currentStatus == 1,true,this.uiApi.getText("ui.chat.status.solotooltip")));
               this.modContextMenu.createContextMenu(_loc10_);
         }
      }
      
      private function setImeMode(param1:String) : void
      {
         if(param1 == IMEConversionMode.UNKNOWN)
         {
            IME.enabled = false;
         }
         else
         {
            try
            {
               IME.enabled = true;
               IME.conversionMode = param1;
            }
            catch(e:Error)
            {
            }
         }
         var _loc2_:String = "";
         switch(IME.conversionMode)
         {
            case IMEConversionMode.JAPANESE_HIRAGANA:
               _loc2_ = "あ";
               break;
            case IMEConversionMode.JAPANESE_KATAKANA_FULL:
               _loc2_ = "カ";
               break;
            case IMEConversionMode.JAPANESE_KATAKANA_HALF:
               _loc2_ = "_カ";
               break;
            case IMEConversionMode.ALPHANUMERIC_FULL:
               _loc2_ = "Ａ";
               break;
            case IMEConversionMode.ALPHANUMERIC_HALF:
               _loc2_ = "_Ａ";
               break;
            default:
               _loc2_ = "D";
         }
         this.btn_lbl_btn_ime.text = _loc2_;
      }
      
      private function onDelaySendChatTimer(param1:TimerEvent) : void
      {
         this._delaySendChatTimer.reset();
         this._delaySendChat = false;
         if(this._delayWaitingMessage)
         {
            this._delayWaitingMessage = false;
            this.validUiShortcut();
         }
      }
      
      private function getHyperlinkFormatedText(param1:String) : String
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         param1 = this.chatApi.escapeChatString(param1);
         var _loc2_:int = this._aItemReplacement.length;
         var _loc3_:Array = new Array();
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc8_ = this._aItemReplacement[_loc4_];
            _loc9_ = "[" + _loc8_.realName + "]";
            _loc10_ = param1.indexOf(_loc9_);
            if(_loc10_ == -1)
            {
               _loc3_.push(this._aItemReplacement[_loc4_]);
            }
            else
            {
               param1 = param1.substr(0,_loc10_) + ITEM_INDEX_CODE + param1.substr(_loc10_ + _loc9_.length);
            }
            _loc4_--;
         }
         for each(_loc5_ in _loc3_)
         {
            this._aItemReplacement.splice(this._aItemReplacement.indexOf(_loc5_),1);
         }
         _loc6_ = this._aMiscReplacement.length;
         _loc7_ = 0;
         _loc7_ = _loc6_ - 1;
         while(_loc7_ >= 0)
         {
            _loc10_ = param1.lastIndexOf(this._aMiscReplacement[_loc7_ - 1]);
            if(_loc10_ != -1)
            {
               param1 = param1.substr(0,_loc10_) + this._aMiscReplacement[_loc7_] + param1.substr(_loc10_ + this._aMiscReplacement[_loc7_ - 1].length);
            }
            _loc7_ = _loc7_ - 2;
         }
         return param1;
      }
      
      private function processLinkedItem(param1:String) : String
      {
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc2_:int = this._aItemReplacement.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._aItemReplacement[_loc3_];
            _loc5_ = "[" + _loc4_.realName + "]";
            _loc6_ = param1.indexOf(_loc5_);
            if(_loc6_ == -1)
            {
               this._aItemReplacement.splice(_loc3_,1);
               _loc3_--;
               _loc2_--;
            }
            else
            {
               param1 = param1.substr(0,_loc6_) + ITEM_INDEX_CODE + _loc4_.objectGID + "," + _loc4_.objectUID + ITEM_INDEX_CODE + param1.substr(_loc6_ + _loc5_.length);
            }
            _loc3_++;
         }
         return param1;
      }
      
      private function addChannelsContextMenu(param1:int) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:Boolean = false;
         var _loc8_:* = undefined;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:* = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:String = this.uiApi.me().getConstant("tabIcon_uri");
         var _loc5_:uint = 0;
         while(_loc5_ < 12)
         {
            _loc3_.push(this.modContextMenu.createContextMenuPictureItemObject(_loc4_ + "hl_" + _loc5_ + ".png",this.tabpicChange,[_loc5_,param1],false,null,_loc5_.toString() == this._aTabsPicto[param1],true));
            _loc5_++;
         }
         for each(_loc6_ in this._aChannels)
         {
            _loc7_ = false;
            for each(_loc8_ in this._aTabs[param1])
            {
               if(_loc8_ == _loc6_)
               {
                  _loc7_ = true;
               }
            }
            _loc9_ = this.dataApi.getChatChannel(_loc6_);
            _loc10_ = null;
            if(_loc9_.shortcutKey)
            {
               _loc10_ = this.bindsApi.getShortcutBindStr(_loc9_.shortcutKey).toString();
            }
            if(_loc10_)
            {
               _loc11_ = _loc9_.name + " (" + _loc10_ + ")";
            }
            else
            {
               _loc11_ = _loc9_.name;
            }
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(_loc11_,this.changeDisplayChannel,[_loc9_,param1],false,null,_loc7_,false));
         }
         _loc2_.push(this.modContextMenu.createContextMenuSeparatorObject());
         _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.option.tabPic"),null,null,false,_loc3_));
         this.modContextMenu.createContextMenu(_loc2_);
      }
      
      private function validUiShortcut() : Boolean
      {
         var _loc1_:Object = null;
         if(!this.inp_tchatinput.haveFocus)
         {
            return false;
         }
         if(this._delaySendChat)
         {
            this._delayWaitingMessage = true;
            return true;
         }
         if(this.canSendMsg(this.inp_tchatinput.text))
         {
            _loc1_ = this.sysApi.getNewDynamicSecureObject();
            _loc1_.cancel = false;
            this.sysApi.dispatchHook(ChatSendPreInit,this.inp_tchatinput.text,_loc1_);
            return true;
         }
         return false;
      }
      
      private function canSendMsg(param1:String) : Boolean
      {
         if(param1.charAt(0) != " ")
         {
            return true;
         }
         if(param1.length == 0)
         {
            return false;
         }
         while(param1.indexOf(" ") != -1)
         {
            param1 = param1.replace(" ","");
         }
         return param1.length > 0;
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Object = null;
         var _loc18_:* = undefined;
         switch(param1)
         {
            case "focusChat":
               if(!this.inp_tchatinput.haveFocus)
               {
                  this._focusTimer.stop();
                  this._focusTimer.reset();
                  this._focusTimer.start();
               }
               return true;
            case "validUi":
               if(this.uiApi.useIME())
               {
                  return this.validUiShortcut();
               }
               return true;
            case ShortcutHookListEnum.CLOSE_UI:
               if(this.inp_tchatinput.haveFocus)
               {
                  this.inp_tchatinput.blur();
                  return true;
               }
               return false;
            case "upArrow":
            case "downArrow":
               if(!this.inp_tchatinput.haveFocus)
               {
                  break;
               }
               if(!this._aHistory[this._aHistory.length - 1] && !this._aHistory[0])
               {
                  break;
               }
               this._bCurrentChannelSelected = false;
               if(param1 == "upArrow" && this._nHistoryIndex >= 0)
               {
                  this._nHistoryIndex--;
               }
               if(param1 == "downArrow" && this._nHistoryIndex < this._aHistory.length)
               {
                  this._nHistoryIndex++;
               }
               _loc3_ = this._aHistory[this._nHistoryIndex];
               if(_loc3_ != null && _loc3_ != "")
               {
                  this.chanSearch(_loc3_);
                  _loc10_ = this.dataApi.getChatChannel(0).shortcut;
                  if(_loc3_.indexOf(_loc10_ + " ") == 0)
                  {
                     _loc11_ = _loc3_.slice(_loc10_.length + 1);
                  }
                  else
                  {
                     _loc11_ = _loc3_;
                  }
                  this._aItemReplacement = new Array();
                  _loc12_ = _loc11_.split(ITEM_INDEX_CODE);
                  _loc13_ = _loc12_.length;
                  _loc2_ = 1;
                  while(_loc2_ < _loc13_)
                  {
                     _loc14_ = _loc12_[_loc2_].split(",");
                     _loc15_ = uint(_loc14_[0]);
                     _loc16_ = uint(_loc14_[1]);
                     _loc17_ = !!_loc16_?this._dItemIndex[_loc16_]:this._dGenericItemIndex[_loc15_];
                     if(_loc17_)
                     {
                        _loc12_[_loc2_] = "[" + _loc17_.name + "]";
                        this._aItemReplacement.push(_loc17_);
                     }
                     else
                     {
                        _loc12_[_loc2_] = "";
                     }
                     _loc2_ = _loc2_ + 2;
                  }
                  _loc11_ = _loc12_.join("");
                  this.inp_tchatinput.text = _loc11_;
               }
               else
               {
                  this.inp_tchatinput.text = "";
                  this.init();
               }
               this.inp_tchatinput.setSelection(this.inp_tchatinput.length,this.inp_tchatinput.length);
               return true;
            case "shiftDown":
            case "shiftUp":
               if(!this.inp_tchatinput.haveFocus)
               {
                  break;
               }
               if(this._privateHistory.length == 0)
               {
                  break;
               }
               this._bCurrentChannelSelected = false;
               if(param1 == "shiftUp")
               {
                  _loc4_ = this._privateHistory.previous();
               }
               else if(param1 == "shiftDown")
               {
                  _loc4_ = this._privateHistory.next();
               }
               _loc5_ = "/w " + _loc4_ + " ";
               this.inp_tchatinput.text = _loc5_;
               this.chanSearch(_loc5_);
               this.inp_tchatinput.setSelection(this.inp_tchatinput.length,this.inp_tchatinput.length);
               return true;
            case "shiftValid":
            case "altValid":
            case "ctrlValid":
               if(!this.inp_tchatinput.haveFocus)
               {
                  this._focusTimer.stop();
                  this._focusTimer.reset();
                  this._focusTimer.start();
                  return false;
               }
               if(this.inp_tchatinput.text.charAt(0) == "/" && this.inp_tchatinput.text.indexOf(this._sChan) == 0)
               {
                  this._sText = this.inp_tchatinput.text.substring(this.inp_tchatinput.text.indexOf(" ") + 1,this.inp_tchatinput.text.length);
               }
               else
               {
                  this._sText = this.inp_tchatinput.text;
               }
               if(this._sText.length == 0)
               {
                  return true;
               }
               this._bCurrentChannelSelected = false;
               _loc6_ = this._sText;
               this._sText = this.getHyperlinkFormatedText(this._sText);
               _loc7_ = "";
               if(this._sDest)
               {
                  _loc7_ = _loc7_ + (this._sDest + " ");
               }
               else
               {
                  _loc7_ = _loc7_ + this._sDest;
               }
               _loc7_ = _loc7_ + this._sText;
               if(param1 == "altValid")
               {
                  _loc8_ = ChatActivableChannelsEnum.CHANNEL_GUILD;
                  if(this._aItemReplacement.length)
                  {
                     this.sysApi.sendAction(new ChatTextOutput(_loc7_,_loc8_,"",this._aItemReplacement));
                  }
                  else
                  {
                     this.sysApi.sendAction(new ChatTextOutput(_loc7_,_loc8_));
                  }
               }
               else if(param1 == "shiftValid")
               {
                  _loc8_ = ChatActivableChannelsEnum.CHANNEL_PARTY;
                  this.sysApi.sendAction(new ChatTextOutput(_loc7_,_loc8_,"",!!this._aItemReplacement.length?this._aItemReplacement:null));
               }
               else if(param1 == "ctrlValid")
               {
                  _loc8_ = ChatActivableChannelsEnum.CHANNEL_TEAM;
                  this.sysApi.sendAction(new ChatTextOutput(_loc7_,_loc8_,"",!!this._aItemReplacement.length?this._aItemReplacement:null));
               }
               _loc9_ = this.dataApi.getChatChannel(_loc8_).shortcut;
               if(this.sysApi.getOption("channelLocked","chat"))
               {
                  this.changeDefaultChannel(_loc9_);
               }
               else
               {
                  this.changeCurrentChannel(_loc9_);
               }
               _loc6_ = this.processLinkedItem(_loc6_);
               this._sText = _loc6_;
               this.textOutput();
               this.inp_tchatinput.text = "";
               if(!this.sysApi.getOption("channelLocked","chat"))
               {
                  this.init();
               }
               else
               {
                  for each(_loc18_ in this._aChannels)
                  {
                     if(_loc18_ != ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG && this.dataApi.getChatChannel(_loc18_).shortcut == this._sChan)
                     {
                        if(this.dataApi.getChatChannel(_loc18_).isPrivate)
                        {
                           this.init();
                        }
                     }
                  }
               }
               return true;
            case ShortcutHookListEnum.EXTEND_CHAT:
            case ShortcutHookListEnum.EXTEND_CHAT2:
               if(!this.inp_tchatinput.haveFocus)
               {
                  this.resize(1);
               }
               return true;
            case ShortcutHookListEnum.SHRINK_CHAT:
               if(!this.inp_tchatinput.haveFocus)
               {
                  this.resize(-1);
               }
               return true;
            case ShortcutHookListEnum.TOGGLE_EMOTES:
               this.sysApi.sendAction(new OpenSmileys(0));
               if(this._smileyOpened)
               {
                  this.btn_smiley.soundId = SoundEnum.WINDOW_OPEN;
               }
               else
               {
                  this.btn_smiley.soundId = SoundEnum.WINDOW_CLOSE;
               }
               this._smileyOpened = !this._smileyOpened;
               return true;
            case ShortcutHookListEnum.TOGGLE_ATTITUDES:
               this.openEmoteUi();
               return true;
            case ShortcutHookListEnum.CHAT_TAB_0:
               if(this.checks_ctr.visible)
               {
                  return true;
               }
               if(this._aTabs.length > 0)
               {
                  this._nCurrentTab = 0;
                  this._aTxHighlights[this._nCurrentTab].visible = false;
                  this._aBtnTabs[this._nCurrentTab].selected = true;
                  this.refreshChat();
               }
               return true;
            case ShortcutHookListEnum.CHAT_TAB_1:
               if(this.checks_ctr.visible)
               {
                  return true;
               }
               if(this._aTabs.length > 1)
               {
                  this._nCurrentTab = 1;
                  this._aTxHighlights[this._nCurrentTab].visible = false;
                  this._aBtnTabs[this._nCurrentTab].selected = true;
                  this.refreshChat();
               }
               return true;
            case ShortcutHookListEnum.CHAT_TAB_2:
               if(this.checks_ctr.visible)
               {
                  return true;
               }
               if(this._aTabs.length > 2)
               {
                  this._nCurrentTab = 2;
                  this._aTxHighlights[this._nCurrentTab].visible = false;
                  this._aBtnTabs[this._nCurrentTab].selected = true;
                  this.refreshChat();
               }
               return true;
            case ShortcutHookListEnum.CHAT_TAB_3:
               if(this.checks_ctr.visible)
               {
                  return true;
               }
               if(this._aTabs.length > 3)
               {
                  this._nCurrentTab = 3;
                  this._aTxHighlights[this._nCurrentTab].visible = false;
                  this._aBtnTabs[this._nCurrentTab].selected = true;
                  this.refreshChat();
               }
               return true;
            case ShortcutHookListEnum.NEXT_CHAT_TAB:
               if(this.checks_ctr.visible)
               {
                  return true;
               }
               this._nCurrentTab++;
               this._nCurrentTab = this._nCurrentTab % this._aTabs.length;
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this._aBtnTabs[this._nCurrentTab].selected = true;
               this.refreshChat();
               return true;
            case ShortcutHookListEnum.PREVIOUS_CHAT_TAB:
               if(this.checks_ctr.visible)
               {
                  return true;
               }
               if(this._nCurrentTab > 0)
               {
                  this._nCurrentTab--;
               }
               else
               {
                  this._nCurrentTab = this._aTabs.length - 1;
               }
               this.refreshChat();
               this._aTxHighlights[this._nCurrentTab].visible = false;
               this._aBtnTabs[this._nCurrentTab].selected = true;
               this.refreshChat();
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_GLOBAL:
               this.changeDisplayChannel(this.dataApi.getChatChannel(0),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_TEAM:
               this.changeDisplayChannel(this.dataApi.getChatChannel(1),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_GUILD:
               this.changeDisplayChannel(this.dataApi.getChatChannel(2),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_ALLIANCE:
               this.changeDisplayChannel(this.dataApi.getChatChannel(3),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_PARTY:
               this.changeDisplayChannel(this.dataApi.getChatChannel(4),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_ARENA:
               this.changeDisplayChannel(this.dataApi.getChatChannel(13),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_SALES:
               this.changeDisplayChannel(this.dataApi.getChatChannel(5),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_SEEK:
               this.changeDisplayChannel(this.dataApi.getChatChannel(6),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.TOGGLE_CHANNEL_FIGHT:
               this.changeDisplayChannel(this.dataApi.getChatChannel(11),this._nCurrentTab);
               return true;
            case ShortcutHookListEnum.SWITCH_TEXT_SIZE:
               switch(this._nFontSize)
               {
                  case SMALL_SIZE:
                     this.textResize(MEDIUM_SIZE,MEDIUM_SIZE_LINE_HEIGHT);
                     break;
                  case MEDIUM_SIZE:
                     this.textResize(LARGE_SIZE,LARGE_SIZE_LINE_HEIGHT);
                     break;
                  case LARGE_SIZE:
                     this.textResize(SMALL_SIZE,SMALL_SIZE_LINE_HEIGHT);
               }
               return true;
            case ShortcutHookListEnum.CHAT_AUTOCOMPLETE:
               if(this.inp_tchatinput.haveFocus)
               {
                  this.autocompleteChat();
                  return true;
               }
               return false;
         }
         return false;
      }
      
      public function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         if(this.sysApi.getCurrentLanguage() != "ja" && !(param1.altKey || param1.shiftKey || param1.hasOwnProperty("controlKey") && Object(param1).controlKey || param1.ctrlKey || param1.hasOwnProperty("commandKey") && Object(param1).commandKey) && param1.keyCode == Keyboard.ENTER)
         {
            this.validUiShortcut();
         }
         else
         {
            if(this.uiApi.useIME())
            {
               this.setImeMode(null);
            }
            _loc2_ = this.inp_tchatinput.text;
            if(!this.uiApi.useIME())
            {
               this.inp_tchatinput.text = _loc2_;
               if(this.inp_tchatinput.text == "")
               {
                  this.inp_tchatinput.cssClass = this._sCssClass;
               }
            }
            this.chanSearch(_loc2_);
         }
      }
      
      public function onChatSendPreInit(param1:String, param2:Object) : void
      {
         var _loc4_:ChatChannel = null;
         var _loc5_:String = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Array = null;
         var _loc18_:Object = null;
         var _loc19_:int = 0;
         if(param2.cancel)
         {
            this.inp_tchatinput.text = "";
            return;
         }
         var _loc3_:int = 0;
         for each(_loc3_ in this._aChannels)
         {
            _loc4_ = this.dataApi.getChatChannel(_loc3_);
            if(this._sChan == _loc4_.shortcut)
            {
               break;
            }
         }
         _loc5_ = param1;
         if(_loc5_.charAt(0) == "/" && _loc5_.toLowerCase().indexOf(this._sChan + " ") == 0)
         {
            this._sText = _loc5_.substring(_loc5_.indexOf(" ") + 1,_loc5_.length);
         }
         else
         {
            this._sText = _loc5_;
         }
         if(this._sText.length == 0)
         {
            return;
         }
         this._bCurrentChannelSelected = false;
         if(this._sText.charAt(0) == String.fromCharCode(65295))
         {
            _loc11_ = "";
            _loc12_ = 0;
            while(_loc12_ < this._sText.length)
            {
               _loc13_ = this._sText.charCodeAt(_loc12_);
               if(_loc13_ >= 65281 && _loc13_ <= 65374)
               {
                  _loc13_ = _loc13_ - 65248;
               }
               _loc11_ = _loc11_ + String.fromCharCode(_loc13_);
               _loc12_++;
            }
            this._sText = _loc11_;
         }
         if(this._sText.charAt(0) == "/" && this._sText.length == _loc5_.length && this._sText.substr(0,3).toLowerCase() != "/me" && this._sText.substr(0,6).toLowerCase() != "/think" && !(this._sText.charAt(0) == "*" && this._sText.charAt(this._sText.length - 1) == "*"))
         {
            this.sysApi.sendAction(new ChatCommand(this._sText.substr(1)));
            this.inp_tchatinput.text = "";
            this.addToHistory(this._sText);
            return;
         }
         var _loc6_:Boolean = false;
         if(this._sText.indexOf(")[") != -1)
         {
            _loc6_ = true;
         }
         this._sText = this._sText.replace("][","] [");
         var _loc7_:String = this._sText.substring(0,this._sText.indexOf(" "));
         if(_loc7_ == "")
         {
            _loc7_ = this._sText;
         }
         if(_loc7_.charAt(0) != "[" && _loc7_.indexOf("]") != -1 || _loc7_.indexOf("[") != -1 && _loc7_.indexOf("]") == -1 && this._sText.indexOf("]") != -1)
         {
            this._sText = this._sText.substring(0,this._sText.indexOf("[")) + " " + this._sText.substring(this._sText.indexOf("["),this._sText.length);
            this._sText = this.trim(this._sText);
         }
         else if(_loc7_.charAt(0) == "[" && _loc7_.indexOf("]") != _loc7_.lastIndexOf("]"))
         {
            this._sText = this._sText.substring(0,this._sText.lastIndexOf("[")) + " " + this._sText.substring(this._sText.lastIndexOf("["),this._sText.length);
            this._sText = this.trim(this._sText);
         }
         if(_loc6_ && this._sText.indexOf(") [") != -1)
         {
            this._sText = this._sText.replace(") [",")[");
         }
         var _loc8_:Object = this.inp_tchatinput.getHyperLinkCodes();
         var _loc9_:uint = !!_loc8_?uint(_loc8_.length):uint(0);
         if(_loc9_ > 0)
         {
            this._aItemReplacement = [];
            _loc14_ = 0;
            while(_loc14_ < _loc9_)
            {
               _loc17_ = _loc8_[_loc14_].split(",");
               _loc15_ = uint(_loc17_[1]);
               _loc16_ = uint(_loc17_[2].substring(0,_loc17_[2].indexOf("}")));
               _loc18_ = !!_loc16_?this._dItemIndex[_loc16_]:this._dGenericItemIndex[_loc15_];
               if(_loc18_)
               {
                  this._aItemReplacement.push(_loc18_);
               }
               _loc14_++;
            }
         }
         var _loc10_:String = this._sText;
         this._sText = this.getHyperlinkFormatedText(this._sText);
         if(!_loc4_.isPrivate)
         {
            if(this._aItemReplacement.length)
            {
               this.sysApi.sendAction(new ChatTextOutput(this._sText,_loc3_,this._sDest,this._aItemReplacement));
            }
            else
            {
               this.sysApi.sendAction(new ChatTextOutput(this._sText,_loc3_,this._sDest));
            }
         }
         else
         {
            _loc19_ = this._sText.indexOf(" ");
            this._sDest = this._sText.substring(0,_loc19_);
            this._sText = this._sText.substring(_loc19_ + 1,this._sText.length);
            _loc10_ = _loc10_.substring(_loc10_.indexOf(" ") + 1,_loc10_.length);
            if(this._sDest.length != 0)
            {
               if(this._aItemReplacement.length)
               {
                  this.sysApi.sendAction(new ChatTextOutput(this._sText,_loc3_,this._sDest,this._aItemReplacement));
               }
               else
               {
                  this.sysApi.sendAction(new ChatTextOutput(this._sText,_loc3_,this._sDest));
               }
            }
         }
         this._privateHistory.resetCursor();
         _loc10_ = this.processLinkedItem(_loc10_);
         this._sText = _loc10_;
         this._aItemReplacement = new Array();
         this.textOutput();
         this.inp_tchatinput.text = "";
         if(!this.sysApi.getOption("channelLocked","chat") || _loc4_.isPrivate)
         {
            this.init();
         }
      }
      
      public function onChatServer(param1:uint = 0, param2:Number = 0, param3:String = "", param4:String = "", param5:Number = 0, param6:String = "", param7:Boolean = false) : void
      {
         this.formatLine(param1,param4,param5,param6,param2,param3,null,"",0,false,param7);
      }
      
      public function onChatServerWithObject(param1:uint = 0, param2:Number = 0, param3:String = "", param4:String = "", param5:Number = 0, param6:String = "", param7:Object = null) : void
      {
         this.formatLine(param1,param4,param5,param6,param2,param3,param7);
      }
      
      public function onChatServerCopy(param1:uint = 0, param2:String = "", param3:String = "", param4:Number = 0, param5:String = "", param6:Number = 0) : void
      {
         this.formatLine(param1,param3,param4,param5,0,"",null,param2,param6);
      }
      
      public function onChatServerCopyWithObject(param1:uint = 0, param2:String = "", param3:String = "", param4:Number = 0, param5:String = "", param6:Number = 0, param7:Object = null) : void
      {
         this.formatLine(param1,param3,param4,param5,0,"",param7,param2,param6);
      }
      
      public function onChatSpeakingItem(param1:uint = 0, param2:Object = null, param3:String = "", param4:Number = 0, param5:String = "") : void
      {
         this.sysApi.sendAction(new SaveMessage(param2.name + this.uiApi.getText("ui.common.colon") + param3,param1,param4));
         this.formatLine(param1,param3,param4,param5,0,param2.name,null,"",0,true);
      }
      
      public function onLivingObjectMessage(param1:String = "", param2:String = "", param3:Number = 0) : void
      {
         this.sysApi.sendAction(new SaveMessage(param1 + this.uiApi.getText("ui.common.colon") + param2,0,param3));
         this.formatLine(0,param2,param3,"",0,param1,null,"",0,true);
      }
      
      public function onTextInformation(param1:String = "", param2:int = 0, param3:Number = 0, param4:Boolean = true, param5:Boolean = false) : void
      {
         if(param1 == "")
         {
            this.sysApi.log(16,"Le message d\'information est vide, il ne sera pas affiché.");
         }
         else
         {
            if(param2 == 2)
            {
               this.soundApi.playSoundById("16109");
            }
            if(param4)
            {
               this.sysApi.sendAction(new SaveMessage(param1,param2,param3));
            }
            this.formatLine(param2,param1,param3,"",0,"",null,"",0,false,false,param5);
         }
      }
      
      public function onTextActionInformation(param1:uint = 0, param2:Array = null, param3:int = 0, param4:Number = 0) : void
      {
         var _loc5_:String = this.uiApi.getTextFromKey(param1,null,param2);
         _loc5_ = this.uiApi.processText(_loc5_,"n",false);
         this.formatLine(param3,_loc5_,param4);
      }
      
      public function onTabPictoChange(param1:uint, param2:String = null) : void
      {
         this._aTabsPicto[param1 - 1] = param2;
         (this.uiApi.me().getElement("iconTexture" + this._aBtnTabs[param1 - 1].name) as TextureBase).uri = this.uiApi.createUri(this._tabIconsPath + param2 + ".png");
         this["tx_tab" + (param1 - 1)].uri = this.uiApi.createUri(this._tabIconsPath + "hl_" + param2 + ".png");
         this.sysApi.sendAction(new TabsUpdate(null,this._aTabsPicto));
      }
      
      public function onChannelEnablingChange(param1:uint = 0, param2:Boolean = false) : void
      {
         if(this._bChanCheckChange)
         {
            this._bChanCheckChange = false;
         }
      }
      
      public function onEnabledChannels(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._aTabs)
         {
            _loc8_ = new Array();
            for each(_loc9_ in _loc3_)
            {
               if(this.chatApi.getDisallowedChannelsId().indexOf(_loc9_) == -1)
               {
                  _loc8_.push(_loc9_);
               }
            }
            _loc2_.push(_loc8_);
         }
         this._aTabs = _loc2_;
         _loc4_ = this.chatApi.getChannelsId();
         this._aChannels = new Array();
         for each(_loc5_ in _loc4_)
         {
            this._aChannels.push(_loc5_);
         }
         _loc6_ = new Array();
         for each(_loc7_ in param1)
         {
            _loc6_.push(_loc7_);
         }
         if(_loc6_.length)
         {
            _loc11_ = new Array();
            if(this._aTabs.length == 0)
            {
               this._aTabs = this.sysApi.getOption("channelTabs","chat");
            }
            for each(_loc12_ in this._aTabs)
            {
               for each(_loc15_ in _loc12_)
               {
                  if(_loc11_[_loc15_] == undefined)
                  {
                     _loc11_[_loc15_] = 1;
                  }
               }
            }
            for each(_loc13_ in _loc6_)
            {
               if(_loc11_[_loc13_] == undefined)
               {
                  this.sysApi.sendAction(new ChannelEnabling(_loc13_,false));
               }
               else
               {
                  _loc11_[_loc13_] = null;
               }
            }
            for(_loc14_ in _loc11_)
            {
               if(_loc11_[_loc14_] != null && _loc14_ != ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG)
               {
                  if(_loc6_.indexOf(_loc14_) == -1)
                  {
                     this.sysApi.sendAction(new ChannelEnabling(_loc14_,true));
                  }
               }
            }
         }
      }
      
      public function onUpdateChatOptions() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:TabCache = null;
         for each(_loc3_ in this._aChannels)
         {
            if(_loc3_ != ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG)
            {
               _loc1_ = "#" + this.configApi.getConfigProperty("chat","channelColor" + _loc3_).toString(16);
               _loc2_ = "p" + _loc3_;
               this.texta_tchat.setCssColor(_loc1_,_loc2_);
               this._tmpLabel.setCssColor(_loc1_,_loc2_);
            }
            if(this.dataApi.getChatChannel(_loc3_).shortcut == this._sChan)
            {
               this.updateChanColor(_loc3_);
            }
         }
         this.switchNoobyMode(false);
         this.setTabsChannels();
         if(this.checks_ctr.visible)
         {
            this.colorCheckBox();
         }
         if(!this._init)
         {
            for(_loc4_ in this._aTabs)
            {
               _loc5_ = this._tabsCache[_loc4_];
               if(_loc5_)
               {
                  _loc5_.needUpdate = true;
               }
            }
         }
         this.refreshChat();
         if(this.updateChatOptionsAgain)
         {
            this.updateChatOptionsAgain = false;
            this.onUpdateChatOptions();
         }
      }
      
      public function onChatSmiley(param1:uint, param2:Number) : void
      {
         if(this.sysApi.getOption("smileysAutoclosed","chat") && param2 == this.playerApi.id())
         {
            this.btn_smiley.selected = false;
         }
      }
      
      private function openEmoteUi() : void
      {
         this.sysApi.sendAction(new OpenSmileys(1));
         if(this._emoteOpened)
         {
            this.btn_smiley.soundId = SoundEnum.WINDOW_OPEN;
         }
         else
         {
            this.btn_smiley.soundId = SoundEnum.WINDOW_CLOSE;
         }
         this._emoteOpened = !this._emoteOpened;
      }
      
      private function onToggleChatLog(param1:Boolean = true) : void
      {
      }
      
      private function onClearChat() : void
      {
         this.texta_tchat.clearText();
         var _loc1_:TabCache = this._tabsCache[this._nCurrentTab];
         _loc1_.text = "";
         _loc1_.needUpdate = true;
         this.sysApi.sendAction(new d2actions.ClearChat(this._aTabs[this._nCurrentTab]));
      }
      
      private function onChatRollOverLink(param1:*, param2:String) : void
      {
         var _loc3_:Object = this.uiApi.textTooltipInfo(param2,null,null,400);
         this.uiApi.showTooltip(_loc3_,param1,false,"standard",0,0,3,null,null,null,"TextInfo");
      }
      
      public function onNewMessage(param1:int, param2:uint = 0) : void
      {
         var _loc3_:* = undefined;
         for(_loc3_ in this._aTabs)
         {
            if(this._aTabs[_loc3_].indexOf(param1) != -1 && _loc3_ != this._nCurrentTab && this._aTabs[this._nCurrentTab].indexOf(param1) == -1)
            {
               this._aTxHighlights[_loc3_].visible = true;
            }
         }
         if(this.texta_tchat.type == ChatComponentHandler.CHAT_NORMAL)
         {
            this.chatApi.removeLinesFromHistory(param2,param1);
         }
      }
      
      public function onChatFocus(param1:String = "") : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            this.inp_tchatinput.text = "/w " + param1 + " ";
            _loc2_ = this.inp_tchatinput.text.length;
            this.inp_tchatinput.setSelection(_loc2_,_loc2_);
            this.chanSearch("/w ");
         }
         this.inp_tchatinput.focus();
         this.inp_tchatinput.caretIndex = -1;
      }
      
      public function onRightClick(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_tab0:
            case this.btn_tab1:
            case this.btn_tab2:
            case this.btn_tab3:
               if(!this.checks_ctr.visible)
               {
                  this.uiApi.hideTooltip();
                  this.addChannelsContextMenu(int(param1.name.substr(7,1)));
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:Object = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:Object = null;
         var _loc2_:String = "";
         var _loc5_:String = null;
         var _loc7_:int = 0;
         _loc3_ = 7;
         _loc4_ = 1;
         switch(param1)
         {
            case this.btn_smiley:
               _loc2_ = this.uiApi.getText("ui.chat.smilies");
               _loc5_ = this.bindsApi.getShortcutBindStr("toggleEmotes").toString();
               break;
            case this.btn_plus:
               _loc2_ = this.uiApi.getText("ui.chat.resize.plus");
               _loc5_ = this.bindsApi.getShortcutBindStr("extendChat").toString();
               _loc7_ = 240;
               break;
            case this.btn_minus:
               _loc2_ = this.uiApi.getText("ui.chat.resize.minus");
               _loc5_ = this.bindsApi.getShortcutBindStr("shrinkChat").toString();
               _loc7_ = 240;
               break;
            case this.btn_menu:
               _loc2_ = this.uiApi.getText("ui.option.chat");
               break;
            case this.btn_tab0:
               for each(_loc8_ in this._aTabs[0])
               {
                  _loc6_ = this.dataApi.getChatChannel(_loc8_);
                  _loc2_ = _loc2_ + (_loc6_.name + "\n");
               }
               _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.rightclick.filter"));
               break;
            case this.btn_tab1:
               for each(_loc9_ in this._aTabs[1])
               {
                  _loc6_ = this.dataApi.getChatChannel(_loc9_);
                  _loc2_ = _loc2_ + (_loc6_.name + "\n");
               }
               _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.rightclick.filter"));
               break;
            case this.btn_tab2:
               for each(_loc10_ in this._aTabs[2])
               {
                  _loc6_ = this.dataApi.getChatChannel(_loc10_);
                  _loc2_ = _loc2_ + (_loc6_.name + "\n");
               }
               _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.rightclick.filter"));
               break;
            case this.btn_tab3:
               for each(_loc11_ in this._aTabs[3])
               {
                  _loc6_ = this.dataApi.getChatChannel(_loc11_);
                  _loc2_ = _loc2_ + (_loc6_.name + "\n");
               }
               _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.common.rightclick.filter"));
               break;
            case this.btn_check0:
               _loc2_ = this.uiApi.getText("ui.chat.check0");
               _loc7_ = 400;
               break;
            case this.btn_check1:
               _loc2_ = this.uiApi.getText("ui.chat.check941");
               _loc7_ = 400;
               break;
            case this.btn_check2:
               _loc2_ = this.uiApi.getText("ui.chat.check1011");
               _loc7_ = 400;
               break;
            case this.btn_check3:
               _loc2_ = this.uiApi.getText("ui.chat.check2");
               _loc7_ = 400;
               break;
            case this.btn_check4:
               _loc2_ = this.uiApi.getText("ui.chat.check3");
               _loc7_ = 400;
               break;
            case this.btn_check5:
               _loc2_ = this.uiApi.getText("ui.chat.check5");
               _loc7_ = 400;
               break;
            case this.btn_check6:
               _loc2_ = this.uiApi.getText("ui.chat.check6");
               _loc7_ = 400;
               break;
            case this.btn_check7:
               _loc2_ = this.uiApi.getText("ui.chat.check12");
               _loc7_ = 400;
               break;
            case this.btn_status:
               switch(_currentStatus)
               {
                  case PlayerStatusEnum.PLAYER_STATUS_AFK:
                     if(this._awayMessage != "")
                     {
                        _loc2_ = this.uiApi.getText("ui.chat.status.away") + this.uiApi.getText("ui.common.colon") + this._awayMessage;
                     }
                     else
                     {
                        _loc2_ = this.uiApi.getText("ui.chat.status.away");
                     }
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.idle");
                  case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.private");
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                     _loc2_ = this.uiApi.getText("ui.chat.status.solo");
                     break;
                  case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                     _loc2_ = this.uiApi.getText("ui.chat.status.availiable");
               }
               _loc7_ = 400;
         }
         if(_loc2_ != "")
         {
            if(_loc5_)
            {
               if(!_shortcutColor)
               {
                  _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut");
                  _shortcutColor = _shortcutColor.replace("0x","#");
               }
               _loc12_ = this.uiApi.textTooltipInfo(_loc2_ + " <font color=\'" + _shortcutColor + "\'>(" + _loc5_ + ")</font>",null,null,_loc7_);
            }
            else
            {
               _loc12_ = this.uiApi.textTooltipInfo(_loc2_,null,null,_loc7_);
            }
            this.uiApi.showTooltip(_loc12_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onFocusTimer(param1:Event) : void
      {
         this.inp_tchatinput.focus();
         this._focusTimer.stop();
         this._focusTimer.reset();
      }
      
      private function onChatHyperlink(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = this.chatApi.getStaticHyperlink(param1);
         if(_loc3_ && _loc3_.length > 0)
         {
            if(_loc2_[0] == "{spell" || _loc2_[0] == "{recipe" || _loc2_[0] == "{chatachievement" || _loc2_[0] == "{chatmonster" || _loc2_[0] == "{guild" || _loc2_[0] == "{alliance" || _loc2_[0] == "{chatdare")
            {
               this._aMiscReplacement.push(_loc3_,param1);
            }
            this.inp_tchatinput.appendText(_loc3_ + " ");
            this.inp_tchatinput.focus();
            this.inp_tchatinput.caretIndex = -1;
         }
      }
      
      private function onChatWarning() : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.popup.warningForbiddenLink"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,true,true);
      }
      
      private function onChatLinkRelease(param1:String, param2:Number, param3:String) : void
      {
         this.sysApi.goToCheckLink(param1,param2,param3);
      }
      
      private function onPopupWarning(param1:String, param2:String, param3:uint) : void
      {
         var _loc4_:String = param1 + this.uiApi.getText("ui.common.colon") + param2;
         this.modCommon.openLockedPopup(this.uiApi.getText("ui.popup.warning"),_loc4_,null,false,[param3.toString()],false,true);
      }
      
      private function onMouseShiftClick(param1:Object) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_)
         {
            if(_loc2_ is ShortcutWrapper)
            {
               _loc2_ = (_loc2_ as ShortcutWrapper).realItem;
            }
            if(_loc2_.hasOwnProperty("isPresetObject") && _loc2_.isPresetObject)
            {
               return;
            }
            if(_loc2_ is SmileyWrapper || _loc2_ is EmoteWrapper || _loc2_ is ButtonWrapper || _loc2_ is HavenbagFurnitureWrapper || _loc2_ is MapViewer || _loc2_ is OrnamentWrapper || _loc2_ is EmblemWrapper || _loc2_ is PresetWrapper || _loc2_ is IdolsPresetWrapper)
            {
               return;
            }
            this.onInsertHyperlink(_loc2_,!!param1.hasOwnProperty("params")?param1.params:null);
         }
      }
      
      private function onFocusChange(param1:Object) : void
      {
      }
      
      public function onEmoteEnabledListUpdated(param1:Object) : void
      {
         if(param1.length == 0)
         {
            if(this.uiApi.getUi(UIEnum.SMILEY_UI))
            {
               this.uiApi.unloadUi(UIEnum.SMILEY_UI);
            }
         }
      }
      
      public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:Boolean) : void
      {
         if(param3)
         {
            if(this._sChanLocked == this._sChanLockedBeforeSpec)
            {
               if(this.sysApi.getOption("channelLocked","chat"))
               {
                  this.changeDefaultChannel(this.dataApi.getChatChannel(1).shortcut);
               }
            }
         }
      }
      
      public function onGameFightLeave(param1:Number) : void
      {
         if(param1 == this.playerApi.id() && this._sChanLocked == this.dataApi.getChatChannel(1).shortcut)
         {
            if(this.sysApi.getOption("channelLocked","chat"))
            {
               this.changeDefaultChannel(this.dataApi.getChatChannel(0).shortcut);
            }
         }
      }
      
      private function onInsertRecipeHyperlink(param1:uint) : void
      {
         this.onInsertHyperlink(param1,{"isRecipe":true});
      }
      
      private function onInsertHyperlink(param1:Object, param2:Object = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:String = null;
         var _loc6_:* = false;
         if(param1.hasOwnProperty("objectUID"))
         {
            if(this._aItemReplacement.length >= MAX_CHAT_ITEMS)
            {
               return;
            }
            _loc4_ = "{item," + param1.objectGID + "}";
            _loc3_ = this.chatApi.getStaticHyperlink(_loc4_);
            if(this.inp_tchatinput.length + (_loc3_ + " ").length > this.inp_tchatinput.maxChars)
            {
               return;
            }
            this._aItemReplacement.push(param1);
            _loc6_ = param1.objectUID == 0;
            if(_loc6_)
            {
               this._dGenericItemIndex[param1.objectGID] = param1;
            }
            else
            {
               this._dItemIndex[param1.objectUID] = param1;
            }
            this.inp_tchatinput.addHyperLinkCode("{item," + param1.objectGID + "," + param1.objectUID + "}");
         }
         else
         {
            if(param2 && param2.isRecipe)
            {
               _loc4_ = "{recipe," + param1 + "}";
            }
            else if(param1 is Achievement)
            {
               _loc4_ = "{chatachievement," + param1.id + "}";
            }
            else if(param1 is Monster)
            {
               _loc4_ = "{chatmonster," + param1.id + "}";
            }
            else if(param1 is AllianceWrapper)
            {
               _loc4_ = this.chatApi.getAllianceLink(param1);
            }
            else if(param1 is GuildFactSheetWrapper)
            {
               _loc4_ = this.chatApi.getGuildLink(param1);
            }
            else if(param1.hasOwnProperty("spellLevel"))
            {
               _loc4_ = "{spell," + param1.id + "," + param1.spellLevel + "}";
            }
            else if(param1 == "Map")
            {
               _loc4_ = "{map," + param2.x + "," + param2.y + "," + param2.worldMapId + "," + escape(param2.elementName) + "}";
            }
            else if(param1 == "MonsterGroup")
            {
               _loc4_ = "{monsterGroup," + param2.x + "," + param2.y + "," + param2.worldMapId + "," + escape(param2.monsterName) + "," + param2.infos + "}";
            }
            else if(param1 is DareWrapper)
            {
               _loc4_ = "{chatdare," + param1.dareId + "}";
            }
            _loc3_ = this.chatApi.getStaticHyperlink(_loc4_);
            if(this.inp_tchatinput.length + (_loc3_ + " ").length > this.inp_tchatinput.maxChars)
            {
               return;
            }
            this._aMiscReplacement.push(_loc3_,_loc4_);
         }
         this.inp_tchatinput.appendText(_loc3_ + " ");
         this.inp_tchatinput.focus();
         this.inp_tchatinput.caretIndex = -1;
      }
      
      private function onActivateSmilies() : void
      {
         this.texta_tchat.activeSmilies();
      }
      
      private function autocompleteChat() : void
      {
         var _loc4_:String = null;
         var _loc1_:String = this.inp_tchatinput.text;
         var _loc2_:int = _loc1_.length - 1;
         while(_loc2_ >= 0)
         {
            if(_loc1_.charAt(_loc2_) == " ")
            {
               _loc1_ = _loc1_.substr(0,_loc2_);
               _loc2_--;
               continue;
            }
            break;
         }
         var _loc3_:int = _loc1_.lastIndexOf(" ");
         if(_loc3_ == -1 || _loc1_.substr(0,_loc3_).indexOf(" ") != -1 || _loc1_.charAt(0) != "/")
         {
            return;
         }
         _loc4_ = _loc1_.substr(_loc3_ + 1);
         if(_loc4_.length == 0)
         {
            return;
         }
         if(!this._autocompletionLastCompletion || this._autocompletionLastCompletion != _loc4_)
         {
            this._autocompletionCount = 0;
            this._autocompletionSubString = _loc4_;
         }
         var _loc5_:String = this.chatApi.getAutocompletion(this._autocompletionSubString,this._autocompletionCount);
         if(_loc5_ == null && this._autocompletionCount > 0)
         {
            this._autocompletionCount = 0;
            _loc5_ = this.chatApi.getAutocompletion(this._autocompletionSubString,this._autocompletionCount);
         }
         if(_loc5_ == null)
         {
            return;
         }
         this._autocompletionLastCompletion = _loc5_;
         this._autocompletionCount++;
         this.inp_tchatinput.text = _loc1_.substring(0,_loc3_ + 1) + _loc5_ + " ";
         this.inp_tchatinput.caretIndex = -1;
      }
      
      private function onChatChange(param1:Event) : void
      {
         if(this._delayWaitingMessage)
         {
            param1.target.text = this._lastText;
         }
         else
         {
            this._lastText = param1.target.text;
         }
      }
      
      private function onStatusChange(param1:uint, param2:String = "") : void
      {
         if(param2 == "")
         {
            Api.system.sendAction(new PlayerStatusUpdateRequest(param1));
            this._awayMessage = "";
         }
         else
         {
            Api.system.sendAction(new PlayerStatusUpdateRequest(param1,param2));
            this.onNewAwayMessage(param2);
         }
      }
      
      private function onStatusChangeWithMessage(param1:uint) : void
      {
         var _loc2_:Array = this.sysApi.getData("oldAwayMessage");
         this.modCommon.openInputComboBoxPopup(this.uiApi.getText("ui.popup.status.awaytitle"),this.uiApi.getText("ui.popup.status.awaymessage"),this.uiApi.getText("ui.popup.status.wipeAwayMessageHistory"),this.onSubmitAwayMessage,null,this.onResetAwayMessage,"",null,ProtocolConstantsEnum.USER_MAX_CHAT_LEN,_loc2_);
      }
      
      private function onSubmitAwayMessage(param1:String) : void
      {
         this.onStatusChange(PlayerStatusEnum.PLAYER_STATUS_AFK,param1);
      }
      
      private function onResetAwayMessage() : void
      {
         this.sysApi.setData("oldAwayMessage",[]);
      }
      
      private function onPlayerStatusUpdate(param1:uint, param2:Number, param3:uint, param4:String) : void
      {
         var _loc5_:String = null;
         if(param2 == this.playerApi.id())
         {
            switch(param3)
            {
               case PlayerStatusEnum.PLAYER_STATUS_AVAILABLE:
                  this.iconTexturebtn_status.uri = this.uiApi.createUri(this._iconsPath + "green.png");
                  _loc5_ = this.uiApi.getText("ui.chat.status.availiable");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_AFK:
                  if(param4 != "")
                  {
                     this._awayMessage = param4;
                  }
               case PlayerStatusEnum.PLAYER_STATUS_IDLE:
                  this.iconTexturebtn_status.uri = this.uiApi.createUri(this._iconsPath + "yellow.png");
                  _loc5_ = this.uiApi.getText("ui.chat.status.away");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_PRIVATE:
                  this.iconTexturebtn_status.uri = this.uiApi.createUri(this._iconsPath + "blue.png");
                  _loc5_ = this.uiApi.getText("ui.chat.status.private");
                  break;
               case PlayerStatusEnum.PLAYER_STATUS_SOLO:
                  this.iconTexturebtn_status.uri = this.uiApi.createUri(this._iconsPath + "red.png");
                  _loc5_ = this.uiApi.getText("ui.chat.status.solo");
            }
            if(param3 != PlayerStatusEnum.PLAYER_STATUS_IDLE)
            {
               _currentStatus = param3;
            }
            this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.chat.status.statuschange",[_loc5_]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,this.timeApi.getTimestamp());
         }
      }
      
      private function onNewAwayMessage(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1 != "")
         {
            _loc2_ = this.sysApi.getData("oldAwayMessage");
            if(!_loc2_)
            {
               _loc2_ = new Array();
            }
            else if(_loc2_.length > 10)
            {
               _loc2_.pop();
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_] == param1)
               {
                  _loc2_.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc2_.unshift(param1);
         }
         this.sysApi.setData("oldAwayMessage",_loc2_);
      }
      
      private function onInactivityNotification(param1:Boolean) : void
      {
         if(param1 && _currentStatus != PlayerStatusEnum.PLAYER_STATUS_AFK && !this._idle)
         {
            this._idle = true;
            this.onStatusChange(PlayerStatusEnum.PLAYER_STATUS_IDLE);
         }
         else if(!param1 && this._idle)
         {
            this._idle = false;
            this.onStatusChange(_currentStatus,this._awayMessage);
         }
      }
      
      private function trim(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length && (param1.charAt(_loc2_) == " " || param1.charAt(_loc2_) == "\n" || param1.charAt(_loc2_) == "\t" || param1.charAt(_loc2_) == "\r"))
         {
            _loc2_++;
         }
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0 && (param1.charAt(_loc3_) == " " || param1.charAt(_loc3_) == "\n" || param1.charAt(_loc3_) == "\t" || param1.charAt(_loc3_) == "\r"))
         {
            _loc3_--;
         }
         if(_loc3_ - _loc2_ == 0)
         {
            return "";
         }
         return param1.substring(_loc2_,_loc3_ + 1);
      }
   }
}

class TabCache
{
    
   
   public var text:String = "";
   
   public var numLines:uint;
   
   public var needUpdate:Boolean;
   
   function TabCache()
   {
      super();
   }
}
