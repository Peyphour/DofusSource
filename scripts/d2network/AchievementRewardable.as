package d2network
{
   import utils.ReadOnlyData;
   
   public class AchievementRewardable extends ReadOnlyData
   {
       
      
      public function AchievementRewardable(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get finishedlevel() : uint
      {
         return _target.finishedlevel;
      }
   }
}
