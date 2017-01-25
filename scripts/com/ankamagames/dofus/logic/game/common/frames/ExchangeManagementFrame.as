package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.items.criterion.GroupItemCriterion;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.TradeStockItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.common.actions.LeaveDialogAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveKamaAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertAllFromInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertAllToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertExistingFromInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertExistingToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListFromInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListWithQuantityToInvAction;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.LeaveDialogRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveKamaMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertAllFromInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertAllToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertExistingFromInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertExistingToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertListFromInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertListToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertListWithQuantityToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkRecycleTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkRunesTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedTaxCollectorShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedWithPodsMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedWithStorageMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.RecycleResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageInventoryContentMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageKamasUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsUpdateMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInNpcShop;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class ExchangeManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ExchangeManagementFrame));
       
      
      private const NUGGET_GID:int = 14635;
      
      private var _priority:int = 0;
      
      private var _sourceInformations:GameRolePlayNamedActorInformations;
      
      private var _targetInformations:GameRolePlayNamedActorInformations;
      
      private var _meReady:Boolean = false;
      
      private var _youReady:Boolean = false;
      
      private var _exchangeInventory:Array;
      
      private var _success:Boolean;
      
      public function ExchangeManagementFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get roleplayEntitiesFrame() : RoleplayEntitiesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
      }
      
      private function get roleplayMovementFrame() : RoleplayMovementFrame
      {
         return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
      }
      
      public function initBankStock(param1:Vector.<ObjectItem>) : void
      {
         InventoryManager.getInstance().bankInventory.initializeFromObjectItems(param1);
         InventoryManager.getInstance().bankInventory.releaseHooks();
      }
      
      public function processExchangeRequestedTradeMessage(param1:ExchangeRequestedTradeMessage) : void
      {
         var _loc4_:SocialFrame = null;
         var _loc5_:LeaveDialogAction = null;
         if(param1.exchangeType != ExchangeTypeEnum.PLAYER_TRADE)
         {
            return;
         }
         this._sourceInformations = this.roleplayEntitiesFrame.getEntityInfos(param1.source) as GameRolePlayNamedActorInformations;
         this._targetInformations = this.roleplayEntitiesFrame.getEntityInfos(param1.target) as GameRolePlayNamedActorInformations;
         var _loc2_:String = this._sourceInformations.name;
         var _loc3_:String = this._targetInformations.name;
         if(param1.source == PlayedCharacterManager.getInstance().id)
         {
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterFromMe,_loc2_,_loc3_);
         }
         else
         {
            _loc4_ = Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
            if(_loc4_ && _loc4_.isIgnored(_loc2_))
            {
               _loc5_ = new LeaveDialogAction();
               Kernel.getWorker().process(_loc5_);
               return;
            }
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterToMe,_loc3_,_loc2_);
         }
      }
      
      public function processExchangeStartOkNpcTradeMessage(param1:ExchangeStartOkNpcTradeMessage) : void
      {
         var _loc2_:String = PlayedCharacterManager.getInstance().infos.name;
         var _loc3_:int = this.roleplayEntitiesFrame.getEntityInfos(param1.npcId).contextualId;
         var _loc4_:Npc = Npc.getNpcById(_loc3_);
         var _loc5_:String = Npc.getNpcById((this.roleplayEntitiesFrame.getEntityInfos(param1.npcId) as GameRolePlayNpcInformations).npcId).name;
         var _loc6_:TiphonEntityLook = EntityLookAdapter.getRiderLook(PlayedCharacterManager.getInstance().infos.entityLook);
         var _loc7_:TiphonEntityLook = EntityLookAdapter.getRiderLook(this.roleplayContextFrame.entitiesFrame.getEntityInfos(param1.npcId).look);
         var _loc8_:ExchangeStartOkNpcTradeMessage = param1 as ExchangeStartOkNpcTradeMessage;
         PlayedCharacterManager.getInstance().isInExchange = true;
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcTrade,_loc8_.npcId,_loc2_,_loc5_,_loc6_,_loc7_);
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,ExchangeTypeEnum.NPC_TRADE);
      }
      
      public function processExchangeStartOkRunesTradeMessage(param1:ExchangeStartOkRunesTradeMessage) : void
      {
         var _loc2_:ExchangeStartOkRunesTradeMessage = param1 as ExchangeStartOkRunesTradeMessage;
         PlayedCharacterManager.getInstance().isInExchange = true;
         this._kernelEventsManager.processCallback(CraftHookList.ExchangeStartOkRunesTrade);
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,ExchangeTypeEnum.RUNES_TRADE);
      }
      
      public function processExchangeStartOkRecycleTradeMessage(param1:ExchangeStartOkRecycleTradeMessage) : void
      {
         var _loc2_:ExchangeStartOkRecycleTradeMessage = param1 as ExchangeStartOkRecycleTradeMessage;
         PlayedCharacterManager.getInstance().isInExchange = true;
         this._kernelEventsManager.processCallback(CraftHookList.ExchangeStartOkRecycleTrade,_loc2_.percentToPlayer,_loc2_.percentToPrism);
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,ExchangeTypeEnum.RECYCLE_TRADE);
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ExchangeStartedWithStorageMessage = null;
         var _loc5_:CommonExchangeManagementFrame = null;
         var _loc6_:int = 0;
         var _loc7_:ExchangeStartedMessage = null;
         var _loc8_:CommonExchangeManagementFrame = null;
         var _loc9_:ExchangeStartedTaxCollectorShopMessage = null;
         var _loc10_:StorageInventoryContentMessage = null;
         var _loc11_:StorageObjectUpdateMessage = null;
         var _loc12_:ObjectItem = null;
         var _loc13_:ItemWrapper = null;
         var _loc14_:StorageObjectRemoveMessage = null;
         var _loc15_:StorageObjectsUpdateMessage = null;
         var _loc16_:StorageObjectsRemoveMessage = null;
         var _loc17_:StorageKamasUpdateMessage = null;
         var _loc18_:ExchangeObjectMoveKamaAction = null;
         var _loc19_:ExchangeObjectMoveKamaMessage = null;
         var _loc20_:ExchangeObjectTransfertAllToInvAction = null;
         var _loc21_:ExchangeObjectTransfertAllToInvMessage = null;
         var _loc22_:ExchangeObjectTransfertListToInvAction = null;
         var _loc23_:ExchangeObjectTransfertListWithQuantityToInvAction = null;
         var _loc24_:ExchangeObjectTransfertExistingToInvAction = null;
         var _loc25_:ExchangeObjectTransfertExistingToInvMessage = null;
         var _loc26_:ExchangeObjectTransfertAllFromInvAction = null;
         var _loc27_:ExchangeObjectTransfertAllFromInvMessage = null;
         var _loc28_:ExchangeObjectTransfertListFromInvAction = null;
         var _loc29_:ExchangeObjectTransfertExistingFromInvAction = null;
         var _loc30_:ExchangeObjectTransfertExistingFromInvMessage = null;
         var _loc31_:ExchangeStartOkNpcShopMessage = null;
         var _loc32_:GameContextActorInformations = null;
         var _loc33_:TiphonEntityLook = null;
         var _loc34_:Array = null;
         var _loc35_:ExchangeStartOkRunesTradeMessage = null;
         var _loc36_:ExchangeStartOkRecycleTradeMessage = null;
         var _loc37_:RecycleResultMessage = null;
         var _loc38_:ExchangeLeaveMessage = null;
         var _loc39_:String = null;
         var _loc40_:String = null;
         var _loc41_:TiphonEntityLook = null;
         var _loc42_:TiphonEntityLook = null;
         var _loc43_:ExchangeStartedWithPodsMessage = null;
         var _loc44_:int = 0;
         var _loc45_:int = 0;
         var _loc46_:int = 0;
         var _loc47_:int = 0;
         var _loc48_:Number = NaN;
         var _loc49_:ObjectItem = null;
         var _loc50_:ObjectItem = null;
         var _loc51_:ItemWrapper = null;
         var _loc52_:uint = 0;
         var _loc53_:ExchangeObjectTransfertListToInvMessage = null;
         var _loc54_:ExchangeObjectTransfertListWithQuantityToInvMessage = null;
         var _loc55_:ExchangeObjectTransfertListFromInvMessage = null;
         var _loc56_:ObjectItemToSellInNpcShop = null;
         var _loc57_:ItemWrapper = null;
         var _loc58_:TradeStockItemWrapper = null;
         switch(true)
         {
            case param1 is ExchangeStartedWithStorageMessage:
               _loc4_ = param1 as ExchangeStartedWithStorageMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               _loc5_ = Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
               if(_loc5_)
               {
                  _loc5_.resetEchangeSequence();
               }
               _loc6_ = _loc4_.storageMaxSlot;
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeBankStartedWithStorage,_loc4_.exchangeType,_loc6_);
               return false;
            case param1 is ExchangeStartedMessage:
               _loc7_ = param1 as ExchangeStartedMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               _loc8_ = Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
               if(_loc8_)
               {
                  _loc8_.resetEchangeSequence();
               }
               switch(_loc7_.exchangeType)
               {
                  case ExchangeTypeEnum.PLAYER_TRADE:
                     _loc39_ = this._sourceInformations.name;
                     _loc40_ = this._targetInformations.name;
                     _loc41_ = EntityLookAdapter.getRiderLook(this._sourceInformations.look);
                     _loc42_ = EntityLookAdapter.getRiderLook(this._targetInformations.look);
                     if(_loc7_.getMessageId() == ExchangeStartedWithPodsMessage.protocolId)
                     {
                        _loc43_ = param1 as ExchangeStartedWithPodsMessage;
                     }
                     _loc44_ = -1;
                     _loc45_ = -1;
                     _loc46_ = -1;
                     _loc47_ = -1;
                     if(_loc43_ != null)
                     {
                        if(_loc43_.firstCharacterId == this._sourceInformations.contextualId)
                        {
                           _loc44_ = _loc43_.firstCharacterCurrentWeight;
                           _loc45_ = _loc43_.secondCharacterCurrentWeight;
                           _loc46_ = _loc43_.firstCharacterMaxWeight;
                           _loc47_ = _loc43_.secondCharacterMaxWeight;
                        }
                        else
                        {
                           _loc45_ = _loc43_.firstCharacterCurrentWeight;
                           _loc44_ = _loc43_.secondCharacterCurrentWeight;
                           _loc47_ = _loc43_.firstCharacterMaxWeight;
                           _loc46_ = _loc43_.secondCharacterMaxWeight;
                        }
                     }
                     if(PlayedCharacterManager.getInstance().id == _loc43_.firstCharacterId)
                     {
                        _loc48_ = _loc43_.secondCharacterId;
                     }
                     else
                     {
                        _loc48_ = _loc43_.firstCharacterId;
                     }
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStarted,_loc39_,_loc40_,_loc41_,_loc42_,_loc44_,_loc45_,_loc46_,_loc47_,_loc48_);
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,_loc7_.exchangeType);
                     return true;
                  case ExchangeTypeEnum.STORAGE:
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,_loc7_.exchangeType);
                     return true;
                  default:
                     return true;
               }
            case param1 is ExchangeStartedTaxCollectorShopMessage:
               _loc9_ = param1 as ExchangeStartedTaxCollectorShopMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               InventoryManager.getInstance().bankInventory.kamas = _loc9_.kamas;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeBankStarted,ExchangeTypeEnum.MOUNT,_loc9_.objects,_loc9_.kamas);
               return true;
            case param1 is StorageInventoryContentMessage:
               _loc10_ = param1 as StorageInventoryContentMessage;
               InventoryManager.getInstance().bankInventory.kamas = _loc10_.kamas;
               InventoryManager.getInstance().bankInventory.initializeFromObjectItems(_loc10_.objects);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return true;
            case param1 is StorageObjectUpdateMessage:
               _loc11_ = param1 as StorageObjectUpdateMessage;
               _loc12_ = _loc11_.object;
               _loc13_ = ItemWrapper.create(_loc12_.position,_loc12_.objectUID,_loc12_.objectGID,_loc12_.quantity,_loc12_.effects);
               InventoryManager.getInstance().bankInventory.modifyItem(_loc13_);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return true;
            case param1 is StorageObjectRemoveMessage:
               _loc14_ = param1 as StorageObjectRemoveMessage;
               InventoryManager.getInstance().bankInventory.removeItem(_loc14_.objectUID);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return true;
            case param1 is StorageObjectsUpdateMessage:
               _loc15_ = param1 as StorageObjectsUpdateMessage;
               for each(_loc49_ in _loc15_.objectList)
               {
                  _loc50_ = _loc49_;
                  _loc51_ = ItemWrapper.create(_loc50_.position,_loc50_.objectUID,_loc50_.objectGID,_loc50_.quantity,_loc50_.effects);
                  InventoryManager.getInstance().bankInventory.modifyItem(_loc51_);
               }
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return true;
            case param1 is StorageObjectsRemoveMessage:
               _loc16_ = param1 as StorageObjectsRemoveMessage;
               for each(_loc52_ in _loc16_.objectUIDList)
               {
                  InventoryManager.getInstance().bankInventory.removeItem(_loc52_);
               }
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return true;
            case param1 is StorageKamasUpdateMessage:
               _loc17_ = param1 as StorageKamasUpdateMessage;
               InventoryManager.getInstance().bankInventory.kamas = _loc17_.kamasTotal;
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageKamasUpdate,_loc17_.kamasTotal);
               return true;
            case param1 is ExchangeObjectMoveKamaAction:
               _loc18_ = param1 as ExchangeObjectMoveKamaAction;
               _loc19_ = new ExchangeObjectMoveKamaMessage();
               _loc19_.initExchangeObjectMoveKamaMessage(_loc18_.kamas);
               ConnectionsHandler.getConnection().send(_loc19_);
               return true;
            case param1 is ExchangeObjectTransfertAllToInvAction:
               _loc20_ = param1 as ExchangeObjectTransfertAllToInvAction;
               _loc21_ = new ExchangeObjectTransfertAllToInvMessage();
               _loc21_.initExchangeObjectTransfertAllToInvMessage();
               ConnectionsHandler.getConnection().send(_loc21_);
               return true;
            case param1 is ExchangeObjectTransfertListToInvAction:
               _loc22_ = param1 as ExchangeObjectTransfertListToInvAction;
               if(_loc22_.ids.length > ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.exchange.partialTransfert"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               if(_loc22_.ids.length >= ProtocolConstantsEnum.MIN_OBJ_COUNT_BY_XFERT)
               {
                  _loc53_ = new ExchangeObjectTransfertListToInvMessage();
                  _loc53_.initExchangeObjectTransfertListToInvMessage(_loc22_.ids.slice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT));
                  ConnectionsHandler.getConnection().send(_loc53_);
               }
               return true;
            case param1 is ExchangeObjectTransfertListWithQuantityToInvAction:
               _loc23_ = param1 as ExchangeObjectTransfertListWithQuantityToInvAction;
               if(_loc23_.ids.length > ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT / 2)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.exchange.partialTransfert"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               if(_loc23_.ids.length >= ProtocolConstantsEnum.MIN_OBJ_COUNT_BY_XFERT && _loc23_.ids.length == _loc23_.qtys.length)
               {
                  _loc54_ = new ExchangeObjectTransfertListWithQuantityToInvMessage();
                  _loc54_.initExchangeObjectTransfertListWithQuantityToInvMessage(_loc23_.ids.slice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT / 2),_loc23_.qtys.slice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT / 2));
                  ConnectionsHandler.getConnection().send(_loc54_);
               }
               return true;
            case param1 is ExchangeObjectTransfertExistingToInvAction:
               _loc24_ = param1 as ExchangeObjectTransfertExistingToInvAction;
               _loc25_ = new ExchangeObjectTransfertExistingToInvMessage();
               _loc25_.initExchangeObjectTransfertExistingToInvMessage();
               ConnectionsHandler.getConnection().send(_loc25_);
               return true;
            case param1 is ExchangeObjectTransfertAllFromInvAction:
               _loc26_ = param1 as ExchangeObjectTransfertAllFromInvAction;
               _loc27_ = new ExchangeObjectTransfertAllFromInvMessage();
               _loc27_.initExchangeObjectTransfertAllFromInvMessage();
               ConnectionsHandler.getConnection().send(_loc27_);
               return true;
            case param1 is ExchangeObjectTransfertListFromInvAction:
               _loc28_ = param1 as ExchangeObjectTransfertListFromInvAction;
               if(_loc28_.ids.length > ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.exchange.partialTransfert"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               if(_loc28_.ids.length >= ProtocolConstantsEnum.MIN_OBJ_COUNT_BY_XFERT)
               {
                  _loc55_ = new ExchangeObjectTransfertListFromInvMessage();
                  _loc55_.initExchangeObjectTransfertListFromInvMessage(_loc28_.ids.slice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT));
                  ConnectionsHandler.getConnection().send(_loc55_);
               }
               return true;
            case param1 is ExchangeObjectTransfertExistingFromInvAction:
               _loc29_ = param1 as ExchangeObjectTransfertExistingFromInvAction;
               _loc30_ = new ExchangeObjectTransfertExistingFromInvMessage();
               _loc30_.initExchangeObjectTransfertExistingFromInvMessage();
               ConnectionsHandler.getConnection().send(_loc30_);
               return true;
            case param1 is ExchangeStartOkNpcShopMessage:
               _loc31_ = param1 as ExchangeStartOkNpcShopMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false,true));
               _loc32_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc31_.npcSellerId);
               _loc33_ = EntityLookAdapter.getRiderLook(_loc32_.look);
               _loc34_ = new Array();
               for each(_loc56_ in _loc31_.objectsInfos)
               {
                  _loc57_ = ItemWrapper.create(63,0,_loc56_.objectGID,0,_loc56_.effects,false);
                  _loc58_ = TradeStockItemWrapper.create(_loc57_,_loc56_.objectPrice,new GroupItemCriterion(_loc56_.buyCriterion));
                  _loc34_.push(_loc58_);
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcShop,_loc31_.npcSellerId,_loc34_,_loc33_,_loc31_.tokenId);
               return true;
            case param1 is ExchangeStartOkRunesTradeMessage:
               _loc35_ = param1 as ExchangeStartOkRunesTradeMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkRunesTrade);
               return true;
            case param1 is ExchangeStartOkRecycleTradeMessage:
               _loc36_ = param1 as ExchangeStartOkRecycleTradeMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkRecycleTrade,_loc36_.percentToPlayer,_loc36_.percentToPrism);
               return true;
            case param1 is RecycleResultMessage:
               _loc37_ = param1 as RecycleResultMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.RecycleResult,_loc37_.nuggetsForPlayer,_loc37_.nuggetsForPrism);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.recycle.resultDetailed",[_loc37_.nuggetsForPlayer,_loc37_.nuggetsForPrism,"{item," + this.NUGGET_GID + "}"]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is LeaveDialogRequestAction:
               ConnectionsHandler.getConnection().send(new LeaveDialogRequestMessage());
               return true;
            case param1 is ExchangeLeaveMessage:
               _loc38_ = param1 as ExchangeLeaveMessage;
               if(_loc38_.dialogType == DialogTypeEnum.DIALOG_EXCHANGE)
               {
                  PlayedCharacterManager.getInstance().isInExchange = false;
                  this._success = _loc38_.success;
                  Kernel.getWorker().removeFrame(this);
               }
               return true;
            default:
               return false;
         }
      }
      
      private function proceedExchange() : void
      {
      }
      
      public function pushed() : Boolean
      {
         this._success = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         if(Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CommonExchangeManagementFrame));
         }
         KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave,this._success);
         this._exchangeInventory = null;
         return true;
      }
      
      private function get _kernelEventsManager() : KernelEventsManager
      {
         return KernelEventsManager.getInstance();
      }
   }
}
