package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankama.codegen.client.api.ApiClient;
   import com.ankama.codegen.client.api.KardApi;
   import com.ankama.codegen.client.api.event.ApiClientEvent;
   import com.ankama.codegen.client.model.KardKard;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.HavenbagFurnituresManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.types.IFurniture;
   import com.ankamagames.atouin.types.miscs.HavenbagPackedInfos;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagClearAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagEditModeAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagExitAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagFurnitureSelectedAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagResetAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagRoomSelectedAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagSaveAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagThemeSelectedAction;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.HaapiKeyManager;
   import com.ankamagames.dofus.misc.utils.RpcServiceCenter;
   import com.ankamagames.dofus.misc.utils.events.ApiKeyReadyEvent;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.HaapiTokenTypeEnum;
   import com.ankamagames.dofus.network.enums.HavenBagDailyLoteryErrorEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.ChangeHavenBagRoomRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.ChangeThemeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.CloseHavenBagFurnitureSequenceRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.EditHavenBagCancelRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.EditHavenBagFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.EditHavenBagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.EditHavenBagStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.ExitHavenBagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.HavenBagDailyLoteryMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.HavenBagFurnituresMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.HavenBagFurnituresRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.OpenHavenBagFurnitureSequenceRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeWeightMessage;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalInformations;
   import com.ankamagames.dofus.types.entities.HavenbagFurnitureSprite;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   
   public class HavenbagFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HavenbagFrame));
      
      private static var _furnituresInEdit;
       
      
      private var _furnitureDragFrame:HavenbagFurnitureDragFrame;
      
      private var _isInEditMode:Boolean;
      
      private var _rightMouseIsDown:Boolean;
      
      private var _furnituresBeforeEdit:HavenbagPackedInfos;
      
      private var _currentRoomId:uint;
      
      private var _currentRoomThemeId:int;
      
      private var _ownerInfos:CharacterMinimalInformations;
      
      private var _previewCacheKey:String;
      
      private var _lotteryApi:KardApi;
      
      private var _furnituresDisplayed:uint = 0;
      
      private var _totalFurnituresToBeDisplayed:uint = 0;
      
      private var _consumeCallback:Callback;
      
      public function HavenbagFrame(param1:uint, param2:int, param3:CharacterMinimalInformations)
      {
         var _loc4_:CustomSharedObject = null;
         super();
         this._currentRoomId = param1;
         this._currentRoomThemeId = param2;
         this._ownerInfos = param3;
         if(!_furnituresInEdit)
         {
            _loc4_ = CustomSharedObject.getLocal("havenbag");
            if(_loc4_ && _loc4_.data)
            {
               _furnituresInEdit = _loc4_.data;
            }
         }
      }
      
      public function pushed() : Boolean
      {
         KernelEventsManager.getInstance().processCallback(HookList.HavenbagDisplayUi,true,this._currentRoomId,PlayedCharacterManager.getInstance().currentHavenbagTotalRooms,this._currentRoomThemeId,PlayerManager.getInstance().havenbagAvailableThemes,this._ownerInfos);
         this._previewCacheKey = PlayerManager.getInstance().server.id + "-" + PlayerManager.getInstance().accountId + "-" + this._currentRoomId + "-" + this._currentRoomThemeId;
         this._isInEditMode = false;
         this._rightMouseIsDown = false;
         PlayedCharacterManager.getInstance().isInHavenbag = true;
         PlayedCharacterManager.getInstance().isInHisHavenbag = this._ownerInfos.id == PlayedCharacterManager.getInstance().id;
         var _loc1_:ApiClient = new ApiClient();
         var _loc2_:String = RpcServiceCenter.getInstance().apiDomainExtension;
         _loc1_.setBasePath("https://haapi.ankama." + _loc2_ + "/json/Ankama/v2");
         this._lotteryApi = new KardApi(_loc1_);
         this._lotteryApi.getApiClient().addEventListener(ApiClientEvent.API_CALL_RESULT,this.onSuccess);
         this._lotteryApi.getApiClient().addEventListener(ApiClientEvent.API_CALL_ERROR,this.onError);
         return true;
      }
      
      public function pulled() : Boolean
      {
         KernelEventsManager.getInstance().processCallback(HookList.HavenbagDisplayUi,false,0,0,0,null,null);
         if(this._isInEditMode)
         {
            this.exitEditMode();
         }
         PlayedCharacterManager.getInstance().isInHavenbag = false;
         PlayedCharacterManager.getInstance().isInHisHavenbag = false;
         this._lotteryApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_RESULT,this.onSuccess);
         this._lotteryApi.getApiClient().removeEventListener(ApiClientEvent.API_CALL_ERROR,this.onError);
         HaapiKeyManager.getInstance().removeEventListener(ApiKeyReadyEvent.READY,this.onApiKeyReady);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:HavenbagFurnitureSprite = null;
         var _loc3_:HavenbagEditModeAction = null;
         var _loc4_:HavenBagFurnituresMessage = null;
         var _loc5_:Array = null;
         var _loc6_:HavenbagPackedInfos = null;
         var _loc7_:OpenHavenBagFurnitureSequenceRequestMessage = null;
         var _loc8_:CloseHavenBagFurnitureSequenceRequestMessage = null;
         var _loc9_:HavenbagFurnitureSelectedAction = null;
         var _loc10_:MouseClickMessage = null;
         var _loc11_:IFurniture = null;
         var _loc12_:MouseRightUpMessage = null;
         var _loc13_:MouseOverMessage = null;
         var _loc14_:HavenbagThemeSelectedAction = null;
         var _loc15_:ChangeThemeRequestMessage = null;
         var _loc16_:HavenbagRoomSelectedAction = null;
         var _loc17_:ChangeHavenBagRoomRequestMessage = null;
         var _loc18_:ExitHavenBagRequestMessage = null;
         var _loc19_:ExchangeWeightMessage = null;
         var _loc20_:HavenBagDailyLoteryMessage = null;
         var _loc21_:EditHavenBagRequestMessage = null;
         var _loc22_:EditHavenBagCancelRequestMessage = null;
         var _loc23_:int = 0;
         var _loc24_:HavenbagFurnitureSprite = null;
         var _loc25_:int = 0;
         var _loc26_:HavenBagFurnituresRequestMessage = null;
         var _loc27_:EditHavenBagCancelRequestMessage = null;
         var _loc28_:String = null;
         switch(true)
         {
            case param1 is HavenbagEditModeAction:
               _loc3_ = param1 as HavenbagEditModeAction;
               if(_loc3_.isActive)
               {
                  _loc21_ = new EditHavenBagRequestMessage();
                  _loc21_.initEditHavenBagRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc21_);
               }
               else
               {
                  _loc22_ = new EditHavenBagCancelRequestMessage();
                  _loc22_.initEditHavenBagCancelRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc22_);
                  this.cacheFurnituresInPreview(HavenbagFurnituresManager.getInstance().pack());
                  this.restoreFurnitures(this._furnituresBeforeEdit);
               }
               return true;
            case param1 is EditHavenBagStartMessage:
               this.enterEditMode();
               return true;
            case param1 is EditHavenBagFinishedMessage:
               KernelEventsManager.getInstance().processCallback(HookList.HavenbagExitEditMode);
               this.exitEditMode();
               return true;
            case param1 is HavenBagFurnituresMessage:
               _loc4_ = param1 as HavenBagFurnituresMessage;
               HavenbagFurnituresManager.getInstance().removeAllFurnitures();
               this._totalFurnituresToBeDisplayed = _loc4_.furnituresInfos.length;
               _loc5_ = new Array();
               _loc23_ = 0;
               while(_loc23_ < this._totalFurnituresToBeDisplayed)
               {
                  _loc2_ = new HavenbagFurnitureSprite(_loc4_.furnituresInfos[_loc23_].funitureId,this.onFurnitureDisplayed);
                  _loc2_.position.cellId = _loc4_.furnituresInfos[_loc23_].cellId;
                  _loc2_.orientation = _loc4_.furnituresInfos[_loc23_].orientation;
                  if(_loc2_.layerId == 1)
                  {
                     HavenbagFurnituresManager.getInstance().addFurniture(_loc2_);
                  }
                  else
                  {
                     _loc5_.push(_loc2_);
                  }
                  _loc23_++;
               }
               for each(_loc24_ in _loc5_)
               {
                  HavenbagFurnituresManager.getInstance().addFurniture(_loc24_);
               }
               HavenbagFurnituresManager.getInstance().updateMovOnFurnitureCells();
               if(!this._totalFurnituresToBeDisplayed)
               {
                  Atouin.getInstance().showWorld(true);
               }
               return true;
            case param1 is HavenbagClearAction:
               HavenbagFurnituresManager.getInstance().removeAllFurnitures();
               return true;
            case param1 is HavenbagResetAction:
               this.restoreFurnitures(this._furnituresBeforeEdit);
               return true;
            case param1 is HavenbagSaveAction:
               _loc6_ = HavenbagFurnituresManager.getInstance().pack();
               _loc7_ = new OpenHavenBagFurnitureSequenceRequestMessage();
               _loc7_.initOpenHavenBagFurnitureSequenceRequestMessage();
               ConnectionsHandler.getConnection().send(_loc7_);
               _loc25_ = 0;
               while(_loc25_ < _loc6_.furnitureCellIds.length)
               {
                  _loc26_ = new HavenBagFurnituresRequestMessage();
                  _loc26_.initHavenBagFurnituresRequestMessage(_loc6_.furnitureCellIds.slice(_loc25_,_loc25_ + ProtocolConstantsEnum.MAX_FURNITURES_PER_PACKET),_loc6_.furnitureTypeIds.slice(_loc25_,_loc25_ + ProtocolConstantsEnum.MAX_FURNITURES_PER_PACKET),_loc6_.furnitureOrientations.slice(_loc25_,_loc25_ + ProtocolConstantsEnum.MAX_FURNITURES_PER_PACKET));
                  ConnectionsHandler.getConnection().send(_loc26_);
                  _loc25_ = _loc25_ + ProtocolConstantsEnum.MAX_FURNITURES_PER_PACKET;
               }
               _loc8_ = new CloseHavenBagFurnitureSequenceRequestMessage();
               _loc8_.initCloseHavenBagFurnitureSequenceRequestMessage();
               ConnectionsHandler.getConnection().send(_loc8_);
               this.cacheFurnituresInPreview(null);
               return true;
            case param1 is HavenbagFurnitureSelectedAction:
               _loc9_ = param1 as HavenbagFurnitureSelectedAction;
               _log.debug("FurnitureTypeId " + _loc9_.furnitureTypeId + " selected");
               this.startDragFurniture(_loc9_.furnitureTypeId);
               return true;
            case param1 is MouseClickMessage:
               _loc10_ = param1 as MouseClickMessage;
               _loc11_ = _loc10_.target as IFurniture;
               if(this._isInEditMode && _loc11_ && !this._furnitureDragFrame)
               {
                  this.startDragFurniture(_loc11_.typeId,_loc11_.orientation,true);
                  HavenbagFurnituresManager.getInstance().removeFurniture(_loc11_.id);
                  return true;
               }
               return false;
            case param1 is MouseRightClickOutsideMessage:
            case param1 is MouseRightClickMessage:
               if(this._furnitureDragFrame)
               {
                  HavenbagFurnituresManager.getInstance().cancelPreviewFurniture(this._furnitureDragFrame.furniture);
                  Kernel.getWorker().removeFrame(this._furnitureDragFrame);
                  this._furnitureDragFrame = null;
                  return true;
               }
               if(this._isInEditMode)
               {
                  return true;
               }
               return false;
            case param1 is MouseRightDownMessage:
               this._rightMouseIsDown = true;
               return false;
            case param1 is MouseRightUpMessage:
               _loc12_ = param1 as MouseRightUpMessage;
               this._rightMouseIsDown = false;
               if(this._isInEditMode)
               {
                  if(_loc12_.target is IFurniture && (_loc12_.target as IFurniture).displayed)
                  {
                     if(HumanInputHandler.getInstance().getKeyboardPoll().isDown(Keyboard.SHIFT))
                     {
                        HavenbagFurnituresManager.getInstance().removeFurnituresOnCell((_loc12_.target as IFurniture).position.cellId);
                     }
                     else
                     {
                        HavenbagFurnituresManager.getInstance().removeFurniture((_loc12_.target as IFurniture).id);
                     }
                     return true;
                  }
               }
               return false;
            case param1 is MouseOverMessage:
               _loc13_ = param1 as MouseOverMessage;
               if(!this._furnitureDragFrame && this._isInEditMode && _loc13_.target is IFurniture && (_loc13_.target as IFurniture).displayed)
               {
                  if(this._rightMouseIsDown)
                  {
                     if(HumanInputHandler.getInstance().getKeyboardPoll().isDown(Keyboard.SHIFT))
                     {
                        HavenbagFurnituresManager.getInstance().removeFurnituresOnCell((_loc13_.target as IFurniture).position.cellId);
                     }
                     else
                     {
                        HavenbagFurnituresManager.getInstance().removeFurniture((_loc13_.target as IFurniture).id);
                     }
                  }
                  else
                  {
                     (_loc13_.target as IFurniture).displayHighlight(true);
                  }
                  return true;
               }
               return false;
            case param1 is MouseOutMessage:
               if(this._isInEditMode && param1["target"] is IFurniture)
               {
                  (param1["target"] as IFurniture).displayHighlight(false);
                  return true;
               }
               return false;
            case param1 is HavenbagThemeSelectedAction:
               _loc14_ = param1 as HavenbagThemeSelectedAction;
               this.cacheFurnituresInPreview(HavenbagFurnituresManager.getInstance().pack());
               _loc15_ = new ChangeThemeRequestMessage();
               _loc15_.initChangeThemeRequestMessage(_loc14_.themeId);
               ConnectionsHandler.getConnection().send(_loc15_);
               return true;
            case param1 is HavenbagRoomSelectedAction:
               _loc16_ = param1 as HavenbagRoomSelectedAction;
               _loc17_ = new ChangeHavenBagRoomRequestMessage();
               _loc17_.initChangeHavenBagRoomRequestMessage(_loc16_.room);
               ConnectionsHandler.getConnection().send(_loc17_);
               return true;
            case param1 is HavenbagExitAction:
               if(this._isInEditMode)
               {
                  _loc27_ = new EditHavenBagCancelRequestMessage();
                  _loc27_.initEditHavenBagCancelRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc27_);
                  this.cacheFurnituresInPreview(HavenbagFurnituresManager.getInstance().pack());
               }
               _loc18_ = new ExitHavenBagRequestMessage();
               _loc18_.initExitHavenBagRequestMessage();
               ConnectionsHandler.getConnection().send(_loc18_);
               return true;
            case param1 is CellClickMessage:
               return this._isInEditMode;
            case param1 is ExchangeWeightMessage:
               _loc19_ = param1 as ExchangeWeightMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeWeight,_loc19_.currentWeight,_loc19_.maxWeight);
               return true;
            case param1 is HavenBagDailyLoteryMessage:
               _loc20_ = param1 as HavenBagDailyLoteryMessage;
               if(_loc20_.returnType == HavenBagDailyLoteryErrorEnum.HAVENBAG_DAILY_LOTERY_OK && this._lotteryApi.hasOwnProperty("consumeByIdApiCall"))
               {
                  this._consumeCallback = new Callback(this._lotteryApi["consumeByIdApiCall"],XmlConfig.getInstance().getEntry("config.lang.current"),parseFloat(_loc20_.tokenId),HaapiKeyManager.GAME_ID);
                  HaapiKeyManager.getInstance().removeEventListener(ApiKeyReadyEvent.READY,this.onApiKeyReady);
                  HaapiKeyManager.getInstance().addEventListener(ApiKeyReadyEvent.READY,this.onApiKeyReady);
                  HaapiKeyManager.getInstance().askApiKey(HaapiTokenTypeEnum.HAAPI_APIKEY_GENERIC);
               }
               else
               {
                  _loc28_ = _loc20_.returnType == HavenBagDailyLoteryErrorEnum.HAVENBAG_DAILY_LOTERY_ALREADYUSED?"ui.havenbag.lottery.alreadyUsed":"ui.common.error";
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText(_loc28_),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function get isInEditMode() : Boolean
      {
         return this._isInEditMode;
      }
      
      public function clearFurnitureDragFrame() : void
      {
         this._furnitureDragFrame = null;
      }
      
      private function startDragFurniture(param1:uint, param2:uint = 0, param3:Boolean = false) : void
      {
         if(this._furnitureDragFrame)
         {
            this._furnitureDragFrame.clear();
         }
         this._furnitureDragFrame = new HavenbagFurnitureDragFrame(param1,param2,this,param3);
         Kernel.getWorker().addFrame(this._furnitureDragFrame);
      }
      
      private function enterEditMode() : void
      {
         this._isInEditMode = true;
         this._furnituresBeforeEdit = HavenbagFurnituresManager.getInstance().pack();
         if(_furnituresInEdit[this._previewCacheKey])
         {
            this.restoreFurnitures(HavenbagPackedInfos.createFromSharedObject(_furnituresInEdit[this._previewCacheKey]));
         }
         InteractiveCellManager.getInstance().show(true);
         HavenbagFurnituresManager.getInstance().enableMouseEvents();
         HavenbagFurnituresManager.getInstance().allowMovOnFurnitureCells();
         EntitiesManager.getInstance().setEntitiesVisibility(false);
         (Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame).enableInteractiveElements(false);
      }
      
      private function exitEditMode() : void
      {
         this._isInEditMode = false;
         this._furnituresBeforeEdit = null;
         InteractiveCellManager.getInstance().show(Atouin.getInstance().options.alwaysShowGrid);
         if(this._furnitureDragFrame)
         {
            Kernel.getWorker().removeFrame(this._furnitureDragFrame);
            this._furnitureDragFrame = null;
         }
         HavenbagFurnituresManager.getInstance().disableMouseEvents();
         HavenbagFurnituresManager.getInstance().updateMovOnFurnitureCells();
         EntitiesManager.getInstance().setEntitiesVisibility(true);
         if(Kernel.getWorker().contains(RoleplayInteractivesFrame))
         {
            (Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame).enableInteractiveElements(true);
         }
      }
      
      private function restoreFurnitures(param1:HavenbagPackedInfos) : void
      {
         var _loc2_:HavenbagFurnitureSprite = null;
         HavenbagFurnituresManager.getInstance().removeAllFurnitures();
         var _loc3_:int = 0;
         while(_loc3_ < param1.furnitureTypeIds.length)
         {
            _loc2_ = new HavenbagFurnitureSprite(param1.furnitureTypeIds[_loc3_]);
            _loc2_.position.cellId = param1.furnitureCellIds[_loc3_];
            _loc2_.orientation = param1.furnitureOrientations[_loc3_];
            HavenbagFurnituresManager.getInstance().addFurniture(_loc2_);
            _loc3_++;
         }
         HavenbagFurnituresManager.getInstance().enableMouseEvents();
      }
      
      private function cacheFurnituresInPreview(param1:HavenbagPackedInfos) : void
      {
         _furnituresInEdit[this._previewCacheKey] = param1;
         var _loc2_:CustomSharedObject = CustomSharedObject.getLocal("havenbag");
         if(_loc2_)
         {
            if(!_loc2_.data)
            {
               _loc2_.data = new Object();
            }
            _loc2_.data[this._previewCacheKey] = param1;
            _loc2_.flush();
         }
      }
      
      private function onApiKeyReady(param1:ApiKeyReadyEvent) : void
      {
         if(param1.haapiKeyType == HaapiTokenTypeEnum.HAAPI_APIKEY_GENERIC)
         {
            this._lotteryApi.getApiClient().setApiKey(param1.haapiKey);
            if(this._consumeCallback)
            {
               this._consumeCallback.exec();
               this._consumeCallback = null;
            }
         }
      }
      
      private function onSuccess(param1:ApiClientEvent) : void
      {
         var _loc2_:KardKard = null;
         if(param1.result is Array && param1.result.length == 1 && param1.result[0] is KardKard)
         {
            _loc2_ = param1.result[0] as KardKard;
            KernelEventsManager.getInstance().processCallback(HookList.HavenBagLotteryGift,_loc2_.description);
         }
      }
      
      private function onError(param1:ApiClientEvent) : void
      {
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.common.error"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
         _log.error(param1.errorMsg);
         throw new Error(param1.errorMsg);
      }
      
      private function onFurnitureDisplayed() : void
      {
         this._furnituresDisplayed++;
         if(this._furnituresDisplayed == this._totalFurnituresToBeDisplayed)
         {
            Atouin.getInstance().showWorld(true);
         }
      }
   }
}
