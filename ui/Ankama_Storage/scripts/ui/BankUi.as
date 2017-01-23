package ui
{
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.CloseInventory;
   import d2actions.LeaveDialogRequest;
   import d2actions.OpenInventory;
   import d2enums.ExchangeTypeEnum;
   import d2hooks.BankViewContent;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeWeight;
   import d2hooks.StorageKamasUpdate;
   import ui.enum.StorageState;
   
   public class BankUi extends AbstractStorageUi
   {
       
      
      public var filterCtr:GraphicContainer;
      
      public var entityDisplayer:EntityDisplayer;
      
      private var _objectToExchange:Object;
      
      private var _exchangeType:int;
      
      private var _iconFrame:int;
      
      protected var _sortProperty2:int = -1;
      
      public function BankUi()
      {
         super();
      }
      
      override public function main(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         param1.storageMod = "bankUi";
         super.main(param1);
         sysApi.addHook(BankViewContent,onInventoryUpdate);
         sysApi.addHook(StorageKamasUpdate,onKamasUpdate);
         sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.categoryFilter = ALL_CATEGORY;
         _hasSlot = false;
         this._exchangeType = param1.exchangeType;
         switch(this._exchangeType)
         {
            case ExchangeTypeEnum.TAXCOLLECTOR:
               lbl_title.text = uiApi.getText("ui.common.taxCollector");
               this._iconFrame = 2;
               sysApi.addHook(ExchangeWeight,onInventoryWeight);
               _loc2_ = StorageState.TAXCOLLECTOR_MOD;
               break;
            case ExchangeTypeEnum.MOUNT:
               _loc3_ = playerApi.getMount();
               lbl_title.text = uiApi.getText("ui.common.inventory");
               ctr_kamas.visible = false;
               tx_weightBar.visible = true;
               sysApi.addHook(ExchangeWeight,onInventoryWeight);
               _loc2_ = StorageState.MOUNT_MOD;
               break;
            case ExchangeTypeEnum.STORAGE:
            case ExchangeTypeEnum.HAVENBAG:
               this._iconFrame = 4;
               lbl_title.text = uiApi.getText("ui.common.storage");
               if(!playerApi.isInHavenbag())
               {
                  _hasSlot = true;
                  _slotsMax = !param1.maxSlots?uint(0):uint(param1.maxSlots);
                  tx_weightBar.visible = _slotsMax != 0;
               }
               else
               {
                  sysApi.addHook(ExchangeWeight,onInventoryWeight);
               }
               _loc2_ = StorageState.BANK_MOD;
               break;
            case ExchangeTypeEnum.BANK:
               this._iconFrame = 4;
               lbl_title.text = uiApi.getText("ui.common.bank");
               _hasSlot = true;
               _slotsMax = !param1.maxSlots?uint(0):uint(param1.maxSlots);
               tx_weightBar.visible = _slotsMax != 0;
               _loc2_ = StorageState.BANK_MOD;
               break;
            case ExchangeTypeEnum.TRASHBIN:
               this._iconFrame = 12;
               lbl_title.text = uiApi.getText("ui.common.bin");
               _hasSlot = true;
               _slotsMax = !param1.maxSlots?uint(0):uint(param1.maxSlots);
               tx_weightBar.visible = _slotsMax != 0;
               _loc2_ = StorageState.BANK_MOD;
               break;
            case ExchangeTypeEnum.ALLIANCE_PRISM:
               this._iconFrame = 4;
               lbl_title.text = uiApi.getText("ui.zaap.prism");
               _hasSlot = true;
               _slotsMax = !param1.maxSlots?uint(0):uint(param1.maxSlots);
               tx_weightBar.visible = _slotsMax != 0;
               _loc2_ = StorageState.BANK_MOD;
               break;
            default:
               lbl_title.text = uiApi.getText("ui.common.storage");
               _loc2_ = StorageState.BANK_MOD;
         }
         mainCtr.x = 16;
         mainCtr.y = 1024 - (mainCtr.height + 155);
         if(param1.inventory && param1.kamas)
         {
            onInventoryUpdate(param1.inventory,param1.kamas);
         }
         this.subFilter = -1;
         storageApi.releaseBankHooks();
         sysApi.sendAction(new OpenInventory(_loc2_));
      }
      
      override protected function getStorageTypes(param1:int) : Object
      {
         return storageApi.getBankStorageTypes(param1);
      }
      
      override public function set categoryFilter(param1:int) : void
      {
         super.categoryFilter = param1;
         storageApi.setDisplayedBankCategory(categoryFilter);
      }
      
      override public function set subFilter(param1:int) : void
      {
         var _loc3_:Object = null;
         updateSubFilter(this.getStorageTypes(categoryFilter));
         var _loc2_:Boolean = false;
         for each(_loc3_ in super.cb_category.dataProvider)
         {
            if(_loc3_.filterType == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            param1 = -1;
         }
         storageApi.setBankStorageFilter(param1);
         super.subFilter = param1;
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case btn_moveAllToLeft:
            case btn_moveAllToRight:
               _loc2_ = uiApi.getText("ui.storage.advancedTransferts");
               if(_loc2_)
               {
                  uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
               }
               else
               {
                  super.onRollOver(param1);
               }
               return;
            default:
               super.onRollOver(param1);
               return;
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case btn_moveAllToLeft:
            case btn_moveAllToRight:
               _loc2_ = new Array();
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.storage.getAll"),_storageBehavior.transfertAll,null,false,null,false,true));
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.storage.getVisible"),_storageBehavior.transfertList,null,false,null,false,true));
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.storage.getExisting"),_storageBehavior.transfertExisting,null,false,null,false,true));
               modContextMenu.createContextMenu(_loc2_);
         }
         super.onRelease(param1);
      }
      
      override public function unload() : void
      {
         super.unload();
         sysApi.removeHook(BankViewContent);
         sysApi.removeHook(StorageKamasUpdate);
         sysApi.removeHook(ExchangeLeave);
         var _loc1_:Object = uiApi.getUi(UIEnum.MOUNT_INFO);
         if(_loc1_)
         {
            _loc1_.visible = true;
         }
         Api.system.sendAction(new LeaveDialogRequest());
         sysApi.sendAction(new CloseInventory());
      }
      
      override protected function releaseHooks() : void
      {
         storageApi.releaseBankHooks();
      }
      
      override protected function sortOn(param1:int, param2:Boolean = false) : void
      {
         storageApi.resetBankSort();
         this.addSort(param1);
      }
      
      override protected function addSort(param1:int) : void
      {
         storageApi.sortBank(param1,false);
         this.releaseHooks();
      }
      
      override protected function getSortFields() : Object
      {
         return storageApi.getSortBankFields();
      }
      
      public function onExchangeLeave(param1:Boolean) : void
      {
         uiApi.unloadUi(uiApi.me().name);
      }
   }
}
