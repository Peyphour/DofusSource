package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.CloseInventory;
   import d2actions.DisplayContextualMenu;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeObjectMoveKama;
   import d2actions.ExchangeObjectTransfertAllToInv;
   import d2actions.ExchangeReady;
   import d2actions.ExchangeRefuse;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.AskExchangeMoveObject;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.ExchangeIsReady;
   import d2hooks.ExchangeKamaModified;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeObjectAdded;
   import d2hooks.ExchangeObjectListAdded;
   import d2hooks.ExchangeObjectListModified;
   import d2hooks.ExchangeObjectListRemoved;
   import d2hooks.ExchangeObjectModified;
   import d2hooks.ExchangeObjectRemoved;
   import d2hooks.ExchangePodsModified;
   import d2hooks.ObjectSelected;
   import d2hooks.TextInformation;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ExchangeUi
   {
      
      public static const EXCHANGE_COLOR_OK:String = "EXCHANGE_COLOR_OK";
      
      public static const EXCHANGE_COLOR_CHANGE:String = "EXCHANGE_COLOR_CHANGE";
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      public var dataApi:DataApi;
      
      public var storageApi:StorageApi;
      
      public var menuApi:ContextMenuApi;
      
      public var utilApi:UtilApi;
      
      public var tooltipApi:TooltipApi;
      
      public var timeApi:TimeApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _playerName:String;
      
      private var _otherPlayerName:String;
      
      private var _otherPlayerId:Number;
      
      private var _sourceName:String;
      
      private var _targetName:String;
      
      private var _currentPlayerKama:uint;
      
      private var _leftItems:Array;
      
      private var _rightItems:Array;
      
      private var _leftCurrentPods:int;
      
      private var _rightCurrentPods:int;
      
      private var _leftMaxPods:int;
      
      private var _rightMaxPods:int;
      
      private var _leftExchangePods:int = 0;
      
      private var _rightExchangePods:int = 0;
      
      private var _rightPlayerKamaExchange:int;
      
      protected var _leftPlayerKamaExchange:int;
      
      private var _playerIsReady:Boolean = false;
      
      private var _timeDelay:Number = 2000;
      
      private var _timerDelay:Timer;
      
      private var _timeKamaDelay:Number = 1000;
      
      private var _timerKamaDelay:Timer;
      
      private var _timerPosButtons:Timer;
      
      private var _posXValid:int;
      
      private var _posYValid:int;
      
      private var _posXCancel:int;
      
      private var _posYCancel:int;
      
      private var _waitingObject:Object;
      
      private var _hasExchangeResult:Boolean = false;
      
      private var _success:Boolean = false;
      
      private var _myTopTimer:Timer;
      
      private var _myBottomTimer:Timer;
      
      private var _redTop:Boolean;
      
      private var _redBottom:Boolean;
      
      private var _myPodsTimer:Timer;
      
      private var _redPods:Boolean;
      
      private var _lbl_estimated_value_left_default_x:Number;
      
      private var _lbl_estimated_value_right_default_x:Number;
      
      private var estimated_value_left:Number;
      
      private var estimated_value_right:Number;
      
      private var _cancelKamaModification:Boolean;
      
      public var ctr_main:GraphicContainer;
      
      public var ctr_itemBlock:GraphicContainer;
      
      public var ctr_item:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_validate:ButtonContainer;
      
      public var btn_cancel:ButtonContainer;
      
      public var btn_moveAll:ButtonContainer;
      
      public var lbl_leftPlayerName:Label;
      
      public var lbl_rightPlayerName:Label;
      
      public var lbl_kamaLeft:Label;
      
      public var input_kamaRight:Input;
      
      public var lbl_estimated_left:Label;
      
      public var lbl_estimated_value_left:Label;
      
      public var lbl_estimated_right:Label;
      
      public var lbl_estimated_value_right:Label;
      
      public var tx_podsBar_right:Texture;
      
      public var tx_podsBar_left:Texture;
      
      public var tx_estimated_value_warning_left:Texture;
      
      public var tx_estimated_value_warning_right:Texture;
      
      public var gd_left:Grid;
      
      public var gd_right:Grid;
      
      public var ed_leftPlayer:EntityDisplayer;
      
      public var ed_rightPlayer:EntityDisplayer;
      
      public var tx_warningLeftTop:TextureBitmap;
      
      public var tx_warningLeftPods:TextureBitmap;
      
      public var tx_warningLeftBottom:TextureBitmap;
      
      public var tx_validatedLeftTop:TextureBitmap;
      
      public var tx_validatedLeftBottom:TextureBitmap;
      
      public var tx_validatedRightTop:TextureBitmap;
      
      public var tx_validatedRightBottom:TextureBitmap;
      
      public function ExchangeUi()
      {
         this._myTopTimer = new Timer(250,12);
         this._myBottomTimer = new Timer(250,12);
         this._myPodsTimer = new Timer(250,12);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.disableWorldInteraction(false);
         this.btn_cancel.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_validate.soundId = SoundEnum.OK_BUTTON;
         this.sysApi.addHook(ExchangeObjectModified,this.onExchangeObjectModified);
         this.sysApi.addHook(ExchangeObjectAdded,this.onExchangeObjectAdded);
         this.sysApi.addHook(ExchangeObjectRemoved,this.onExchangeObjectRemoved);
         this.sysApi.addHook(ExchangeKamaModified,this.onExchangeKamaModified);
         this.sysApi.addHook(ExchangePodsModified,this.onExchangePodsModified);
         this.sysApi.addHook(AskExchangeMoveObject,this.onAskExchangeMoveObject);
         this.sysApi.addHook(ExchangeIsReady,this.onExchangeIsReady);
         this.sysApi.addHook(DoubleClickItemInventory,this.onDoubleClickItemInventory);
         this.sysApi.addHook(ObjectSelected,this.onObjectSelected);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(ExchangeObjectListAdded,this.onExchangeObjectListAdded);
         this.sysApi.addHook(ExchangeObjectListModified,this.onExchangeObjectListModified);
         this.sysApi.addHook(ExchangeObjectListRemoved,this.onExchangeObjectListRemoved);
         this.uiApi.addComponentHook(this.ed_leftPlayer,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ed_leftPlayer,ComponentHookList.ON_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.ed_rightPlayer,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ed_rightPlayer,ComponentHookList.ON_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.gd_left,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.gd_left,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_left,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.gd_left,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_left,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_right,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.gd_right,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_right,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.gd_right,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_right,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_estimated_value_warning_left,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_estimated_value_warning_left,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_estimated_value_warning_right,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_estimated_value_warning_right,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_kamaLeft,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_kamaLeft,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_estimated_left,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_estimated_left,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_estimated_value_left,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_estimated_value_left,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_estimated_right,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_estimated_right,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_estimated_value_right,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_estimated_value_right,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_moveAll,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_moveAll,ComponentHookList.ON_ROLL_OUT);
         this.lbl_estimated_left.text = this.lbl_estimated_right.text = this.uiApi.getText("ui.exchange.estimatedValue") + " :";
         this._lbl_estimated_value_left_default_x = this.lbl_estimated_value_left.x;
         this._lbl_estimated_value_right_default_x = this.lbl_estimated_value_right.x;
         this.ed_leftPlayer.mouseEnabled = true;
         this.ed_leftPlayer.handCursor = true;
         this.ed_rightPlayer.mouseEnabled = true;
         this.ed_rightPlayer.handCursor = true;
         this.ctr_itemBlock.visible = false;
         this._leftItems = new Array();
         this._rightItems = new Array();
         this._playerName = this.playerApi.getPlayedCharacterInfo().name;
         this._sourceName = param1.sourceName;
         this._targetName = param1.targetName;
         this._currentPlayerKama = this.playerApi.characteristics().kamas;
         this.input_kamaRight.maxChars = 13;
         this.input_kamaRight.restrictChars = "0-9  ";
         this.input_kamaRight.numberMax = ProtocolConstantsEnum.MAX_KAMA;
         this.uiApi.addComponentHook(this.input_kamaRight,ComponentHookList.ON_CHANGE);
         this.checkAcceptButton();
         this._otherPlayerId = param1.otherId;
         if(this._sourceName == this._playerName)
         {
            this._otherPlayerName = this._targetName;
            this.ed_rightPlayer.look = param1.sourceLook;
            this.ed_leftPlayer.look = param1.targetLook;
            this._leftCurrentPods = param1.targetCurrentPods;
            this._leftMaxPods = param1.targetMaxPods;
            this._rightCurrentPods = param1.sourceCurrentPods;
            this._rightMaxPods = param1.sourceMaxPods;
         }
         else
         {
            this._otherPlayerName = this._sourceName;
            this.ed_leftPlayer.look = param1.sourceLook;
            this.ed_rightPlayer.look = param1.targetLook;
            this._rightCurrentPods = param1.targetCurrentPods;
            this._rightMaxPods = param1.targetMaxPods;
            this._leftCurrentPods = param1.sourceCurrentPods;
            this._leftMaxPods = param1.sourceMaxPods;
         }
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16733440,0.5);
         _loc2_.graphics.drawRect(this.ed_leftPlayer.x,this.ed_leftPlayer.y,this.ed_leftPlayer.width,100);
         _loc2_.graphics.endFill();
         this.ctr_main.addChild(_loc2_);
         this.ed_leftPlayer.mask = _loc2_;
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(16733440,0.5);
         _loc3_.graphics.drawRect(this.ed_rightPlayer.x,this.ed_rightPlayer.y,this.ed_rightPlayer.width,100);
         _loc3_.graphics.endFill();
         this.ctr_main.addChild(_loc3_);
         this.ed_rightPlayer.mask = _loc3_;
         this.updatePods();
         this.lbl_rightPlayerName.text = this._playerName;
         this.lbl_leftPlayerName.text = this._otherPlayerName;
         this._rightPlayerKamaExchange = 0;
         this._leftPlayerKamaExchange = 0;
         this.estimated_value_left = this.estimated_value_right = 0;
         this.updateEstimatedValue(this._leftItems,0,this.lbl_estimated_value_left);
         this.updateEstimatedValue(this._rightItems,0,this.lbl_estimated_value_right);
         this.gd_left.dataProvider = new Array();
         this.gd_left.renderer.dropValidatorFunction = this.dropValidatorFalse;
         this.gd_left.renderer.processDropFunction = this.processDropNull;
         this.gd_left.renderer.removeDropSourceFunction = this.removeDropSource;
         this.gd_right.dataProvider = new Array();
         this.gd_right.renderer.dropValidatorFunction = this.dropValidator;
         this.gd_right.renderer.processDropFunction = this.processDrop;
         this.gd_right.renderer.removeDropSourceFunction = this.removeDropSource;
         this.gd_right.mouseEnabled = true;
         if(param1.sourceCurrentPods > 0)
         {
            this.uiApi.addComponentHook(this.tx_podsBar_left,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(this.tx_podsBar_left,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(this.tx_podsBar_right,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(this.tx_podsBar_right,ComponentHookList.ON_ROLL_OUT);
         }
         else
         {
            this.tx_podsBar_left.visible = false;
            this.tx_podsBar_right.visible = false;
         }
      }
      
      private function redWink(param1:Boolean) : void
      {
         if(param1)
         {
            this._myTopTimer.start();
            this._myTopTimer.addEventListener(TimerEvent.TIMER,this.topTimerHandler);
            this._myTopTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.topCompleteHandler);
         }
         else
         {
            this._myBottomTimer.start();
            this._myBottomTimer.addEventListener(TimerEvent.TIMER,this.bottomTimerHandler);
            this._myBottomTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.bottomCompleteHandler);
         }
      }
      
      private function redPodsWink() : void
      {
         this._myPodsTimer.start();
         this._myPodsTimer.addEventListener(TimerEvent.TIMER,this.podsTimerHandler);
         this._myPodsTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.podsCompleteHandler);
      }
      
      private function topTimerHandler(param1:TimerEvent) : void
      {
         if(this._redTop)
         {
            this.tx_warningLeftTop.visible = false;
            this._redTop = false;
         }
         else
         {
            this.tx_warningLeftTop.visible = true;
            this._redTop = true;
         }
      }
      
      private function topCompleteHandler(param1:TimerEvent) : void
      {
         this.tx_warningLeftTop.visible = false;
         this._redTop = false;
         this._myTopTimer.reset();
      }
      
      private function bottomTimerHandler(param1:TimerEvent) : void
      {
         if(this._redBottom)
         {
            this.tx_warningLeftBottom.visible = false;
            this._redBottom = false;
         }
         else
         {
            this.tx_warningLeftBottom.visible = true;
            this._redBottom = true;
         }
      }
      
      private function bottomCompleteHandler(param1:TimerEvent) : void
      {
         this.tx_warningLeftBottom.visible = false;
         this._redBottom = false;
         this._myBottomTimer.reset();
      }
      
      private function podsTimerHandler(param1:TimerEvent) : void
      {
         if(this._redPods)
         {
            this.tx_warningLeftPods.visible = false;
            this._redPods = false;
         }
         else
         {
            this.tx_warningLeftPods.visible = true;
            this._redPods = true;
         }
      }
      
      private function podsCompleteHandler(param1:TimerEvent) : void
      {
         this.tx_warningLeftPods.visible = false;
         this._redPods = false;
         this._myPodsTimer.reset();
      }
      
      public function onChange(param1:GraphicContainer) : void
      {
         var _loc2_:int = this.utilApi.stringToKamas(this.input_kamaRight.text,"");
         if(_loc2_ > this._currentPlayerKama)
         {
            _loc2_ = this._currentPlayerKama;
            this.input_kamaRight.text = this.utilApi.kamasToString(_loc2_,"");
         }
         if(this._timerKamaDelay)
         {
            this._timerKamaDelay.stop();
            this._timerKamaDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerKamaDelay);
            this._cancelKamaModification = true;
         }
         this._timerKamaDelay = new Timer(this._timeKamaDelay,1);
         this._timerKamaDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerKamaDelay);
         this.onExchangeIsReady(this.playerApi.getPlayedCharacterInfo().name,false);
         this.delayEnableValidateButton();
         this._timerKamaDelay.start();
      }
      
      private function onTimerDelayValidateButton(param1:TimerEvent) : void
      {
         this._timerDelay.removeEventListener(TimerEvent.TIMER,this.onTimerDelayValidateButton);
         this.checkAcceptButton();
      }
      
      private function onTimerKamaDelay(param1:TimerEvent) : void
      {
         this._timerKamaDelay.removeEventListener(TimerEvent.TIMER,this.onTimerKamaDelay);
         var _loc2_:int = this.utilApi.stringToKamas(this.input_kamaRight.text,"");
         if(_loc2_ != this._rightPlayerKamaExchange)
         {
            this._rightPlayerKamaExchange = _loc2_;
            this._cancelKamaModification = false;
            this.sysApi.sendAction(new ExchangeObjectMoveKama(this._rightPlayerKamaExchange));
         }
      }
      
      public function onObjectSelected(param1:Object) : void
      {
         if(!this.sysApi.getOption("displayTooltips","dofus"))
         {
            if(param1)
            {
               this.modCommon.createItemBox("itemBox",this.ctr_item,param1);
               this.ctr_itemBlock.visible = true;
            }
            else
            {
               this.ctr_itemBlock.visible = false;
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_cancel:
               if(this._playerIsReady)
               {
                  this.validateExchange(false);
               }
               else
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               break;
            case this.btn_validate:
               if(!this._playerIsReady)
               {
                  this.validateExchange(true);
               }
               break;
            case this.ed_leftPlayer:
               this.sysApi.sendAction(new DisplayContextualMenu(this._otherPlayerId));
               break;
            case this.ed_rightPlayer:
               this.sysApi.sendAction(new DisplayContextualMenu(this.playerApi.id()));
               break;
            case this.btn_moveAll:
               _loc2_ = new Array();
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.storage.getAll"),this.transfertAll,null,false,null,false,true));
               this.modContextMenu.createContextMenu(_loc2_);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         switch(param1)
         {
            case this.gd_right:
               _loc4_ = this.gd_right.selectedItem;
               if(param2 == SelectMethodEnum.DOUBLE_CLICK)
               {
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc4_.objectUID,-1));
               }
               else if(param2 == SelectMethodEnum.CTRL_DOUBLE_CLICK)
               {
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc4_.objectUID,-_loc4_.quantity));
               }
               else if(param2 == SelectMethodEnum.ALT_DOUBLE_CLICK)
               {
                  this._waitingObject = _loc4_;
                  this.modCommon.openQuantityPopup(1,this._waitingObject.quantity,this._waitingObject.quantity,this.onAltValidQty);
               }
               else
               {
                  this.onObjectSelected(_loc4_);
               }
               break;
            case this.gd_left:
               _loc5_ = this.gd_left.selectedItem;
               this.onObjectSelected(_loc5_);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = new Object();
         _loc2_.point = LocationEnum.POINT_BOTTOM;
         _loc2_.relativePoint = LocationEnum.POINT_TOP;
         switch(param1)
         {
            case this.tx_podsBar_left:
               _loc3_ = this.uiApi.getText("ui.common.player.weight",this.utilApi.kamasToString(this._leftCurrentPods + this._leftExchangePods,""),this.utilApi.kamasToString(this._leftMaxPods,""));
               break;
            case this.tx_podsBar_right:
               _loc3_ = this.uiApi.getText("ui.common.player.weight",this.utilApi.kamasToString(this._rightCurrentPods + this._rightExchangePods,""),this.utilApi.kamasToString(this._rightMaxPods,""));
               break;
            case this.lbl_kamaLeft:
               _loc3_ = this.uiApi.getText("ui.exchange.kamas");
               break;
            case this.lbl_estimated_left:
            case this.lbl_estimated_value_left:
            case this.lbl_estimated_right:
            case this.lbl_estimated_value_right:
               _loc3_ = this.uiApi.getText("ui.exchange.estimatedValue.description");
               break;
            case this.tx_estimated_value_warning_left:
            case this.tx_estimated_value_warning_right:
               _loc3_ = this.uiApi.getText("ui.exchange.warning");
               break;
            case this.btn_moveAll:
               _loc3_ = this.uiApi.getText("ui.storage.advancedTransferts");
         }
         if(_loc3_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",_loc2_.point,_loc2_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRightClick(param1:Object) : void
      {
         if(param1 == this.ed_leftPlayer)
         {
            this.sysApi.sendAction(new DisplayContextualMenu(this._otherPlayerId));
         }
         else if(param1 == this.ed_rightPlayer)
         {
            this.sysApi.sendAction(new DisplayContextualMenu(this.playerApi.id()));
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:ItemTooltipSettings = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(param2.data)
         {
            _loc3_ = this.tooltipApi.createItemSettings();
            _loc4_ = new Object();
            for each(_loc5_ in this.sysApi.getObjectVariables(_loc3_))
            {
               _loc4_[_loc5_] = _loc3_[_loc5_];
            }
            _loc4_.ref = param2.container;
            this.uiApi.showTooltip(param2.data,param2.container,false,"standard",8,0,0,"itemName",null,_loc4_,"ItemInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         if(param2.data == null)
         {
            return;
         }
         var _loc3_:Object = param2.data;
         var _loc4_:Object = this.menuApi.create(_loc3_);
         var _loc5_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(!_loc5_)
         {
            _loc5_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc5_,DataStoreEnum.BIND_ACCOUNT);
         }
         var _loc6_:Boolean = _loc4_.content[0].disabled;
         this.modContextMenu.createContextMenu(_loc4_);
      }
      
      public function unload() : void
      {
         if(this._timerPosButtons)
         {
            this._timerPosButtons.removeEventListener(TimerEvent.TIMER,this.onTimerDelayValidateButton);
            this._timerPosButtons.stop();
            this._timerPosButtons = null;
         }
         if(this._timerDelay)
         {
            this._timerDelay.removeEventListener(TimerEvent.TIMER,this.onTimerDelayValidateButton);
            this._timerDelay.stop();
            this._timerDelay = null;
         }
         this._myTopTimer.removeEventListener(TimerEvent.TIMER,this.topTimerHandler);
         this._myTopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.topCompleteHandler);
         this._myBottomTimer.removeEventListener(TimerEvent.TIMER,this.bottomTimerHandler);
         this._myBottomTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.bottomCompleteHandler);
         this._myPodsTimer.removeEventListener(TimerEvent.TIMER,this.podsTimerHandler);
         this._myPodsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.podsCompleteHandler);
         this.storageApi.removeAllItemMasks("exchange");
         this.storageApi.releaseHooks();
         if(this._timerKamaDelay)
         {
            this._timerKamaDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerKamaDelay);
         }
         this.uiApi.hideTooltip();
         this.uiApi.unloadUi("itemBox");
         if(!this._hasExchangeResult)
         {
            this.sysApi.sendAction(new ExchangeRefuse());
         }
         this.sysApi.sendAction(new CloseInventory());
         if(this._success)
         {
            this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.exchange.success"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,this.timeApi.getTimestamp());
         }
         else
         {
            this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.exchange.cancel"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,this.timeApi.getTimestamp());
         }
         this.sysApi.enableWorldInteraction();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case ShortcutHookListEnum.CLOSE_UI:
            case ShortcutHookListEnum.VALID_UI:
               return true;
            default:
               return false;
         }
      }
      
      public function dropValidatorFalse(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return false;
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(param1.getUi().name != param3.getUi().name)
         {
            return true;
         }
         return false;
      }
      
      public function removeDropSource(param1:Object) : void
      {
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropValidator(param1,param2,param3))
         {
            this._waitingObject = param2;
            if(param2.quantity > 1)
            {
               this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQty);
            }
            else
            {
               this.onValidQty(1);
            }
         }
      }
      
      public function processDropNull(param1:Object, param2:Object, param3:Object) : void
      {
      }
      
      private function delayEnableValidateButton() : void
      {
         if(this._timerDelay && this._timerDelay.running)
         {
            this._timerDelay.stop();
         }
         this._timerDelay = new Timer(this._timeDelay,1);
         this._timerDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerDelayValidateButton);
         this.btn_validate.disabled = true;
         this._timerDelay.start();
      }
      
      protected function checkAcceptButton() : void
      {
         if(this.gd_left.dataProvider.length > 0 || this.gd_right.dataProvider.length > 0 || this._rightPlayerKamaExchange > 0 || this._leftPlayerKamaExchange > 0)
         {
            this.btn_validate.disabled = false;
         }
         else
         {
            this.btn_validate.disabled = true;
         }
      }
      
      private function addItemInLeftGrid(param1:Object) : void
      {
         var _loc2_:Object = this.dataApi.getItem(param1.objectGID);
         this._leftExchangePods = this._leftExchangePods - param1.quantity * param1.weight;
         this._rightExchangePods = this._rightExchangePods + param1.quantity * param1.weight;
         this.updatePods();
         this._leftItems.push(param1);
         this.gd_left.dataProvider = this._leftItems;
         this.gd_left.moveTo(this.gd_left.dataProvider.length - 1,true);
         this.updateEstimatedValue(this._leftItems,this._leftPlayerKamaExchange,this.lbl_estimated_value_left);
         this.redWink(false);
      }
      
      private function addItemListInLeftGrid(param1:Object) : void
      {
         var _loc2_:ItemWrapper = null;
         for each(_loc2_ in param1)
         {
            this._leftExchangePods = this._leftExchangePods - _loc2_.quantity * _loc2_.weight;
            this._rightExchangePods = this._rightExchangePods + _loc2_.quantity * _loc2_.weight;
            this._leftItems.push(_loc2_);
            this.storageApi.addItemMask(_loc2_.objectUID,"exchange",_loc2_.quantity);
         }
         this.storageApi.releaseHooks();
         this.updatePods();
         this.gd_left.dataProvider = this._leftItems;
         this.gd_left.moveTo(this.gd_left.dataProvider.length - 1,true);
         this.updateEstimatedValue(this._leftItems,this._leftPlayerKamaExchange,this.lbl_estimated_value_left);
         this.redWink(false);
      }
      
      private function addItemInRightGrid(param1:Object) : void
      {
         this._leftExchangePods = this._leftExchangePods + param1.quantity * param1.weight;
         this._rightExchangePods = this._rightExchangePods - param1.quantity * param1.weight;
         this.updatePods();
         this._rightItems.push(param1);
         this.gd_right.dataProvider = this._rightItems;
         this.gd_right.moveTo(this.gd_right.dataProvider.length - 1,true);
         this.updateEstimatedValue(this._rightItems,this._rightPlayerKamaExchange,this.lbl_estimated_value_right);
      }
      
      private function addItemListInRightGrid(param1:Object) : void
      {
         var _loc2_:ItemWrapper = null;
         for each(_loc2_ in param1)
         {
            this._leftExchangePods = this._leftExchangePods + _loc2_.quantity * _loc2_.weight;
            this._rightExchangePods = this._rightExchangePods - _loc2_.quantity * _loc2_.weight;
            this._rightItems.push(_loc2_);
            this.storageApi.addItemMask(_loc2_.objectUID,"exchange",_loc2_.quantity);
         }
         this.storageApi.releaseHooks();
         this.updatePods();
         this.gd_right.dataProvider = this._rightItems;
         this.gd_right.moveTo(this.gd_right.dataProvider.length - 1,true);
         this.updateEstimatedValue(this._rightItems,this._rightPlayerKamaExchange,this.lbl_estimated_value_right);
      }
      
      private function removeItemInRightGrid(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         for(_loc3_ in this._rightItems)
         {
            if(this._rightItems[_loc3_].objectUID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_)
         {
            _loc4_ = this.dataApi.getItem(this._rightItems[_loc2_].objectGID);
            this._leftExchangePods = this._leftExchangePods - this._rightItems[_loc2_].quantity * this._rightItems[_loc2_].weight;
            this._rightExchangePods = this._rightExchangePods + this._rightItems[_loc2_].quantity * this._rightItems[_loc2_].weight;
            this.updatePods();
            this._rightItems.splice(_loc2_,1);
            _loc5_ = this.gd_right.verticalScrollValue * this.gd_right.slotByRow + 1;
            this.gd_right.dataProvider = this._rightItems;
            this.gd_right.moveTo(_loc5_,true);
            this.updateEstimatedValue(this._rightItems,this._rightPlayerKamaExchange,this.lbl_estimated_value_right);
         }
      }
      
      private function removeItemInLeftGrid(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         for(_loc3_ in this._leftItems)
         {
            if(this._leftItems[_loc3_].objectUID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_)
         {
            _loc4_ = this.dataApi.getItem(this._leftItems[_loc2_].objectGID);
            this._leftExchangePods = this._leftExchangePods + this._leftItems[_loc2_].quantity * this._leftItems[_loc2_].weight;
            this._rightExchangePods = this._rightExchangePods - this._leftItems[_loc2_].quantity * this._leftItems[_loc2_].weight;
            this.updatePods();
            this._leftItems.splice(_loc2_,1);
            _loc5_ = this.gd_left.verticalScrollValue * this.gd_left.slotByRow + 1;
            this.gd_left.dataProvider = this._leftItems;
            this.gd_left.moveTo(_loc5_,true);
            this.updateEstimatedValue(this._leftItems,this._leftPlayerKamaExchange,this.lbl_estimated_value_left);
            this.redWink(false);
         }
      }
      
      private function modifyItemInRightGrid(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         for(_loc3_ in this._rightItems)
         {
            if(this._rightItems[_loc3_].objectUID == param1.objectUID)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_)
         {
            _loc4_ = this.dataApi.getItem(param1.objectGID);
            this._leftExchangePods = this._leftExchangePods - this._rightItems[_loc2_].quantity * this._rightItems[_loc2_].weight;
            this._rightExchangePods = this._rightExchangePods + this._rightItems[_loc2_].quantity * this._rightItems[_loc2_].weight;
            this._leftExchangePods = this._leftExchangePods + param1.quantity * param1.weight;
            this._rightExchangePods = this._rightExchangePods - param1.quantity * param1.weight;
            this.updatePods();
            this._rightItems.splice(_loc2_,1,param1);
            _loc5_ = this.gd_right.verticalScrollValue * this.gd_right.slotByRow + 1;
            this.gd_right.dataProvider = this._rightItems;
            this.gd_right.moveTo(_loc5_,true);
            this.updateEstimatedValue(this._rightItems,this._rightPlayerKamaExchange,this.lbl_estimated_value_right);
         }
      }
      
      private function modifyItemListInRightGrid(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:ItemWrapper = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:Object = null;
         for each(_loc3_ in param1)
         {
            for(_loc5_ in this._rightItems)
            {
               if(this._rightItems[_loc5_].objectUID == _loc3_.objectUID)
               {
                  _loc2_ = _loc5_;
                  break;
               }
            }
            if(_loc2_)
            {
               _loc6_ = this.dataApi.getItem(_loc3_.objectGID);
               this._leftExchangePods = this._leftExchangePods - this._rightItems[_loc2_].quantity * this._rightItems[_loc2_].weight;
               this._rightExchangePods = this._rightExchangePods + this._rightItems[_loc2_].quantity * this._rightItems[_loc2_].weight;
               this._leftExchangePods = this._leftExchangePods + _loc3_.quantity * _loc3_.weight;
               this._rightExchangePods = this._rightExchangePods - _loc3_.quantity * _loc3_.weight;
               this._rightItems.splice(_loc2_,1,_loc3_);
               this.storageApi.addItemMask(_loc3_.objectUID,"exchange",_loc3_.quantity);
            }
         }
         _loc4_ = this.gd_right.verticalScrollValue * this.gd_right.slotByRow + 1;
         this.gd_right.dataProvider = this._rightItems;
         this.gd_right.moveTo(_loc4_,true);
         this.updatePods();
         this.storageApi.releaseHooks();
         this.updateEstimatedValue(this._rightItems,this._rightPlayerKamaExchange,this.lbl_estimated_value_right);
      }
      
      private function modifyItemInLeftGrid(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         for(_loc3_ in this._leftItems)
         {
            if(this._leftItems[_loc3_].objectUID == param1.objectUID)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_)
         {
            _loc4_ = this.dataApi.getItem(param1.objectGID);
            this._leftExchangePods = this._leftExchangePods + this._leftItems[_loc2_].quantity * this._leftItems[_loc2_].weight;
            this._rightExchangePods = this._rightExchangePods - this._leftItems[_loc2_].quantity * this._leftItems[_loc2_].weight;
            this._leftExchangePods = this._leftExchangePods - param1.quantity * param1.weight;
            this._rightExchangePods = this._rightExchangePods + param1.quantity * param1.weight;
            this.updatePods();
            this._leftItems.splice(_loc2_,1,param1);
            _loc5_ = this.gd_left.verticalScrollValue * this.gd_left.slotByRow + 1;
            this.gd_left.dataProvider = this._leftItems;
            this.gd_left.moveTo(_loc5_,true);
            this.updateEstimatedValue(this._leftItems,this._leftPlayerKamaExchange,this.lbl_estimated_value_left);
            this.redWink(false);
         }
      }
      
      private function modifyItemListInLeftGrid(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:ItemWrapper = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         for each(_loc3_ in param1)
         {
            for(_loc5_ in this._leftItems)
            {
               if(this._leftItems[_loc5_].objectUID == _loc3_.objectUID)
               {
                  _loc2_ = _loc5_;
                  break;
               }
            }
            if(_loc2_)
            {
               this._leftExchangePods = this._leftExchangePods + this._leftItems[_loc2_].quantity * this._leftItems[_loc2_].weight;
               this._rightExchangePods = this._rightExchangePods - this._leftItems[_loc2_].quantity * this._leftItems[_loc2_].weight;
               this._leftExchangePods = this._leftExchangePods - _loc3_.quantity * _loc3_.weight;
               this._rightExchangePods = this._rightExchangePods + _loc3_.quantity * _loc3_.weight;
               this._leftItems.splice(_loc2_,1,_loc3_);
            }
         }
         _loc4_ = this.gd_left.verticalScrollValue * this.gd_left.slotByRow + 1;
         this.gd_left.dataProvider = this._leftItems;
         this.gd_left.moveTo(_loc4_,true);
         this.updatePods();
         this.updateEstimatedValue(this._leftItems,this._leftPlayerKamaExchange,this.lbl_estimated_value_left);
         this.redWink(false);
      }
      
      private function validateExchange(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(this._timerKamaDelay && this._timerKamaDelay.running)
         {
            _loc2_ = this.utilApi.stringToKamas(this.input_kamaRight.text,"");
            if(_loc2_ != this._rightPlayerKamaExchange)
            {
               this._rightPlayerKamaExchange = _loc2_;
               this.sysApi.sendAction(new ExchangeObjectMoveKama(this._rightPlayerKamaExchange));
            }
         }
         else
         {
            this.sysApi.sendAction(new ExchangeReady(param1));
         }
      }
      
      private function changeBackgroundGrid(param1:String, param2:Object) : void
      {
         switch(param1)
         {
            case EXCHANGE_COLOR_OK:
               switch(param2)
               {
                  case this.gd_left:
                     this.tx_validatedLeftTop.visible = true;
                     this.tx_validatedLeftBottom.visible = true;
                     break;
                  case this.gd_right:
                     this.tx_validatedRightTop.visible = true;
                     this.tx_validatedRightBottom.visible = true;
               }
               break;
            case EXCHANGE_COLOR_CHANGE:
               switch(param2)
               {
                  case this.gd_left:
                     this.tx_validatedLeftTop.visible = false;
                     this.tx_validatedLeftBottom.visible = false;
                     break;
                  case this.gd_right:
                     this.tx_validatedRightTop.visible = false;
                     this.tx_validatedRightBottom.visible = false;
               }
         }
      }
      
      private function updatePods() : void
      {
         this.tx_podsBar_left.gotoAndStop = Math.min(100,Math.floor(100 * (this._leftCurrentPods + this._leftExchangePods) / this._leftMaxPods));
         this.tx_podsBar_right.gotoAndStop = Math.min(100,Math.floor(100 * (this._rightCurrentPods + this._rightExchangePods) / this._rightMaxPods));
      }
      
      private function updateEstimatedValue(param1:Array, param2:int, param3:Label) : void
      {
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc4_:Number = 0;
         for(_loc5_ in param1)
         {
            _loc6_ = this.averagePricesApi.getItemAveragePrice(param1[_loc5_].objectGID);
            if(_loc6_ > 0)
            {
               _loc4_ = _loc4_ + _loc6_ * param1[_loc5_].quantity;
            }
         }
         param3.text = this.utilApi.kamasToString(_loc4_ + param2);
         if(param3 == this.lbl_estimated_value_left)
         {
            this.estimated_value_left = _loc4_;
         }
         else if(param3 == this.lbl_estimated_value_right)
         {
            this.estimated_value_right = _loc4_;
         }
         this.checkFairTrade();
      }
      
      private function checkFairTrade() : void
      {
         var _loc1_:Boolean = true;
         if(this.estimated_value_left > 0 && this.estimated_value_left >= 2 * this.estimated_value_right)
         {
            this.tx_estimated_value_warning_left.visible = true;
            this.lbl_estimated_value_left.x = this._lbl_estimated_value_left_default_x - 20;
            _loc1_ = false;
         }
         else
         {
            this.tx_estimated_value_warning_left.visible = false;
            this.lbl_estimated_value_left.x = this._lbl_estimated_value_left_default_x;
         }
         if(this.estimated_value_right > 0 && this.estimated_value_right >= 2 * this.estimated_value_left)
         {
            this.tx_estimated_value_warning_right.visible = true;
            this.lbl_estimated_value_right.x = this._lbl_estimated_value_right_default_x - 20;
            _loc1_ = false;
         }
         else
         {
            this.tx_estimated_value_warning_right.visible = false;
            this.lbl_estimated_value_right.x = this._lbl_estimated_value_right_default_x;
         }
         if(!_loc1_)
         {
            this.lbl_estimated_value_left.cssClass = this.lbl_estimated_value_right.cssClass = "redright";
         }
         else
         {
            this.lbl_estimated_value_left.cssClass = this.lbl_estimated_value_right.cssClass = "right";
         }
      }
      
      private function transfertAll() : void
      {
         this.sysApi.sendAction(new ExchangeObjectTransfertAllToInv());
      }
      
      private function onExchangeIsReady(param1:String, param2:Boolean) : void
      {
         if(param1 != this._playerName)
         {
            if(param2)
            {
               this.changeBackgroundGrid(EXCHANGE_COLOR_OK,this.gd_left);
            }
            else
            {
               this.changeBackgroundGrid(EXCHANGE_COLOR_CHANGE,this.gd_left);
            }
         }
         else
         {
            this._playerIsReady = param2;
            if(param2)
            {
               this.changeBackgroundGrid(EXCHANGE_COLOR_OK,this.gd_right);
            }
            else
            {
               this.changeBackgroundGrid(EXCHANGE_COLOR_CHANGE,this.gd_right);
            }
         }
      }
      
      private function onAskExchangeMoveObject(param1:int, param2:int) : void
      {
      }
      
      private function onExchangeObjectModified(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.modifyItemInLeftGrid(param1);
         }
         else
         {
            this.modifyItemInRightGrid(param1);
         }
         this.gd_left.updateItems();
         this.gd_right.updateItems();
         this.storageApi.addItemMask(param1.objectUID,"exchange",param1.quantity);
         this.storageApi.releaseHooks();
         this.checkAcceptButton();
         this.delayEnableValidateButton();
      }
      
      private function onExchangeObjectAdded(param1:Object, param2:Object) : void
      {
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         if(!param2)
         {
            this.addItemInRightGrid(param1);
         }
         else
         {
            this.addItemInLeftGrid(param1);
         }
         this.storageApi.addItemMask(param1.objectUID,"exchange",param1.quantity);
         this.storageApi.releaseHooks();
         this.delayEnableValidateButton();
      }
      
      private function onExchangeObjectListAdded(param1:Object, param2:Object) : void
      {
         if(!param2)
         {
            this.addItemListInRightGrid(param1);
         }
         else
         {
            this.addItemListInLeftGrid(param1);
         }
         this.delayEnableValidateButton();
      }
      
      private function onExchangeObjectListModified(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.modifyItemListInLeftGrid(param1);
         }
         else
         {
            this.modifyItemListInRightGrid(param1);
         }
         this.gd_left.updateItems();
         this.gd_right.updateItems();
         this.checkAcceptButton();
         this.delayEnableValidateButton();
      }
      
      private function onExchangeObjectRemoved(param1:int, param2:Boolean) : void
      {
         this.soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
         if(!param2)
         {
            this.removeItemInRightGrid(param1);
         }
         else
         {
            this.removeItemInLeftGrid(param1);
         }
         this.storageApi.removeItemMask(param1,"exchange");
         this.storageApi.releaseHooks();
         this.checkAcceptButton();
         this.delayEnableValidateButton();
      }
      
      private function onExchangeObjectListRemoved(param1:Object, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         this.soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
         for each(_loc3_ in param1)
         {
            if(!param2)
            {
               this.removeItemInRightGrid(_loc3_);
            }
            else
            {
               this.removeItemInLeftGrid(_loc3_);
            }
            this.storageApi.removeItemMask(_loc3_,"exchange");
         }
         this.storageApi.releaseHooks();
         this.checkAcceptButton();
         this.delayEnableValidateButton();
      }
      
      private function onExchangeKamaModified(param1:uint, param2:Boolean) : void
      {
         if(param2)
         {
            this.lbl_kamaLeft.text = this.utilApi.kamasToString(param1,"");
            this._leftPlayerKamaExchange = param1;
            this.updateEstimatedValue(this._leftItems,this._leftPlayerKamaExchange,this.lbl_estimated_value_left);
            this.redWink(true);
         }
         else
         {
            if(this._cancelKamaModification)
            {
               return;
            }
            this.input_kamaRight.text = this.utilApi.kamasToString(param1,"");
            this._rightPlayerKamaExchange = param1;
            this.updateEstimatedValue(this._rightItems,this._rightPlayerKamaExchange,this.lbl_estimated_value_right);
         }
         this.checkAcceptButton();
         this.delayEnableValidateButton();
      }
      
      private function onExchangePodsModified(param1:uint, param2:uint, param3:Boolean) : void
      {
         if(param3)
         {
            this._leftCurrentPods = param1;
            this._leftMaxPods = param2;
         }
         else
         {
            this._rightCurrentPods = param1;
            this._rightMaxPods = param2;
         }
         this.updatePods();
         this.redPodsWink();
         this.delayEnableValidateButton();
      }
      
      public function onDoubleClickItemInventory(param1:Object, param2:int = 1) : void
      {
         this._waitingObject = param1;
         this.onValidQty(param2);
      }
      
      private function onValidQty(param1:Number) : void
      {
         this.sysApi.sendAction(new ExchangeObjectMove(this._waitingObject.objectUID,param1));
      }
      
      private function onAltValidQty(param1:Number) : void
      {
         this.sysApi.sendAction(new ExchangeObjectMove(this._waitingObject.objectUID,-param1));
      }
      
      private function onTimerPosButtons(param1:TimerEvent) : void
      {
         this.btn_validate.x = this._posXValid;
         this.btn_validate.y = this._posYValid;
         this.btn_cancel.x = this._posXCancel;
         this.btn_cancel.y = this._posYCancel;
         this._timerPosButtons.stop();
         this._timerPosButtons.removeEventListener(TimerEvent.TIMER,this.onTimerPosButtons);
         this._timerPosButtons = null;
      }
      
      private function onExchangeLeave(param1:Boolean) : void
      {
         this._hasExchangeResult = true;
         this._success = param1;
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
