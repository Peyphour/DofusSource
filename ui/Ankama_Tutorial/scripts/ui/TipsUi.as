package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.ArenaFightAnswer;
   import d2actions.HavenbagInvitePlayerAnswer;
   import d2actions.JoinFightRequest;
   import d2actions.NotificationUpdateFlag;
   import d2actions.OpenBook;
   import d2actions.OpenSmileys;
   import d2actions.PartyAcceptInvitation;
   import d2actions.PartyInvitationDetailsRequest;
   import d2actions.PartyRefuseInvitation;
   import d2actions.SurveyNotificationAnswer;
   import d2actions.TeleportToBuddyAnswer;
   import d2enums.NotificationTypeEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.CharacterLevelUp;
   import d2hooks.CloseNotification;
   import d2hooks.CreaturesMode;
   import d2hooks.FightResultVictory;
   import d2hooks.FightSpellCast;
   import d2hooks.FoldAll;
   import d2hooks.GameFightStart;
   import d2hooks.GameFightStarting;
   import d2hooks.GameRolePlayPlayerLifeStatus;
   import d2hooks.GameStart;
   import d2hooks.HideNotification;
   import d2hooks.LifePointsRegenBegin;
   import d2hooks.MapWithMonsters;
   import d2hooks.Notification;
   import d2hooks.NpcDialogCreation;
   import d2hooks.OpenGrimoireAlignmentTab;
   import d2hooks.OpenGrimoireCalendarTab;
   import d2hooks.OpenGrimoireJobTab;
   import d2hooks.OpenGrimoireQuestTab;
   import d2hooks.OpenGrimoireSpellTab;
   import d2hooks.OpenInventory;
   import d2hooks.OpenSocial;
   import d2hooks.OpenStats;
   import d2hooks.PlayerFightMove;
   import d2hooks.PlayerIsDead;
   import d2hooks.PlayerMove;
   import d2hooks.PlayerNewSpell;
   import flash.display.Shape;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.system.ApplicationDomain;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   
   public class TipsUi
   {
      
      private static const MAX_VISIBLE_NOTIFICATION:uint = 3;
      
      private static const PADDING_BOTTOM:uint = 15;
      
      private static const NOTIFICATION_HEIGHT:uint = 55;
      
      private static const LUMINOSITY_EFFECTS:Array = [new ColorMatrixFilter([1.4,0,0,0,0,0,1.4,0,0,0,0,0,1.4,0,0,0,0,0,1,0])];
      
      private static const CTR_TEXT_MARGIN_TOP:uint = 0;
      
      private static const BACKGROUND_MESSAGE_GEIGHT_ADDITION:uint = 15;
      
      private static var QUIET_MODE:Boolean = true;
       
      
      private var _include_action_PartyAction:PartyInvitationDetailsRequest;
      
      private var _include_action_PartyAcceptInvitation:PartyAcceptInvitation;
      
      private var _include_action_ArenaFightAnswer:ArenaFightAnswer;
      
      private var _include_action_TeleportToBuddyAnswer:TeleportToBuddyAnswer;
      
      private var _include_action_OpenSmileys:d2actions.OpenSmileys;
      
      private var _include_action_OpenBook:d2actions.OpenBook;
      
      private var _include_action_PartyRefuseInvitation:PartyRefuseInvitation;
      
      private var _include_action_NotificationUpdateFlag:NotificationUpdateFlag;
      
      private var _include_action_JoinFightRequest:JoinFightRequest;
      
      private var _include_action_HavenbagInvitePlayerAnswer:HavenbagInvitePlayerAnswer;
      
      private var _include_action_SurveyNotificationAnswer:SurveyNotificationAnswer;
      
      private var _include_hook_MapWithMonsters:MapWithMonsters;
      
      private var _include_hook_FightResultVictory:FightResultVictory;
      
      private var _include_hook_GameStart:GameStart;
      
      private var _include_hook_NpcDialogCreation:NpcDialogCreation;
      
      private var _include_hook_PlayerMove:PlayerMove;
      
      private var _include_hook_GameFightStart:GameFightStart;
      
      private var _include_hook_GameFightStarting:GameFightStarting;
      
      private var _include_hook_PlayerFightMove:PlayerFightMove;
      
      private var _include_hook_FightSpellCast:FightSpellCast;
      
      private var _include_hook_CharacterLevelUp:CharacterLevelUp;
      
      private var _include_hook_PlayerNewSpell:PlayerNewSpell;
      
      private var _include_hook_PlayerIsDead:PlayerIsDead;
      
      private var _include_hook_GameRolePlayPlayerLifeStatus:GameRolePlayPlayerLifeStatus;
      
      private var _include_hook_OpenInventory:OpenInventory;
      
      private var _include_hook_OpenStats:OpenStats;
      
      private var _include_hook_OpenBook:d2hooks.OpenBook;
      
      private var _include_hook_OpenGrimoireSpellTab:OpenGrimoireSpellTab;
      
      private var _include_hook_OpenGrimoireQuestTab:OpenGrimoireQuestTab;
      
      private var _include_hook_OpenGrimoireAlignmentTab:OpenGrimoireAlignmentTab;
      
      private var _include_hook_OpenGrimoireJobTab:OpenGrimoireJobTab;
      
      private var _include_hook_OpenGrimoireCalendarTab:OpenGrimoireCalendarTab;
      
      private var _include_hook_CreaturesMode:CreaturesMode;
      
      private var _include_hook_OpenSmileys:d2hooks.OpenSmileys;
      
      private var _include_hook_LifePointsRegenBegin:LifePointsRegenBegin;
      
      private var _include_hook_AddMapFlag:AddMapFlag;
      
      private var _include_hook_OpenSocial:OpenSocial;
      
      private var _enabled:Boolean = true;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var soundApi:SoundApi;
      
      public var dataApi:DataApi;
      
      public var highlightApi:HighlightApi;
      
      public var questApi:QuestApi;
      
      public var ctr_main:GraphicContainer;
      
      public var ctr_visible:GraphicContainer;
      
      public var ctr_tips:GraphicContainer;
      
      public var ctr_text:GraphicContainer;
      
      public var ctr_down:GraphicContainer;
      
      public var ctr_nocheat:GraphicContainer;
      
      public var ctr_effect:GraphicContainer;
      
      public var mask_tips:GraphicContainer;
      
      public var btn_hide:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var ctr_background_message:GraphicContainer;
      
      public var tx_minMax:Texture;
      
      public var lbl_message:Label;
      
      public var lbl_title_message:Label;
      
      public var lbl_down:Label;
      
      private var _tipsList:Array;
      
      private var _currentTips:NotificationWrapper;
      
      private var _timerSlide:Timer;
      
      private var _btnListDisplay:Array;
      
      private var _imgListDisplay:Array;
      
      private var _noCheatTimer:Timer;
      
      private var _notificationsDisabled:Object;
      
      private var _contextualTipsList:Object;
      
      private var _triggersInit:Boolean = false;
      
      private var _tmpTimer:int = 0;
      
      public function TipsUi()
      {
         this._tipsList = new Array();
         this._timerSlide = new Timer(200,1);
         this._btnListDisplay = new Array();
         this._imgListDisplay = new Array();
         this._noCheatTimer = new Timer(1000,1);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this.sysApi.addHook(Notification,this.onNewNotification);
         this.sysApi.addHook(CloseNotification,this.onCloseNotification);
         this.sysApi.addHook(HideNotification,this.onHideNotification);
         this.uiApi.addComponentHook(this.lbl_message,"onTextClick");
         this.uiApi.addComponentHook(this.ctr_nocheat,"onRelease");
         this.uiApi.addComponentHook(this.ctr_visible,"onRollOver");
         this.uiApi.addComponentHook(this.ctr_visible,"onRollOut");
         this.ctr_tips.mask = this.mask_tips;
         this.checkQuietMode();
         this._timerSlide.addEventListener(TimerEvent.TIMER,this.showMessage);
         this._noCheatTimer.addEventListener(TimerEvent.TIMER,this.closeNoCheatContainer);
         if(param1 && param1[0])
         {
            this.forceNewNotification(param1[0]);
         }
      }
      
      public function checkQuietMode() : void
      {
         var _loc1_:* = !this.sysApi.getOption("showNotifications","dofus");
         if(_loc1_ == QUIET_MODE)
         {
            return;
         }
         QUIET_MODE = _loc1_;
         this._contextualTipsList = this.dataApi.getNotifications();
         this._notificationsDisabled = this.questApi.getNotificationList();
         if(this._notificationsDisabled)
         {
            this._triggersInit = false;
         }
         if(_loc1_)
         {
            this.clearAllNotification(NotificationTypeEnum.TUTORIAL);
         }
         else if(!this._triggersInit)
         {
            this.initContextualHelpTriggers();
         }
      }
      
      public function resetTips(param1:Object) : void
      {
         this._notificationsDisabled = param1;
         this.clearAllNotification(NotificationTypeEnum.TUTORIAL);
         this.initContextualHelpTriggers();
      }
      
      private function addNewNotification(param1:NotificationWrapper) : void
      {
         if(QUIET_MODE && param1.type == NotificationTypeEnum.TUTORIAL)
         {
            return;
         }
         if(!this._enabled)
         {
            this.sendCallback(param1);
            return;
         }
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         if(!this.ctr_effect)
         {
            return;
         }
         this.ctr_effect.visible = true;
         this.btn_hide.visible = true;
         var _loc2_:NotificationWrapper = this.getNotificationByName(param1.name);
         if(_loc2_ != null)
         {
            if(_loc2_.refreshWithoutCallback)
            {
               this.removeNotification(_loc2_,true);
            }
            else
            {
               this.removeNotification(_loc2_);
            }
         }
         this._tipsList = this.sortByPriority(this._tipsList,param1);
         this.updateVisibleNotification();
      }
      
      private function sortByPriority(param1:Array, param2:NotificationWrapper = null) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            if(_loc3_[_loc4_.type] == null)
            {
               _loc3_[_loc4_.type] = new Array();
            }
            _loc3_[_loc4_.type].push(_loc4_);
         }
         _loc5_ = new Array();
         for each(_loc6_ in NotificationTypeEnum.NOTIFICATION_PRIORITY)
         {
            if(_loc3_[_loc6_])
            {
               if(param2 != null && param2.type == _loc6_)
               {
                  _loc5_.push(param2);
               }
               _loc5_ = _loc5_.concat(_loc3_[_loc6_]);
            }
            else if(_loc6_ == param2.type)
            {
               _loc5_.push(param2);
            }
         }
         _loc3_ = null;
         param1 = null;
         return _loc5_.concat();
      }
      
      private function removeNotification(param1:NotificationWrapper, param2:Boolean = false) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!param2)
         {
            this.sendCallback(param1);
         }
         if(param1.maskTimer)
         {
            param1.texture.removeChild(param1.maskTimer);
         }
         if(param1.tutorialId > 0)
         {
            this.sysApi.sendAction(new NotificationUpdateFlag(param1.tutorialId));
         }
         if(param1 == this._currentTips)
         {
            this.ctr_text.visible = false;
            this._currentTips = null;
            this.clearContainer();
         }
         this.ctr_tips.removeChild(param1.texture);
         this._tipsList.splice(this._tipsList.indexOf(param1),1);
         param1.texture = null;
         param1 = null;
         if(this._tipsList.length <= 0)
         {
            this.ctr_effect.visible = false;
            this.ctr_visible.visible = false;
         }
         this.uiApi.hideTooltip();
         this._tmpTimer = 0;
         this.updateVisibleNotification();
         this.updateUi();
      }
      
      private function sendCallback(param1:NotificationWrapper) : Boolean
      {
         var _loc2_:Class = null;
         var _loc3_:Object = null;
         if(param1.callback)
         {
            if(param1.callbackType == "hook")
            {
               _loc2_ = getDefinitionByName("d2hook." + param1.callback) as Class;
               this.sysApi.dispatchHook(_loc2_,param1.callbackParams);
            }
            else if(param1.callbackType == "action")
            {
               _loc3_ = this.utilApi.callConstructorWithParameters(getDefinitionByName("d2actions." + param1.callback) as Class,param1.callbackParams);
               this.sysApi.sendAction(_loc3_);
            }
            return true;
         }
         return false;
      }
      
      private function updateVisibleNotification() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:NotificationWrapper = null;
         var _loc4_:Boolean = false;
         var _loc1_:Boolean = true;
         _loc2_ = 0;
         while(_loc2_ < this._tipsList.length)
         {
            _loc3_ = this._tipsList[_loc2_];
            if(_loc2_ < MAX_VISIBLE_NOTIFICATION)
            {
               if(_loc3_.texture == null)
               {
                  this.createNotificationTexture(_loc3_);
                  _loc4_ = this.initTimer(_loc3_);
                  if(_loc4_)
                  {
                     _loc1_ = true;
                  }
               }
               else
               {
                  _loc3_.texture.visible = true;
                  this.ctr_tips.addChild(_loc3_.texture);
                  this.slide(_loc3_.texture,0,_loc2_ * NOTIFICATION_HEIGHT,500);
                  if(_loc3_ == this._currentTips)
                  {
                     this.slide(this.ctr_text,this.ctr_text.x,CTR_TEXT_MARGIN_TOP + _loc2_ * NOTIFICATION_HEIGHT,500);
                  }
               }
            }
            else if(_loc3_ == this._currentTips)
            {
               this.ctr_text.visible = false;
               _loc3_.texture.filters = null;
               _loc3_.texture.visible = false;
               this._currentTips = null;
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(this._currentTips == null && _loc1_)
         {
            this._currentTips = this._tipsList[0];
            this.showMessage();
         }
      }
      
      private function initTimer(param1:NotificationWrapper) : Boolean
      {
         var _loc2_:Shape = null;
         if(param1.hasTimer && !param1.startTime)
         {
            if(param1.texture)
            {
               _loc2_ = new Shape();
               _loc2_.graphics.beginFill(0,0.6);
               _loc2_.graphics.drawRect(0,0,param1.texture.width,param1.texture.height);
               _loc2_.graphics.endFill();
               param1.maskTimer = _loc2_;
               param1.texture.addChild(_loc2_);
            }
            param1.startTime = getTimer();
            this.sysApi.addEventListener(this.updateTimer,"timerComplete");
            return true;
         }
         return false;
      }
      
      private function openNotification(param1:uint) : void
      {
         if(param1 != this._tipsList.indexOf(this._currentTips))
         {
            this.hideNotification(this._currentTips);
         }
      }
      
      private function hideNotification(param1:Object) : void
      {
         if(param1 == null || param1.texture == null)
         {
            return;
         }
         param1.texture.filters = null;
         if(param1 == this._currentTips)
         {
            this._currentTips = null;
         }
         if(this.ctr_text.visible)
         {
            this.ctr_text.visible = false;
         }
      }
      
      private function getNotificationByName(param1:String) : NotificationWrapper
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._tipsList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._tipsList[_loc2_].name == param1)
            {
               return this._tipsList[_loc2_];
            }
            _loc2_ = _loc2_ + 1;
         }
         return null;
      }
      
      private function getNotificationData(param1:Texture) : NotificationWrapper
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._tipsList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._tipsList[_loc2_].texture != null && this._tipsList[_loc2_].texture == param1)
            {
               return this._tipsList[_loc2_];
            }
            _loc2_ = _loc2_ + 1;
         }
         return null;
      }
      
      private function hideAll() : void
      {
         this.ctr_visible.visible = false;
         this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
      }
      
      private function showAll() : void
      {
         this.ctr_visible.visible = true;
         this.tx_minMax.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
      }
      
      private function showMessage(param1:TimerEvent = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._currentTips == null || this.ctr_text == null)
         {
            return;
         }
         this.clearContainer();
         this.ctr_text.visible = true;
         this.ctr_effect.visible = true;
         this.lbl_message.height = 0;
         this.lbl_title_message.height = 0;
         this.ctr_background_message.height = 0;
         this.lbl_title_message.text = this._currentTips.title;
         this.lbl_message.text = this._currentTips.contentText;
         this.lbl_title_message.selectable = this._currentTips.type == NotificationTypeEnum.ERROR;
         this.lbl_message.selectable = this._currentTips.type == NotificationTypeEnum.ERROR;
         this.lbl_title_message.fullSize(300);
         this.lbl_message.fullSize(300);
         this.ctr_background_message.height = this.lbl_message.textHeight + this.lbl_title_message.y + this.lbl_title_message.textHeight + PADDING_BOTTOM + BACKGROUND_MESSAGE_GEIGHT_ADDITION;
         this.slide(this.ctr_text,this.ctr_text.x,CTR_TEXT_MARGIN_TOP + this._tipsList.indexOf(this._currentTips) * NOTIFICATION_HEIGHT,0);
         this._currentTips.texture.filters = LUMINOSITY_EFFECTS;
         if(this._currentTips.imageList && this._currentTips.imageList.length > 0)
         {
            _loc3_ = this._currentTips.imageList.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.addImageToContainer(this._currentTips.imageList[_loc2_]);
               _loc2_++;
            }
         }
         if(this._currentTips.buttonList && this._currentTips.buttonList.length > 0)
         {
            _loc3_ = this._currentTips.buttonList.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.addBtnToContainer(this._currentTips.buttonList[_loc2_],_loc2_);
               _loc2_++;
            }
            this.ctr_background_message.height = this.ctr_background_message.height + (this._currentTips.buttonList[0].height + 10 + BACKGROUND_MESSAGE_GEIGHT_ADDITION);
         }
         this.updateUi();
      }
      
      private function startAnim(param1:NotificationWrapper) : void
      {
         this._timerSlide.reset();
         var _loc2_:uint = this._tipsList.indexOf(param1);
         this.slide(param1.texture,0,_loc2_ * NOTIFICATION_HEIGHT,500);
         if(_loc2_ + 1 >= MAX_VISIBLE_NOTIFICATION)
         {
            param1.texture.visible = false;
            if(param1 == this._currentTips)
            {
               this._currentTips = null;
               this.ctr_visible.visible = false;
            }
         }
         else if(param1 == this._currentTips)
         {
            this._timerSlide.start();
         }
         else
         {
            this.updateUi();
         }
      }
      
      private function clearAllNotification(param1:int = -1) : void
      {
         var _loc3_:NotificationWrapper = null;
         var _loc2_:Array = this._tipsList.concat();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.type == param1 || param1 == -1)
            {
               if(_loc3_ == this._currentTips)
               {
                  this.ctr_text.visible = false;
               }
               this.removeNotification(_loc3_);
            }
         }
         if(param1 == NotificationTypeEnum.TUTORIAL)
         {
            this.clearTutorialTriggers();
         }
      }
      
      private function getVisibleNotificationNumber() : uint
      {
         return this._tipsList.length > MAX_VISIBLE_NOTIFICATION?uint(MAX_VISIBLE_NOTIFICATION):uint(this._tipsList.length);
      }
      
      private function slide(param1:GraphicContainer, param2:Number, param3:Number, param4:uint = 500) : void
      {
         param1.y = param3;
         param1.x = param2;
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         if(this._tipsList.length == 0)
         {
            return;
         }
         if(param1)
         {
            this.hideAll();
         }
         else
         {
            this.showAll();
         }
      }
      
      private function onNewNotification(param1:Object) : void
      {
         this.addNewNotification(NotificationWrapper.create(param1));
      }
      
      private function onCloseNotification(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:NotificationWrapper = this.getNotificationByName(param1);
         if(_loc3_ != null)
         {
            this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
            this.removeNotification(_loc3_,param2);
         }
      }
      
      private function onHideNotification(param1:String) : void
      {
         this.hideNotification(this.getNotificationByName(param1));
      }
      
      private function updateTimer() : void
      {
         var _loc1_:NotificationWrapper = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         for each(_loc1_ in this._tipsList)
         {
            if(_loc1_.duration > 0)
            {
               if(!(this._currentTips == _loc1_ && this._tmpTimer > 0))
               {
                  _loc2_ = getTimer();
                  _loc3_ = _loc1_.startTime + _loc1_.duration;
                  if(_loc2_ > _loc3_)
                  {
                     this.removeNotification(_loc1_,_loc1_.blockCallbackOnTimerEnds);
                  }
                  else
                  {
                     _loc4_ = (_loc2_ - _loc1_.startTime) / (_loc3_ - _loc1_.startTime);
                     _loc1_.maskTimer.height = _loc1_.texture.height * _loc4_;
                     _loc1_.maskTimer.y = _loc1_.texture.height - _loc1_.maskTimer.height;
                  }
               }
            }
         }
         if(this._tipsList.length == 0)
         {
            this.sysApi.removeEventListener(this.updateTimer);
         }
      }
      
      private function closeNoCheatContainer(param1:TimerEvent) : void
      {
         this.ctr_nocheat.visible = false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:NotificationWrapper = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Class = null;
         switch(param1)
         {
            case this.btn_close:
               this.ctr_nocheat.visible = true;
               this._noCheatTimer.reset();
               this._noCheatTimer.start();
               this.removeNotification(this._currentTips);
               break;
            case this.btn_hide:
               if(this.ctr_visible.visible)
               {
                  this.hideAll();
               }
               else
               {
                  this.showAll();
               }
               break;
            case this.ctr_nocheat:
               return;
            default:
               if(this._btnListDisplay.indexOf(param1) != -1)
               {
                  _loc3_ = this._currentTips.buttonList[this._btnListDisplay.indexOf(param1)];
                  if(_loc3_.actionType == "action")
                  {
                     _loc4_ = this.utilApi.callConstructorWithParameters(getDefinitionByName("d2actions." + _loc3_.action) as Class,_loc3_.params);
                     this.sysApi.sendAction(_loc4_);
                  }
                  else if(_loc3_.actionType == "hook")
                  {
                     _loc5_ = getDefinitionByName("d2hooks." + _loc3_.action) as Class;
                     switch(_loc3_.params.length)
                     {
                        case 1:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0]);
                           break;
                        case 2:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1]);
                           break;
                        case 3:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1],_loc3_.params[2]);
                           break;
                        case 4:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1],_loc3_.params[2],_loc3_.params[3]);
                           break;
                        case 5:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1],_loc3_.params[2],_loc3_.params[3],_loc3_.params[4]);
                           break;
                        case 6:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1],_loc3_.params[2],_loc3_.params[3],_loc3_.params[4],_loc3_.params[5]);
                           break;
                        case 7:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1],_loc3_.params[2],_loc3_.params[3],_loc3_.params[4],_loc3_.params[5],_loc3_.params[6]);
                           break;
                        case 8:
                           this.sysApi.dispatchHook(_loc5_,_loc3_.params[0],_loc3_.params[1],_loc3_.params[2],_loc3_.params[3],_loc3_.params[4],_loc3_.params[5],_loc3_.params[6],_loc3_.params[7]);
                     }
                  }
                  if(_loc3_.forceClose)
                  {
                     this.removeNotification(this._currentTips,true);
                  }
                  return;
               }
               _loc2_ = this.getNotificationData(param1 as Texture);
               if(_loc2_)
               {
                  if(_loc2_ != this._currentTips)
                  {
                     this.uiApi.hideTooltip();
                     if(this._currentTips != null)
                     {
                        this.hideNotification(this._currentTips);
                     }
                     this._currentTips = _loc2_;
                     this.showMessage();
                  }
                  else
                  {
                     this.hideNotification(_loc2_);
                  }
                  return;
               }
               break;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:NotificationWrapper = null;
         var _loc3_:Object = null;
         if(param1 == this.ctr_visible)
         {
            if(this._currentTips != null && this._currentTips.duration > 0 && this._currentTips.pauseOnOver && this._tmpTimer == 0)
            {
               this._tmpTimer = getTimer();
            }
         }
         else
         {
            _loc2_ = this.getNotificationData(param1 as Texture);
            if(_loc2_)
            {
               if(_loc2_ != this._currentTips)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_.title),param1,false,"standard",3,5,3,null,null,null,"TextInfo");
               }
            }
            else if(this._currentTips && this._imgListDisplay.indexOf(param1) != -1)
            {
               _loc3_ = this._currentTips.imageList[this._imgListDisplay.indexOf(param1)];
               if(_loc3_)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_.tips),param1,false,"standard",3,5,3,null,null,null,"TextInfo");
               }
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         switch(param1)
         {
            case this.ctr_visible:
               if(this._currentTips != null && this._currentTips.duration > 0 && this._currentTips.pauseOnOver)
               {
                  this._currentTips.startTime = this._currentTips.startTime + (getTimer() - this._tmpTimer);
                  this._tmpTimer = 0;
               }
               break;
            default:
               this.uiApi.hideTooltip();
         }
      }
      
      public function onMiddleClick(param1:Object) : void
      {
         var _loc2_:NotificationWrapper = this.getNotificationData(param1 as Texture);
         if(_loc2_)
         {
            this.removeNotification(_loc2_);
         }
      }
      
      public function onTextClick(param1:Object, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         if(param1 == this.lbl_message)
         {
            if(param2.indexOf("sendaction") == 0)
            {
               _loc3_ = param2.split(",");
               _loc3_.splice(0,2);
               _loc4_ = this.utilApi.callConstructorWithParameters(getDefinitionByName("d2actions." + _loc3_[1]) as Class,_loc3_);
               this.sysApi.sendAction(_loc4_);
            }
         }
      }
      
      public function forceNewNotification(param1:Object) : void
      {
         this.onNewNotification(param1);
      }
      
      private function createNotificationTexture(param1:NotificationWrapper) : void
      {
         this.ctr_main.visible = true;
         this.ctr_visible.visible = true;
         this.ctr_tips.visible = true;
         this.btn_hide.visible = true;
         var _loc2_:Texture = this.uiApi.createComponent("Texture") as Texture;
         _loc2_.name = "tips" + this._tipsList.indexOf(param1);
         _loc2_.mouseEnabled = true;
         _loc2_.cacheAsBitmap = true;
         _loc2_.buttonMode = true;
         _loc2_.useHandCursor = true;
         var _loc3_:int = param1.type;
         if(_loc3_ == NotificationTypeEnum.SERVER_INFORMATION)
         {
            _loc3_ = NotificationTypeEnum.TUTORIAL;
         }
         _loc2_.uri = this.uiApi.createUri(this.uiApi.me().getConstant("assets") + "tips_icon" + _loc3_);
         this.uiApi.addComponentHook(_loc2_,"onRelease");
         this.uiApi.addComponentHook(_loc2_,"onRollOver");
         this.uiApi.addComponentHook(_loc2_,"onRollOut");
         this.uiApi.addComponentHook(_loc2_,"onMiddleClick");
         _loc2_.finalize();
         param1.texture = _loc2_;
         this.ctr_tips.addChild(_loc2_);
         _loc2_.visible = true;
         _loc2_.y = 25 + this.getVisibleNotificationNumber() * NOTIFICATION_HEIGHT + 10;
         _loc2_.x = 0;
         if(this._tipsList.length == 1)
         {
            this._currentTips = param1;
         }
         this.startAnim(param1);
      }
      
      private function addBtnToContainer(param1:Object, param2:int) : void
      {
         var _loc3_:ButtonContainer = null;
         var _loc4_:TextureBitmap = null;
         var _loc5_:Label = null;
         var _loc6_:uint = this.uiApi.me().getConstant("buttonPadding");
         var _loc7_:uint = this.uiApi.me().getConstant("buttonMarginTop");
         var _loc8_:uint = this.uiApi.me().getConstant("buttonSideMargin");
         var _loc9_:int = this._currentTips.buttonList.length;
         _loc3_ = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
         _loc3_.width = param1.width;
         _loc3_.height = param1.height;
         _loc3_.x = (this.ctr_background_message.width - param1.width * _loc9_ - _loc6_ * _loc9_) / 2 + (param1.width + _loc6_) * param2 + _loc8_;
         _loc3_.y = this.ctr_background_message.height;
         _loc3_.name = param1.name;
         _loc3_.finalize();
         _loc4_ = this.uiApi.createComponent("TextureBitmap") as TextureBitmap;
         _loc4_.width = param1.width;
         _loc4_.height = param1.height;
         _loc4_.themeDataId = "button_normal";
         _loc4_.name = _loc3_.name + "_tx";
         _loc4_.finalize();
         _loc5_ = this.uiApi.createComponent("Label") as Label;
         _loc5_.width = param1.width;
         _loc5_.height = param1.height;
         _loc5_.verticalAlign = "center";
         _loc5_.css = this.uiApi.createUri(this.uiApi.me().getConstant("btn.css"));
         _loc5_.text = this.uiApi.replaceKey(param1.label);
         var _loc10_:Array = new Array();
         _loc10_[1] = new Array();
         _loc10_[1][_loc4_.name] = new Array();
         _loc10_[1][_loc4_.name]["themeDataId"] = "button_over";
         _loc10_[2] = new Array();
         _loc10_[2][_loc4_.name] = new Array();
         _loc10_[2][_loc4_.name]["themeDataId"] = "button_pressed";
         _loc3_.changingStateData = _loc10_;
         _loc3_.addChild(_loc4_);
         _loc3_.addChild(_loc5_);
         this.uiApi.addComponentHook(_loc3_,"onRelease");
         this._btnListDisplay.push(_loc3_);
         this.ctr_text.addChild(_loc3_);
      }
      
      private function addImageToContainer(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Label = null;
         var _loc2_:Texture = this.uiApi.createComponent("Texture") as Texture;
         _loc2_.uri = param1.uri;
         if(param1.width > 0)
         {
            _loc2_.width = param1.width;
         }
         if(param1.height > 0)
         {
            _loc2_.height = param1.height;
         }
         if(param1.horizontalAlign)
         {
            _loc2_.x = (this.ctr_background_message.width - _loc2_.width) / 2;
         }
         else
         {
            _loc2_.x = _loc2_.width / 2 + 5;
         }
         if(param1.verticalAlign)
         {
            _loc3_ = 10;
            _loc4_ = this._imgListDisplay.indexOf(param1);
            _loc2_.y = this.lbl_message.height + this.lbl_message.y + (_loc4_ > 0?this._imgListDisplay[this._imgListDisplay.indexOf(param1) - 1].y + this._imgListDisplay[this._imgListDisplay.indexOf(param1) - 1].height + _loc3_:1);
         }
         else
         {
            _loc2_.y = param1.y;
         }
         if(param1.tips != "")
         {
            _loc2_.buttonMode = true;
            this.uiApi.addComponentHook(_loc2_,"onRollOver");
            this.uiApi.addComponentHook(_loc2_,"onRollOut");
         }
         _loc2_.finalize();
         this.ctr_background_message.height = this.ctr_background_message.height + (_loc2_.height + _loc3_ + BACKGROUND_MESSAGE_GEIGHT_ADDITION);
         if(param1.label != "")
         {
            _loc5_ = this.uiApi.createComponent("Label") as Label;
            _loc5_.text = param1.label;
            _loc5_.css = this.uiApi.createUri(this.uiApi.me().getConstant("css") + "normal.css");
            _loc5_.x = _loc2_.x + _loc2_.contentWidth / 2;
            _loc5_.y = (_loc2_.contentHeight - _loc5_.textHeight) / 2;
            _loc2_.addChild(_loc5_);
         }
         this._imgListDisplay.push(_loc2_);
         this.ctr_text.addChild(_loc2_);
      }
      
      private function clearContainer() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         for each(_loc1_ in this._btnListDisplay)
         {
            this.ctr_text.removeChild(_loc1_);
         }
         this._btnListDisplay = new Array();
         for each(_loc2_ in this._imgListDisplay)
         {
            this.ctr_text.removeChild(_loc2_);
         }
         this._imgListDisplay = new Array();
      }
      
      private function updateUi() : void
      {
         var _loc1_:uint = 0;
         if(this._tipsList.length > 0)
         {
            _loc1_ = 25 + this.getVisibleNotificationNumber() * NOTIFICATION_HEIGHT;
            this.ctr_down.y = _loc1_;
            this.mask_tips.height = _loc1_;
         }
         this.lbl_down.text = this._tipsList.length.toString();
         this.uiApi.me().render();
      }
      
      private function initContextualHelpTriggers() : void
      {
         var _loc1_:Function = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         for each(_loc2_ in this._contextualTipsList)
         {
            if(_loc2_.trigger && !this._notificationsDisabled[_loc2_.id])
            {
               _loc3_ = this.getHookName(_loc2_.trigger);
               if(ApplicationDomain.currentDomain.hasDefinition(_loc3_))
               {
                  _loc1_ = this.createHook(_loc2_.title,_loc2_.message,"contextualHelp_" + _loc2_.id,_loc3_,_loc2_.id);
                  this.sysApi.addHook(getDefinitionByName(_loc3_) as Class,_loc1_);
                  if(_loc3_ == "d2hooks.GameStart")
                  {
                     _loc1_();
                  }
               }
               else
               {
                  this.sysApi.log(1,"Impossible d\'écouter le hook " + _loc3_ + " pour l\'interface de tips (hook non existant)");
               }
            }
         }
         this._triggersInit = true;
      }
      
      private function getHookName(param1:String) : String
      {
         var _loc2_:Array = param1.split(",");
         return "d2hooks." + _loc2_[0];
      }
      
      private function createHook(param1:String, param2:String, param3:String, param4:String, param5:int) : Function
      {
         var pTitle:String = param1;
         var pMessage:String = param2;
         var pName:String = param3;
         var pHookName:String = param4;
         var pId:int = param5;
         return function(... rest):void
         {
            var _loc2_:* = new Object();
            _loc2_.title = pTitle;
            _loc2_.contentText = pMessage;
            _loc2_.name = pName;
            _loc2_.type = NotificationTypeEnum.TUTORIAL;
            _loc2_.tutorialId = pId;
            forceNewNotification(_loc2_);
            sysApi.removeHook(getDefinitionByName(pHookName) as Class);
         };
      }
      
      private function clearTutorialTriggers() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         for each(_loc1_ in this._contextualTipsList)
         {
            if(_loc1_.trigger)
            {
               _loc2_ = this.getHookName(_loc1_.trigger);
               if(ApplicationDomain.currentDomain.hasDefinition(_loc2_))
               {
                  this.sysApi.removeHook(getDefinitionByName(_loc2_) as Class);
               }
            }
         }
         this._triggersInit = false;
      }
      
      public function activate() : void
      {
         this._enabled = true;
      }
      
      public function deactivate() : void
      {
         this.clearAllNotification();
         this._enabled = false;
      }
   }
}

