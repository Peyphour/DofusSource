package d2data
{
   import utils.ReadOnlyData;
   
   public class AchievementReward extends ReadOnlyData
   {
       
      
      public function AchievementReward(param1:*, param2:Object)
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
      
      public function get levelMin() : int
      {
         return _target.levelMin;
      }
      
      public function get levelMax() : int
      {
         return _target.levelMax;
      }
      
      public function get itemsReward() : Object
      {
         return secure(_target.itemsReward);
      }
      
      public function get itemsQuantityReward() : Object
      {
         return secure(_target.itemsQuantityReward);
      }
      
      public function get emotesReward() : Object
      {
         return secure(_target.emotesReward);
      }
      
      public function get spellsReward() : Object
      {
         return secure(_target.spellsReward);
      }
      
      public function get titlesReward() : Object
      {
         return secure(_target.titlesReward);
      }
      
      public function get ornamentsReward() : Object
      {
         return secure(_target.ornamentsReward);
      }
   }
}
