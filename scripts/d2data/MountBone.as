package d2data
{
   import utils.ReadOnlyData;
   
   public class MountBone extends ReadOnlyData
   {
       
      
      public function MountBone(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
   }
}
