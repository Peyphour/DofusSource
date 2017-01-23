package d2network
{
   import utils.ReadOnlyData;
   
   public class BidExchangerObjectInfo extends ReadOnlyData
   {
       
      
      public function BidExchangerObjectInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectUID() : uint
      {
         return _target.objectUID;
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get prices() : Object
      {
         return secure(_target.prices);
      }
   }
}
