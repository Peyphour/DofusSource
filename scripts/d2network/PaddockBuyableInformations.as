package d2network
{
   public class PaddockBuyableInformations extends PaddockInformations
   {
       
      
      public function PaddockBuyableInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
      
      public function get locked() : Boolean
      {
         return _target.locked;
      }
   }
}
