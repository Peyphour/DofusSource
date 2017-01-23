package d2data
{
   import utils.ReadOnlyData;
   
   public class StealthBones extends ReadOnlyData
   {
       
      
      public function StealthBones(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
   }
}
