package d2network
{
   import utils.ReadOnlyData;
   
   public class AchievementObjective extends ReadOnlyData
   {
       
      
      public function AchievementObjective(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get maxValue() : uint
      {
         return _target.maxValue;
      }
   }
}
