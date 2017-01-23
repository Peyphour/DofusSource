package makers
{
   import d2actions.ExchangeOnHumanVendorRequest;
   import d2actions.HouseKickIndoorMerchant;
   
   public class HumanVendorMenuMaker
   {
      
      public static var disabled:Boolean = false;
       
      
      public function HumanVendorMenuMaker()
      {
         super();
      }
      
      private function onMerchantPlayerBuyClick(param1:Object) : void
      {
         Api.system.sendAction(new ExchangeOnHumanVendorRequest(param1.contextualId,param1.disposition.cellId));
      }
      
      private function onMerchantHouseKickOff(param1:Object) : void
      {
         Api.system.sendAction(new HouseKickIndoorMerchant(param1.disposition.cellId));
      }
      
      public function createMenu(param1:*, param2:Object) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:* = !Api.player.isAlive();
         _loc3_.push(ContextMenu.static_createContextMenuTitleObject(Api.ui.getText("ui.humanVendor.playerShop",param1.name,null,disabled)));
         _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.buy"),this.onMerchantPlayerBuyClick,[param1],disabled || _loc4_));
         if(Api.player.isInHisHouse())
         {
            _loc3_.push(ContextMenu.static_createContextMenuItemObject(Api.ui.getText("ui.common.kickOff"),this.onMerchantHouseKickOff,[param1]));
         }
         return _loc3_;
      }
   }
}
