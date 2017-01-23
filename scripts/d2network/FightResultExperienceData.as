package d2network
{
   public class FightResultExperienceData extends FightResultAdditionalData
   {
       
      
      public function FightResultExperienceData(param1:*, param2:Object)
      {
         super(param1,param2);
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
      
      public function get experienceForMount() : Number
      {
         return _target.experienceForMount;
      }
      
      public function get showExperienceForMount() : Boolean
      {
         return _target.showExperienceForMount;
      }
      
      public function get isIncarnationExperience() : Boolean
      {
         return _target.isIncarnationExperience;
      }
      
      public function get rerollExperienceMul() : uint
      {
         return _target.rerollExperienceMul;
      }
   }
}
