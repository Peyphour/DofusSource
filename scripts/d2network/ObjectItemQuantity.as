package d2network
{
   public class ObjectItemQuantity extends Item
   {
       
      
      public function ObjectItemQuantity(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectUID() : uint
      {
         return _target.objectUID;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
