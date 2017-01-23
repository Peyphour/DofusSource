package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.QuantifiedItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.SimpleTextureWrapper;
   
   public class InventoryApi
   {
       
      
      public function InventoryApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getStorageObjectGID(param1:uint, param2:uint = 1) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getStorageObjectsByType(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getItemQty(param1:uint, param2:uint = 0) : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getItemByGID(param1:uint) : ItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getQuantifiedItemByGIDInInventoryOrMakeUpOne(param1:uint) : QuantifiedItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getItem(param1:uint) : ItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getEquipementItemByPosition(param1:uint) : ItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getEquipement() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getEquipementForPreset() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getVoidItemForPreset(param1:int) : SimpleTextureWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getCurrentWeapon() : ItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getPresets() : Array
      {
         return null;
      }
      
      [Trusted]
      public function removeSelectedItem() : Boolean
      {
         return false;
      }
   }
}