import com.ankamagames.berilia.components.Texture;
import flash.display.Shape;

class NotificationWrapper
{
    
   
   public var callback:String;
   
   public var callbackType:String;
   
   public var callbackParams:Array;
   
   public var refreshWithoutCallback:Boolean;
   
   public var texture:Texture;
   
   public var maskTimer:Shape;
   
   public var duration:int;
   
   public var startTime:int;
   
   public var pauseOnOver:Boolean;
   
   public var title:String;
   
   public var contentText:String;
   
   public var type:int;
   
   public var name:String;
   
   public var buttonList:Array;
   
   public var imageList:Array;
   
   public var tutorialId:int;
   
   public var blockCallbackOnTimerEnds:Boolean;
   
   function NotificationWrapper()
   {
      super();
   }
   
   public static function create(param1:Object) : NotificationWrapper
   {
      var _loc3_:Object = null;
      var _loc4_:Object = null;
      var _loc2_:NotificationWrapper = new NotificationWrapper();
      _loc2_.callback = param1.callback;
      _loc2_.callbackType = param1.callbackType;
      _loc2_.callbackParams = param1.callbackParams;
      _loc2_.texture = param1.texture;
      _loc2_.duration = param1.duration;
      _loc2_.startTime = param1.startTime;
      _loc2_.pauseOnOver = param1.pauseOnOver;
      _loc2_.title = param1.title;
      _loc2_.contentText = param1.contentText;
      _loc2_.name = param1.name;
      _loc2_.tutorialId = param1.tutorialId;
      _loc2_.refreshWithoutCallback = param1.refreshWithoutCallback;
      _loc2_.buttonList = new Array();
      for each(_loc3_ in param1.buttonList)
      {
         _loc2_.buttonList.push(_loc3_);
      }
      _loc2_.imageList = new Array();
      for each(_loc4_ in param1.imageList)
      {
         _loc2_.imageList.push(_loc4_);
      }
      _loc2_.type = param1.type;
      _loc2_.blockCallbackOnTimerEnds = param1.blockCallbackOnTimerEnds;
      return _loc2_;
   }
   
   public function get hasTimer() : Boolean
   {
      return this.duration && this.duration > 0;
   }
}
