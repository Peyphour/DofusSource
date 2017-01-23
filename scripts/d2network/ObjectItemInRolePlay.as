package d2network
{
   import utils.ReadOnlyData;
   
   public class ObjectItemInRolePlay extends ReadOnlyData
   {
       
      
      public function ObjectItemInRolePlay(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get cellId() : uint
      {
         return _target.cellId;
      }
      
      public function get objectGID() : uint
      {
         return _target.objectGID;
      }
   }
}
