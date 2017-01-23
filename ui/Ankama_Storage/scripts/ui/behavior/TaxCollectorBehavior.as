package ui.behavior
{
   import ui.AbstractStorageUi;
   import ui.enum.StorageState;
   
   public class TaxCollectorBehavior extends BankBehavior
   {
       
      
      public function TaxCollectorBehavior()
      {
         super();
      }
      
      override public function attach(param1:AbstractStorageUi) : void
      {
         super.attach(param1);
         _storage.btn_moveAllToRight.visible = false;
      }
      
      override public function detach() : void
      {
         super.detach();
         _storage.btn_moveAllToRight.visible = true;
      }
      
      override public function getName() : String
      {
         return StorageState.TAXCOLLECTOR_MOD;
      }
   }
}
