package d2data
{
   import utils.ReadOnlyData;
   
   public class QuestStepRewards extends ReadOnlyData
   {
       
      
      public function QuestStepRewards(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get stepId() : uint
      {
         return _target.stepId;
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
      
      public function get emotesReward() : Object
      {
         return secure(_target.emotesReward);
      }
      
      public function get jobsReward() : Object
      {
         return secure(_target.jobsReward);
      }
      
      public function get spellsReward() : Object
      {
         return secure(_target.spellsReward);
      }
   }
}
