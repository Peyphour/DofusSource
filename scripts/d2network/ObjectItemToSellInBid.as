package d2network
{
   public class ObjectItemToSellInBid extends ObjectItemToSell
   {
       
      
      public function ObjectItemToSellInBid(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get unsoldDelay() : uint
      {
         return _target.unsoldDelay;
      }
   }
}
