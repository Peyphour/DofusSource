package d2network
{
   public class UpdateMountIntBoost extends UpdateMountBoost
   {
       
      
      public function UpdateMountIntBoost(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
