package d2network
{
   public class ObjectItemGenericQuantity extends Item
   {
       
      
      public function ObjectItemGenericQuantity(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectGID() : uint
      {
         return _target.objectGID;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
