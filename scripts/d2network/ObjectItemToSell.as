package d2network
{
   public class ObjectItemToSell extends Item
   {
       
      
      public function ObjectItemToSell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectGID() : uint
      {
         return _target.objectGID;
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get objectUID() : uint
      {
         return _target.objectUID;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
      
      public function get objectPrice() : uint
      {
         return _target.objectPrice;
      }
   }
}
