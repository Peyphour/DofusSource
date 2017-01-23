package d2network
{
   public class AchievementStartedObjective extends AchievementObjective
   {
       
      
      public function AchievementStartedObjective(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : uint
      {
         return _target.value;
      }
   }
}
