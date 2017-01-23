package d2data
{
   import utils.ReadOnlyData;
   
   public class Idol extends ReadOnlyData
   {
       
      
      public function Idol(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get description() : String
      {
         return _target.description;
      }
      
      public function get categoryId() : int
      {
         return _target.categoryId;
      }
      
      public function get itemId() : int
      {
         return _target.itemId;
      }
      
      public function get groupOnly() : Boolean
      {
         return _target.groupOnly;
      }
      
      public function get spellPairId() : int
      {
         return _target.spellPairId;
      }
      
      public function get score() : int
      {
         return _target.score;
      }
      
      public function get experienceBonus() : int
      {
         return _target.experienceBonus;
      }
      
      public function get dropBonus() : int
      {
         return _target.dropBonus;
      }
      
      public function get synergyIdolsIds() : Object
      {
         return secure(_target.synergyIdolsIds);
      }
      
      public function get synergyIdolsCoeff() : Object
      {
         return secure(_target.synergyIdolsCoeff);
      }
      
      public function get incompatibleMonsters() : Object
      {
         return secure(_target.incompatibleMonsters);
      }
   }
}
