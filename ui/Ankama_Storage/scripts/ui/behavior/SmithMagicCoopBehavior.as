package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import ui.AbstractStorageUi;
   import ui.enum.StorageState;
   
   public class SmithMagicCoopBehavior extends SmithMagicBehavior
   {
       
      
      public function SmithMagicCoopBehavior()
      {
         super();
      }
      
      override public function attach(param1:AbstractStorageUi) : void
      {
         super.attach(param1);
         var _loc2_:Object = Api.ui.getUi("smithMagic");
         if(!_loc2_)
         {
            throw new Error("On attach un SmithMagicCoopBehavior sur une UI pas chargé");
         }
         if(_loc2_.uiClass.isCrafter)
         {
            _storage.btnEquipable.disabled = true;
            _storage.btnConsumables.disabled = true;
            _storage.categoryFilter = AbstractStorageUi.RESSOURCES_CATEGORY;
         }
      }
      
      override public function detach() : void
      {
         super.detach();
         _storage.btnEquipable.disabled = false;
         _storage.btnConsumables.disabled = false;
      }
      
      override public function getMainUiName() : String
      {
         return UIEnum.SMITH_MAGIC;
      }
      
      override public function getName() : String
      {
         return StorageState.SMITH_MAGIC_COOP_MOD;
      }
   }
}
