package d2data
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
      
      public function get achievementId() : uint
      {
         return _target.achievementId;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get criterion() : String
      {
         return _target.criterion;
      }
   }
}
