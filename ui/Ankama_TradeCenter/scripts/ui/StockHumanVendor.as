package ui
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   
   public class StockHumanVendor extends StockMyselfVendor
   {
       
      
      public function StockHumanVendor()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         MODE = HUMAN_VENDOR;
         super.main(param1);
         gd_shop.scrollDisplay = "always";
         ctr_center.visible = false;
         lbl_title.text = param1.playerName;
         ed_merchant.look = param1.look;
         tx_bgEntity.visible = true;
      }
      
      override public function unload() : void
      {
         uiApi.unloadUi(UIEnum.HUMAN_VENDOR);
         super.unload();
      }
   }
}
