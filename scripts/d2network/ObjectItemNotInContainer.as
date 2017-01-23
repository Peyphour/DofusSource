package d2network
{
   public class ObjectItemNotInContainer extends Item
   {
       
      
      public function ObjectItemNotInContainer(param1:*, param2:Object)
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
   }
}
