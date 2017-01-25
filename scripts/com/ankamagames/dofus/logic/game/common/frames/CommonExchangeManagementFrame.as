package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeAcceptAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeReadyAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeReadyCrushAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRefuseAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.LeaveShopStockAction;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeAcceptMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeIsReadyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectsAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReadyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.FocusedExchangeReadyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeKamaModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectsModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectsRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangePodsModifiedMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class CommonExchangeManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CommonExchangeManagementFrame));
       
      
      private var _exchangeType:uint;
      
      private var _numCurrentSequence:int;
      
      public function CommonExchangeManagementFrame(param1:uint)
      {
         super();
         this._exchangeType = param1;
         this._numCurrentSequence = 0;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get craftFrame() : CraftFrame
      {
         return Kernel.getWorker().getFrame(CraftFrame) as CraftFrame;
      }
      
      public function incrementEchangeSequence() : void
      {
         this._numCurrentSequence++;
      }
      
      public function resetEchangeSequence() : void
      {
         this._numCurrentSequence = 0;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:LeaveDialogRequestMessage = null;
         var _loc3_:BidHouseManagementFrame = null;
         var _loc4_:ExchangeAcceptMessage = null;
         var _loc5_:LeaveDialogRequestMessage = null;
         var _loc6_:ExchangeReadyAction = null;
         var _loc7_:ExchangeReadyMessage = null;
         var _loc8_:ExchangeReadyCrushAction = null;
         var _loc9_:FocusedExchangeReadyMessage = null;
         var _loc10_:ExchangeObjectModifiedMessage = null;
         var _loc11_:ItemWrapper = null;
         var _loc12_:ExchangeObjectsModifiedMessage = null;
         var _loc13_:Array = null;
         var _loc14_:ExchangeObjectAddedMessage = null;
         var _loc15_:ItemWrapper = null;
         var _loc16_:ExchangeObjectsAddedMessage = null;
         var _loc17_:Array = null;
         var _loc18_:ExchangeObjectRemovedMessage = null;
         var _loc19_:ExchangeObjectsRemovedMessage = null;
         var _loc20_:Array = null;
         var _loc21_:uint = 0;
         var _loc22_:ExchangeObjectMoveAction = null;
         var _loc23_:ItemWrapper = null;
         var _loc24_:ExchangeObjectMoveMessage = null;
         var _loc25_:ExchangeIsReadyMessage = null;
         var _loc26_:RoleplayEntitiesFrame = null;
         var _loc27_:String = null;
         var _loc28_:ExchangeKamaModifiedMessage = null;
         var _loc29_:ExchangePodsModifiedMessage = null;
         var _loc30_:ObjectItem = null;
         var _loc31_:ItemWrapper = null;
         var _loc32_:ObjectItem = null;
         var _loc33_:ItemWrapper = null;
         switch(true)
         {
            case param1 is LeaveShopStockAction:
               _loc2_ = new LeaveDialogRequestMessage();
               _loc2_.initLeaveDialogRequestMessage();
               _loc3_ = Kernel.getWorker().getFrame(BidHouseManagementFrame) as BidHouseManagementFrame;
               if(_loc3_)
               {
                  _loc3_.switching = false;
               }
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is ExchangeAcceptAction:
               _loc4_ = new ExchangeAcceptMessage();
               _loc4_.initExchangeAcceptMessage();
               ConnectionsHandler.getConnection().send(_loc4_);
               return true;
            case param1 is ExchangeRefuseAction:
               _loc5_ = new LeaveDialogRequestMessage();
               _loc5_.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is ExchangeReadyAction:
               _loc6_ = param1 as ExchangeReadyAction;
               _loc7_ = new ExchangeReadyMessage();
               _loc7_.initExchangeReadyMessage(_loc6_.isReady,this._numCurrentSequence);
               ConnectionsHandler.getConnection().send(_loc7_);
               return true;
            case param1 is ExchangeReadyCrushAction:
               _loc8_ = param1 as ExchangeReadyCrushAction;
               _loc9_ = new FocusedExchangeReadyMessage();
               _loc9_.initFocusedExchangeReadyMessage(_loc8_.isReady,this._numCurrentSequence,_loc8_.focusActionId);
               ConnectionsHandler.getConnection().send(_loc9_);
               return true;
            case param1 is ExchangeObjectModifiedMessage:
               _loc10_ = param1 as ExchangeObjectModifiedMessage;
               this._numCurrentSequence++;
               _loc11_ = ItemWrapper.create(_loc10_.object.position,_loc10_.object.objectUID,_loc10_.object.objectGID,_loc10_.object.quantity,_loc10_.object.effects,false);
               switch(this._exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                     this.craftFrame.modifyCraftComponent(_loc10_.remote,_loc11_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectModified,_loc11_,_loc10_.remote);
               return true;
            case param1 is ExchangeObjectsModifiedMessage:
               _loc12_ = param1 as ExchangeObjectsModifiedMessage;
               this._numCurrentSequence++;
               _loc13_ = new Array();
               for each(_loc30_ in _loc12_.object)
               {
                  _loc31_ = ItemWrapper.create(_loc30_.position,_loc30_.objectUID,_loc30_.objectGID,_loc30_.quantity,_loc30_.effects,false);
                  switch(this._exchangeType)
                  {
                     case ExchangeTypeEnum.CRAFT:
                        this.craftFrame.modifyCraftComponent(_loc12_.remote,_loc31_);
                  }
                  _loc13_.push(_loc31_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectListModified,_loc13_,_loc12_.remote);
               return true;
            case param1 is ExchangeObjectAddedMessage:
               _loc14_ = param1 as ExchangeObjectAddedMessage;
               this._numCurrentSequence++;
               _loc15_ = ItemWrapper.create(_loc14_.object.position,_loc14_.object.objectUID,_loc14_.object.objectGID,_loc14_.object.quantity,_loc14_.object.effects,false);
               switch(this._exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                     this.craftFrame.addCraftComponent(_loc14_.remote,_loc15_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectAdded,_loc15_,_loc14_.remote);
               return true;
            case param1 is ExchangeObjectsAddedMessage:
               _loc16_ = param1 as ExchangeObjectsAddedMessage;
               this._numCurrentSequence++;
               _loc17_ = new Array();
               for each(_loc32_ in _loc16_.object)
               {
                  _loc33_ = ItemWrapper.create(_loc32_.position,_loc32_.objectUID,_loc32_.objectGID,_loc32_.quantity,_loc32_.effects,false);
                  switch(this._exchangeType)
                  {
                     case ExchangeTypeEnum.CRAFT:
                        this.craftFrame.addCraftComponent(_loc16_.remote,_loc33_);
                  }
                  _loc17_.push(_loc33_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectListAdded,_loc17_,_loc16_.remote);
               return true;
            case param1 is ExchangeObjectRemovedMessage:
               _loc18_ = param1 as ExchangeObjectRemovedMessage;
               this._numCurrentSequence++;
               switch(this._exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                     this.craftFrame.removeCraftComponent(_loc18_.remote,_loc18_.objectUID);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectRemoved,_loc18_.objectUID,_loc18_.remote);
               return true;
            case param1 is ExchangeObjectsRemovedMessage:
               _loc19_ = param1 as ExchangeObjectsRemovedMessage;
               this._numCurrentSequence++;
               _loc20_ = new Array();
               for each(_loc21_ in _loc19_.objectUID)
               {
                  switch(this._exchangeType)
                  {
                     case ExchangeTypeEnum.CRAFT:
                        this.craftFrame.removeCraftComponent(_loc18_.remote,_loc21_);
                  }
                  _loc20_.push(_loc21_);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectListRemoved,_loc20_,_loc19_.remote);
               return true;
            case param1 is ExchangeObjectMoveAction:
               _loc22_ = param1 as ExchangeObjectMoveAction;
               _loc23_ = InventoryManager.getInstance().inventory.getItem(_loc22_.objectUID);
               if(!_loc23_)
               {
                  _loc23_ = InventoryManager.getInstance().bankInventory.getItem(_loc22_.objectUID);
               }
               if(_loc23_ && _loc23_.quantity == Math.abs(_loc22_.quantity))
               {
                  TooltipManager.hide();
               }
               _loc24_ = new ExchangeObjectMoveMessage();
               _loc24_.initExchangeObjectMoveMessage(_loc22_.objectUID,_loc22_.quantity);
               ConnectionsHandler.getConnection().send(_loc24_);
               return true;
            case param1 is ExchangeIsReadyMessage:
               _loc25_ = param1 as ExchangeIsReadyMessage;
               _loc26_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
               _loc27_ = (_loc26_.getEntityInfos(_loc25_.id) as GameRolePlayNamedActorInformations).name;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeIsReady,_loc27_,_loc25_.ready);
               return true;
            case param1 is ExchangeKamaModifiedMessage:
               _loc28_ = param1 as ExchangeKamaModifiedMessage;
               this._numCurrentSequence++;
               if(!_loc28_.remote)
               {
                  InventoryManager.getInstance().inventory.hiddedKamas = _loc28_.quantity;
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeKamaModified,_loc28_.quantity,_loc28_.remote);
               return true;
            case param1 is ExchangePodsModifiedMessage:
               _loc29_ = param1 as ExchangePodsModifiedMessage;
               this._numCurrentSequence++;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangePodsModified,_loc29_.currentWeight,_loc29_.maxWeight,_loc29_.remote);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(Kernel.getWorker().contains(CraftFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CraftFrame));
         }
         return true;
      }
   }
}
