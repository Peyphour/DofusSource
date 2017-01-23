package d2data
{
   import utils.ReadOnlyData;
   
   public class Achievement extends ReadOnlyData
   {
       
      
      public function Achievement(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get categoryId() : uint
      {
         return _target.categoryId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get iconId() : uint
      {
         return _target.iconId;
      }
      
      public function get points() : uint
      {
         return _target.points;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get kamasRatio() : Number
      {
         return _target.kamasRatio;
      }
      
      public function get experienceRatio() : Number
      {
         return _target.experienceRatio;
      }
      
      public function get kamasScaleWithPlayerLevel() : Boolean
      {
         return _target.kamasScaleWithPlayerLevel;
      }
      
      public function get objectiveIds() : Object
      {
         return secure(_target.objectiveIds);
      }
      
      public function get rewardIds() : Object
      {
         return secure(_target.rewardIds);
      }
   }
}
