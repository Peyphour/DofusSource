package d2data
{
   import utils.ReadOnlyData;
   
   public class RideFood extends ReadOnlyData
   {
       
      
      public function RideFood(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get gid() : uint
      {
         return _target.gid;
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
   }
}
