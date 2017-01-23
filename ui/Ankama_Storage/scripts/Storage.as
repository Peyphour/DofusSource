package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2enums.CharacterInventoryPositionEnum;
   import d2enums.ClientUITypeEnum;
   import d2enums.ExchangeTypeEnum;
   import d2hooks.ClientUIOpened;
   import d2hooks.CloseInventory;
   import d2hooks.EquipmentObjectMove;
   import d2hooks.ExchangeBankStarted;
   import d2hooks.ExchangeBankStartedWithStorage;
   import d2hooks.ExchangeStartedType;
   import d2hooks.MountRiding;
   import d2hooks.ObjectAdded;
   import d2hooks.ObjectDeleted;
   import d2hooks.ObjectModified;
   import d2hooks.OpenInventory;
   import d2hooks.OpenLivingObject;
   import flash.display.Sprite;
   import ui.BankUi;
   import ui.EquipmentUi;
   import ui.LivingObject;
   import ui.Mimicry;
   import ui.PresetUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   import util.StorageBehaviorManager;
   
   public class Storage extends Sprite
   {
      
      public static var bidIsSwitching:Boolean = false;
       
      
      private var include_StorageUi:StorageUi = null;
      
      private var include_BankUi:BankUi = null;
      
      private var include_EquipmentUi:EquipmentUi = null;
      
      private var include_PresetUi:PresetUi = null;
      
      private var include_livingObject:LivingObject = null;
      
      private var include_mimicry:Mimicry = null;
      
      public var menuApi:ContextMenuApi;
      
      public var storageApi:StorageApi;
      
      public var inventoryApi:InventoryApi;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      private var _inventory:Object;
      
      private var _kamas:uint;
      
      private var _weight:uint;
      
      private var _weightMax:uint;
      
      private var _waitingObject:Object;
      
      private var _waitingObjectName:String;
      
      private var _waitingObjectQuantity:int;
      
      private var _currentStorageMod:uint = 0;
      
      public function Storage()
      {
         super();
      }
      
      public function main() : void
      {
         Api.common = this.modCommon;
         Api.menu = this.menuApi;
         Api.sound = this.soundApi;
         Api.storage = this.storageApi;
         Api.system = this.sysApi;
         Api.ui = this.uiApi;
         Api.data = this.dataApi;
         Api.player = this.playerApi;
         Api.inventory = this.inventoryApi;
         this.sysApi.addHook(OpenInventory,this.onOpenInventory);
         this.sysApi.addHook(CloseInventory,this.onCloseInventory);
         this.sysApi.addHook(ExchangeStartedType,this.onExchangeStartedType);
         this.sysApi.addHook(ExchangeBankStarted,this.onExchangeBankStarted);
         this.sysApi.addHook(ObjectAdded,this.onObjectAdded);
         this.sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         this.sysApi.addHook(ObjectModified,this.onObjectModified);
         this.sysApi.addHook(OpenLivingObject,this.onOpenLivingObject);
         this.sysApi.addHook(ExchangeBankStartedWithStorage,this.onExchangeStartedWithStorage);
         this.sysApi.addHook(EquipmentObjectMove,this.onEquipmentObjectMove);
         this.sysApi.addHook(MountRiding,this.onMountRiding);
         this.sysApi.addHook(ClientUIOpened,this.onClientUIOpened);
      }
      
      private function onExchangeStartedType(param1:int) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case ExchangeTypeEnum.STORAGE:
               if(!this.uiApi.getUi(UIEnum.BANK_UI))
               {
                  this.uiApi.loadUi(UIEnum.BANK_UI,UIEnum.BANK_UI,{"exchangeType":param1});
               }
               break;
            case ExchangeTypeEnum.MOUNT:
               _loc2_ = this.uiApi.getUi(UIEnum.MOUNT_INFO);
               if(_loc2_)
               {
                  _loc2_.visible = false;
               }
         }
      }
      
      private function onExchangeStartedWithStorage(param1:int, param2:uint) : void
      {
         switch(param1)
         {
            case ExchangeTypeEnum.STORAGE:
            case ExchangeTypeEnum.BANK:
            case ExchangeTypeEnum.TRASHBIN:
            case ExchangeTypeEnum.ALLIANCE_PRISM:
            case ExchangeTypeEnum.HAVENBAG:
               if(!this.uiApi.getUi(UIEnum.BANK_UI))
               {
                  this.uiApi.loadUi(UIEnum.BANK_UI,UIEnum.BANK_UI,{
                     "exchangeType":param1,
                     "maxSlots":param2
                  });
               }
         }
      }
      
      private function onExchangeBankStarted(param1:int, param2:Object, param3:uint) : void
      {
         var _loc5_:Object = null;
         var _loc4_:String = StorageState.BANK_MOD;
         switch(param1)
         {
            case ExchangeTypeEnum.MOUNT:
               _loc5_ = this.uiApi.getUi(UIEnum.MOUNT_INFO);
               if(_loc5_)
               {
                  _loc5_.visible = false;
               }
               _loc4_ = StorageState.MOUNT_MOD;
               break;
            case ExchangeTypeEnum.TAXCOLLECTOR:
               _loc4_ = StorageState.TAXCOLLECTOR_MOD;
         }
         if(!this.uiApi.getUi(UIEnum.BANK_UI))
         {
            this.uiApi.loadUi(UIEnum.BANK_UI,UIEnum.BANK_UI,{
               "inventory":param2,
               "kamas":param3,
               "exchangeType":param1
            });
         }
      }
      
      private function onOpenInventory(param1:String) : void
      {
         if(!this.playerApi.characteristics())
         {
            return;
         }
         this._inventory = this.storageApi.getViewContent("storage");
         this._kamas = this.playerApi.characteristics().kamas;
         this._weight = this.playerApi.inventoryWeight();
         this._weightMax = this.playerApi.inventoryWeightMax();
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = StorageBehaviorManager.makeBehavior(param1).getStorageUiName();
         var _loc5_:Object = this.uiApi.getUi(UIEnum.STORAGE_UI);
         if(_loc5_)
         {
            if(_loc5_.uiClass is EquipmentUi && _loc4_ == UIEnum.EQUIPMENT_UI || !(_loc5_.uiClass is EquipmentUi) && _loc4_ == UIEnum.STORAGE_UI)
            {
               _loc2_ = false;
            }
            else
            {
               _loc3_ = true;
               _loc2_ = true;
            }
         }
         else
         {
            _loc2_ = true;
         }
         if(_loc3_)
         {
            this.uiApi.unloadUi(UIEnum.STORAGE_UI);
         }
         if(_loc2_)
         {
            this.uiApi.loadUi(_loc4_,UIEnum.STORAGE_UI,{"storageMod":param1},1);
         }
         else if(_loc5_.uiClass.currentStorageBehavior.replacable)
         {
            _loc5_.uiClass.switchBehavior(param1);
         }
      }
      
      private function onCloseInventory() : void
      {
         if(this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            this.uiApi.unloadUi(UIEnum.STORAGE_UI);
         }
      }
      
      private function onOpenLivingObject(param1:Object) : void
      {
         this.uiApi.unloadUi("livingObject");
         if(param1)
         {
            this.uiApi.loadUi("livingObject","livingObject",{"item":param1});
         }
      }
      
      private function onClientUIOpened(param1:uint, param2:uint) : void
      {
         if(param1 == ClientUITypeEnum.CLIENT_UI_OBJECT_MIMICRY)
         {
            if(!this.uiApi.getUi("mimicry"))
            {
               this.uiApi.loadUi("mimicry","mimicry",param2);
            }
            this.sysApi.dispatchHook(OpenInventory,"mimicry");
         }
      }
      
      private function playItemMovedSound() : void
      {
         if(this.uiApi.getUi(UIEnum.STORAGE_UI))
         {
            this.soundApi.playSound(SoundTypeEnum.MOVE_ITEM_TO_BAG);
         }
      }
      
      private function onObjectAdded(param1:Object) : void
      {
         this.playItemMovedSound();
      }
      
      private function onObjectDeleted(param1:Object) : void
      {
         this.playItemMovedSound();
      }
      
      private function onObjectModified(param1:Object) : void
      {
         this.playItemMovedSound();
      }
      
      public function onEquipmentObjectMove(param1:Object, param2:int) : void
      {
         if(!param1 || param1.position > CharacterInventoryPositionEnum.ACCESSORY_POSITION_SHIELD)
         {
            return;
         }
         switch(param1.position)
         {
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_AMULET:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_NECKLACE);
               break;
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_SHIELD:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_BUCKLER);
               break;
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_RING_LEFT:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_RING_RIGHT:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_CIRCLE);
               break;
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_BELT:
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_HAT:
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_CAPE:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_CLOTHES);
               break;
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_BOOTS:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_BOOT);
               break;
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_WEAPON);
               break;
            case CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_PET);
               break;
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_DOFUS_1:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_DOFUS_2:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_DOFUS_3:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_DOFUS_4:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_DOFUS_5:
            case CharacterInventoryPositionEnum.INVENTORY_POSITION_DOFUS_6:
               this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_DOFUS);
         }
      }
      
      public function onMountRiding(param1:Boolean) : void
      {
         this.soundApi.playSound(SoundTypeEnum.EQUIPMENT_PET);
      }
   }
}
