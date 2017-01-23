package ui
{
   public class ExchangeNPCUi extends ExchangeUi
   {
       
      
      public function ExchangeNPCUi()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         input_kamaRight.selectable = false;
         super.main(param1);
      }
      
      override protected function checkAcceptButton() : void
      {
         if(gd_left.dataProvider.length == 0 && _leftPlayerKamaExchange == 0)
         {
            btn_validate.disabled = true;
         }
         else
         {
            btn_validate.disabled = false;
         }
      }
   }
}
