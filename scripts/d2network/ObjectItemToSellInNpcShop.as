package d2network
{
   public class ObjectItemToSellInNpcShop extends ObjectItemMinimalInformation
   {
       
      
      public function ObjectItemToSellInNpcShop(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectPrice() : uint
      {
         return _target.objectPrice;
      }
      
      public function get buyCriterion() : String
      {
         return _target.buyCriterion;
      }
   }
}
