package ui
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2enums.ComponentHookList;
   import d2hooks.CloseStore;
   import d2hooks.ObjectDeleted;
   import d2hooks.ObjectQuantity;
   
   public class StockNpcStore extends Stock
   {
       
      
      public function StockNpcStore()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main(param1);
         uiApi.loadUi(UIEnum.NPC_ITEM,UIEnum.NPC_ITEM);
         sysApi.addHook(ObjectQuantity,this.onObjectQuantity);
         sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         uiApi.addComponentHook(btn_itemsFilter,ComponentHookList.ON_RELEASE);
         gd_shop.scrollDisplay = "always";
         lbl_title.text = uiApi.getText("ui.common.shop");
         ed_merchant.look = param1.look;
         tx_bgEntity.visible = true;
      }
      
      override public function unload() : void
      {
         uiApi.unloadUi(UIEnum.NPC_ITEM);
         super.unload();
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_close:
               sysApi.dispatchHook(CloseStore);
         }
         super.onRelease(param1);
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc4_:Object = null;
         super.onRollOver(param1);
         var _loc2_:Object = {
            "point":LocationEnum.POINT_RIGHT,
            "relativePoint":LocationEnum.POINT_RIGHT
         };
         var _loc3_:int = 9;
         if(0)
         {
         }
         if(param1.name.indexOf("btn_item") != -1)
         {
            _loc4_ = _componentsList[param1.name];
            if(_loc4_ && _loc4_.criterion && _loc4_.criterion.inlineCriteria.length > 0)
            {
               uiApi.showTooltip(_loc4_.criterion,param1,false,"standard",_loc2_.point,_loc2_.relativePoint,_loc3_,"sellCriterion");
            }
         }
      }
      
      override public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         super.onSelectItem(param1,param2,param3);
      }
      
      private function onObjectQuantity(param1:ItemWrapper, param2:int, param3:int) : void
      {
         if(param1.objectGID == _tokenType && btn_itemsFilter.selected)
         {
            updateStockInventory();
         }
      }
      
      private function onObjectDeleted(param1:ItemWrapper) : void
      {
         if(param1.objectGID == _tokenType && btn_itemsFilter.selected)
         {
            updateStockInventory();
         }
      }
   }
}
