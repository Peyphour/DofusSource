package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.TradeStockItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectModifyPricedAction;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.LeaveDialogRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectModifyPricedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMovementRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMovementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMultiMovementRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMultiMovementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkHumanVendorMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSell;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInHumanVendorShop;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class HumanVendorManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HumanVendorManagementFrame));
       
      
      private var _success:Boolean = false;
      
      private var _shopStock:Array;
      
      public function HumanVendorManagementFrame()
      {
         super();
         this._shopStock = new Array();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get commonExchangeManagementFrame() : CommonExchangeManagementFrame
      {
         return Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
      }
      
      public function pushed() : Boolean
      {
         this._success = false;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:TradeStockItemWrapper = null;
         var _loc3_:ExchangeStartOkHumanVendorMessage = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:ExchangeShopStockStartedMessage = null;
         var _loc7_:ExchangeObjectModifyPricedAction = null;
         var _loc8_:ExchangeObjectModifyPricedMessage = null;
         var _loc9_:ExchangeShopStockMovementUpdatedMessage = null;
         var _loc10_:ItemWrapper = null;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         var _loc13_:ExchangeShopStockMovementRemovedMessage = null;
         var _loc14_:ExchangeShopStockMultiMovementUpdatedMessage = null;
         var _loc15_:ExchangeShopStockMultiMovementRemovedMessage = null;
         var _loc16_:ExchangeLeaveMessage = null;
         var _loc17_:ObjectItemToSellInHumanVendorShop = null;
         var _loc18_:ObjectItemToSell = null;
         var _loc19_:int = 0;
         var _loc20_:ObjectItemToSell = null;
         var _loc21_:Boolean = false;
         var _loc22_:uint = 0;
         switch(true)
         {
            case param1 is ExchangeStartOkHumanVendorMessage:
               _loc3_ = param1 as ExchangeStartOkHumanVendorMessage;
               _loc4_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc3_.sellerId);
               PlayedCharacterManager.getInstance().isInExchange = true;
               if(_loc4_ == null)
               {
                  _log.error("Impossible de trouver le personnage vendeur dans l\'entitiesFrame");
                  return true;
               }
               _loc5_ = (_loc4_ as GameRolePlayMerchantInformations).name;
               this._shopStock = new Array();
               for each(_loc17_ in _loc3_.objectsInfos)
               {
                  _loc2_ = TradeStockItemWrapper.createFromObjectItemToSell(_loc17_);
                  this._shopStock.push(_loc2_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeStartOkHumanVendor,_loc5_,this._shopStock,EntitiesLooksManager.getInstance().getTiphonEntityLook(_loc3_.sellerId));
               return true;
            case param1 is ExchangeShopStockStartedMessage:
               _loc6_ = param1 as ExchangeShopStockStartedMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               this._shopStock = new Array();
               for each(_loc18_ in _loc6_.objectsInfos)
               {
                  _loc2_ = TradeStockItemWrapper.createFromObjectItemToSell(_loc18_);
                  _log.debug(" - " + _loc2_.itemWrapper.name);
                  this._shopStock.push(_loc2_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockStarted,this._shopStock);
               return true;
            case param1 is ExchangeObjectModifyPricedAction:
               _loc7_ = param1 as ExchangeObjectModifyPricedAction;
               _loc8_ = new ExchangeObjectModifyPricedMessage();
               _loc8_.initExchangeObjectModifyPricedMessage(_loc7_.objectUID,_loc7_.quantity,_loc7_.price);
               ConnectionsHandler.getConnection().send(_loc8_);
               return true;
            case param1 is ExchangeShopStockMovementUpdatedMessage:
               _loc9_ = param1 as ExchangeShopStockMovementUpdatedMessage;
               _loc10_ = ItemWrapper.create(0,_loc9_.objectInfo.objectUID,_loc9_.objectInfo.objectGID,_loc9_.objectInfo.quantity,_loc9_.objectInfo.effects,false);
               _loc11_ = _loc9_.objectInfo.objectPrice;
               _loc12_ = true;
               _loc19_ = 0;
               while(_loc19_ < this._shopStock.length)
               {
                  if(this._shopStock[_loc19_].itemWrapper.objectUID == _loc10_.objectUID)
                  {
                     if(_loc10_.quantity > this._shopStock[_loc19_].itemWrapper.quantity)
                     {
                        KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockAddQuantity);
                     }
                     else
                     {
                        KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockRemoveQuantity);
                     }
                     _loc2_ = TradeStockItemWrapper.create(_loc10_,_loc11_);
                     this._shopStock.splice(_loc19_,1,_loc2_);
                     _loc12_ = false;
                     break;
                  }
                  _loc19_++;
               }
               if(_loc12_)
               {
                  _loc2_ = TradeStockItemWrapper.create(_loc10_,_loc9_.objectInfo.objectPrice);
                  this._shopStock.push(_loc2_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockUpdate,this._shopStock,_loc10_);
               return true;
            case param1 is ExchangeShopStockMovementRemovedMessage:
               _loc13_ = param1 as ExchangeShopStockMovementRemovedMessage;
               _loc19_ = 0;
               while(_loc19_ < this._shopStock.length)
               {
                  if(this._shopStock[_loc19_].itemWrapper.objectUID == _loc13_.objectId)
                  {
                     this._shopStock.splice(_loc19_,1);
                     break;
                  }
                  _loc19_++;
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockUpdate,this._shopStock,null);
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockMovementRemoved,_loc13_.objectId);
               return true;
            case param1 is ExchangeShopStockMultiMovementUpdatedMessage:
               _loc14_ = param1 as ExchangeShopStockMultiMovementUpdatedMessage;
               for each(_loc20_ in _loc14_.objectInfoList)
               {
                  _loc10_ = ItemWrapper.create(0,_loc20_.objectUID,_loc9_.objectInfo.objectGID,_loc20_.quantity,_loc20_.effects,false);
                  _loc21_ = true;
                  _loc19_ = 0;
                  while(_loc19_ < this._shopStock.length)
                  {
                     if(this._shopStock[_loc19_].itemWrapper.objectUID == _loc10_.objectUID)
                     {
                        _loc2_ = TradeStockItemWrapper.create(_loc10_,_loc9_.objectInfo.objectPrice);
                        this._shopStock.splice(_loc19_,1,_loc2_);
                        _loc21_ = false;
                        break;
                     }
                     _loc19_++;
                  }
                  if(_loc21_)
                  {
                     _loc2_ = TradeStockItemWrapper.create(_loc10_,_loc9_.objectInfo.objectPrice);
                     this._shopStock.push(_loc2_);
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockUpdate,this._shopStock);
               return true;
            case param1 is ExchangeShopStockMultiMovementRemovedMessage:
               _loc15_ = param1 as ExchangeShopStockMultiMovementRemovedMessage;
               for each(_loc22_ in _loc15_.objectIdList)
               {
                  _loc19_ = 0;
                  while(_loc19_ < this._shopStock.length)
                  {
                     if(this._shopStock[_loc19_].itemWrapper.objectUID == _loc22_)
                     {
                        this._shopStock.splice(_loc19_,1);
                        break;
                     }
                     _loc19_++;
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockMouvmentRemoveOk,_loc13_.objectId);
               return true;
            case param1 is LeaveDialogRequestAction:
               ConnectionsHandler.getConnection().send(new LeaveDialogRequestMessage());
               return true;
            case param1 is ExchangeLeaveMessage:
               _loc16_ = param1 as ExchangeLeaveMessage;
               if(_loc16_.dialogType == DialogTypeEnum.DIALOG_EXCHANGE)
               {
                  PlayedCharacterManager.getInstance().isInExchange = false;
                  this._success = _loc16_.success;
                  Kernel.getWorker().removeFrame(this);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CommonExchangeManagementFrame));
         }
         KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave,this._success);
         this._shopStock = null;
         return true;
      }
   }
}
