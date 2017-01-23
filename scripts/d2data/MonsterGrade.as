package d2data
{
   import utils.ReadOnlyData;
   
   public class MonsterGrade extends ReadOnlyData
   {
       
      
      public function MonsterGrade(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
      
      public function get monsterId() : int
      {
         return _target.monsterId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get vitality() : int
      {
         return _target.vitality;
      }
      
      public function get paDodge() : int
      {
         return _target.paDodge;
      }
      
      public function get pmDodge() : int
      {
         return _target.pmDodge;
      }
      
      public function get wisdom() : int
      {
         return _target.wisdom;
      }
      
      public function get earthResistance() : int
      {
         return _target.earthResistance;
      }
      
      public function get airResistance() : int
      {
         return _target.airResistance;
      }
      
      public function get fireResistance() : int
      {
         return _target.fireResistance;
      }
      
      public function get waterResistance() : int
      {
         return _target.waterResistance;
      }
      
      public function get neutralResistance() : int
      {
         return _target.neutralResistance;
      }
      
      public function get gradeXp() : int
      {
         return _target.gradeXp;
      }
      
      public function get lifePoints() : int
      {
         return _target.lifePoints;
      }
      
      public function get actionPoints() : int
      {
         return _target.actionPoints;
      }
      
      public function get movementPoints() : int
      {
         return _target.movementPoints;
      }
      
      public function get damageReflect() : int
      {
         return _target.damageReflect;
      }
      
      public function get hiddenLevel() : uint
      {
         return _target.hiddenLevel;
      }
   }
}
