package d2network
{
   public class ObjectItemInformationWithQuantity extends ObjectItemMinimalInformation
   {
       
      
      public function ObjectItemInformationWithQuantity(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
