package d2network
{
   public class ObjectItemMinimalInformation extends Item
   {
       
      
      public function ObjectItemMinimalInformation(param1:*, param2:Object)
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
   }
}
