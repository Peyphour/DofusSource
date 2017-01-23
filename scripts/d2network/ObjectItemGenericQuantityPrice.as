package d2network
{
   public class ObjectItemGenericQuantityPrice extends ObjectItemGenericQuantity
   {
       
      
      public function ObjectItemGenericQuantityPrice(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
   }
}
