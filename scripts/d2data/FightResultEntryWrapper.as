package d2data
{
   import utils.ReadOnlyData;
   
   public class FightResultEntryWrapper extends ReadOnlyData
   {
       
      
      public function FightResultEntryWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get outcome() : int
      {
         return _target.outcome;
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get alive() : Boolean
      {
         return _target.alive;
      }
      
      public function get rewards() : FightLootWrapper
      {
         return secure(_target.rewards);
      }
      
      public function get level() : int
      {
         return _target.level;
      }
      
      public function get type() : int
      {
         return _target.type;
      }
      
      public function get fightInitiator() : Boolean
      {
         return _target.fightInitiator;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get gender() : int
      {
         return _target.gender;
      }
      
      public function get wave() : int
      {
         return _target.wave;
      }
      
      public function get isLastOfHisWave() : Boolean
      {
         return _target.isLastOfHisWave;
      }
      
      public function get rerollXpMultiplicator() : int
      {
         return _target.rerollXpMultiplicator;
      }
      
      public function get experience() : Number
      {
         return _target.experience;
      }
      
      public function get showExperience() : Boolean
      {
         return _target.showExperience;
      }
      
      public function get experienceLevelFloor() : Number
      {
         return _target.experienceLevelFloor;
      }
      
      public function get showExperienceLevelFloor() : Boolean
      {
         return _target.showExperienceLevelFloor;
      }
      
      public function get experienceNextLevelFloor() : Number
      {
         return _target.experienceNextLevelFloor;
      }
      
      public function get showExperienceNextLevelFloor() : Boolean
      {
         return _target.showExperienceNextLevelFloor;
      }
      
      public function get experienceFightDelta() : Number
      {
         return _target.experienceFightDelta;
      }
      
      public function get showExperienceFightDelta() : Boolean
      {
         return _target.showExperienceFightDelta;
      }
      
      public function get experienceForGuild() : Number
      {
         return _target.experienceForGuild;
      }
      
      public function get showExperienceForGuild() : Boolean
      {
         return _target.showExperienceForGuild;
      }
      
      public function get experienceForRide() : Number
      {
         return _target.experienceForRide;
      }
      
      public function get showExperienceForRide() : Boolean
      {
         return _target.showExperienceForRide;
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
      
      public function get honor() : uint
      {
         return _target.honor;
      }
      
      public function get honorDelta() : int
      {
         return _target.honorDelta;
      }
      
      public function get maxHonorForGrade() : uint
      {
         return _target.maxHonorForGrade;
      }
      
      public function get minHonorForGrade() : uint
      {
         return _target.minHonorForGrade;
      }
      
      public function get isIncarnationExperience() : Boolean
      {
         return _target.isIncarnationExperience;
      }
   }
}
