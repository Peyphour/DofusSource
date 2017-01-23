package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.datacenter.mounts.Mount;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.InventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.MountFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   [InstanciedApi]
   public class MountApi implements IApi
   {
       
      
      public function MountApi()
      {
         super();
      }
      
      private function get mountFrame() : MountFrame
      {
         return Kernel.getWorker().getFrame(MountFrame) as MountFrame;
      }
      
      private function get inventoryFrame() : InventoryManagementFrame
      {
         return Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      [NoBoxing]
      [Untrusted]
      public function getRiderEntityLook(param1:*) : TiphonEntityLook
      {
         return EntityLookAdapter.getRiderLook(param1).clone();
      }
      
      [Untrusted]
      public function getMount(param1:uint) : Mount
      {
         return Mount.getMountById(param1);
      }
      
      [Untrusted]
      public function getStableList() : Array
      {
         return this.mountFrame.stableList;
      }
      
      [Untrusted]
      public function getPaddockList() : Array
      {
         return this.mountFrame.paddockList;
      }
      
      [Untrusted]
      public function getInventoryList() : Vector.<ItemWrapper>
      {
         return InventoryManager.getInstance().inventory.getView("certificate").content;
      }
      
      [Untrusted]
      public function getCurrentPaddock() : Object
      {
         return this.roleplayContextFrame.currentPaddock;
      }
      
      [Untrusted]
      public function isCertificateValid(param1:ItemWrapper) : Boolean
      {
         if(param1.effects && param1.effects.length > 1)
         {
            return true;
         }
         return false;
      }
   }
}
