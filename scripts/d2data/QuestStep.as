package d2data
{
   import utils.ReadOnlyData;
   
   public class QuestStep extends ReadOnlyData
   {
       
      
      public function QuestStep(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get questId() : uint
      {
         return _target.questId;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get dialogId() : int
      {
         return _target.dialogId;
      }
      
      public function get optimalLevel() : uint
      {
         return _target.optimalLevel;
      }
      
      public function get duration() : Number
      {
         return _target.duration;
      }
      
      public function get kamasScaleWithPlayerLevel() : Boolean
      {
         return _target.kamasScaleWithPlayerLevel;
      }
      
      public function get kamasRatio() : Number
      {
         return _target.kamasRatio;
      }
      
      public function get xpRatio() : Number
      {
         return _target.xpRatio;
      }
      
      public function get objectiveIds() : Object
      {
         return secure(_target.objectiveIds);
      }
      
      public function get rewardsIds() : Object
      {
         return secure(_target.rewardsIds);
      }
   }
}
