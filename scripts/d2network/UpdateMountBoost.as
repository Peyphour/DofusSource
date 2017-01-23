package d2network
{
   import utils.ReadOnlyData;
   
   public class UpdateMountBoost extends ReadOnlyData
   {
       
      
      public function UpdateMountBoost(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
   }
}
