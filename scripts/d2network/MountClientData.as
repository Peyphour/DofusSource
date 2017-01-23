package d2network
{
   import utils.ReadOnlyData;
   
   public class MountClientData extends ReadOnlyData
   {
       
      
      public function MountClientData(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get model() : uint
      {
         return _target.model;
      }
      
      public function get ancestor() : Object
      {
         return secure(_target.ancestor);
      }
      
      public function get behaviors() : Object
      {
         return secure(_target.behaviors);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get ownerId() : uint
      {
         return _target.ownerId;
      }
      
      public function get experience() : Number
      {
         return _target.experience;
      }
      
      public function get experienceForLevel() : Number
      {
         return _target.experienceForLevel;
      }
      
      public function get experienceForNextLevel() : Number
      {
         return _target.experienceForNextLevel;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get isRideable() : Boolean
      {
         return _target.isRideable;
      }
      
      public function get maxPods() : uint
      {
         return _target.maxPods;
      }
      
      public function get isWild() : Boolean
      {
         return _target.isWild;
      }
      
      public function get stamina() : uint
      {
         return _target.stamina;
      }
      
      public function get staminaMax() : uint
      {
         return _target.staminaMax;
      }
      
      public function get maturity() : uint
      {
         return _target.maturity;
      }
      
      public function get maturityForAdult() : uint
      {
         return _target.maturityForAdult;
      }
      
      public function get energy() : uint
      {
         return _target.energy;
      }
      
      public function get energyMax() : uint
      {
         return _target.energyMax;
      }
      
      public function get serenity() : int
      {
         return _target.serenity;
      }
      
      public function get aggressivityMax() : int
      {
         return _target.aggressivityMax;
      }
      
      public function get serenityMax() : uint
      {
         return _target.serenityMax;
      }
      
      public function get love() : uint
      {
         return _target.love;
      }
      
      public function get loveMax() : uint
      {
         return _target.loveMax;
      }
      
      public function get fecondationTime() : int
      {
         return _target.fecondationTime;
      }
      
      public function get isFecondationReady() : Boolean
      {
         return _target.isFecondationReady;
      }
      
      public function get boostLimiter() : uint
      {
         return _target.boostLimiter;
      }
      
      public function get boostMax() : Number
      {
         return _target.boostMax;
      }
      
      public function get reproductionCount() : int
      {
         return _target.reproductionCount;
      }
      
      public function get reproductionCountMax() : uint
      {
         return _target.reproductionCountMax;
      }
      
      public function get harnessGID() : uint
      {
         return _target.harnessGID;
      }
      
      public function get useHarnessColors() : Boolean
      {
         return _target.useHarnessColors;
      }
      
      public function get effectList() : Object
      {
         return secure(_target.effectList);
      }
   }
}
