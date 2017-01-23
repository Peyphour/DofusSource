package d2data
{
   import utils.ReadOnlyData;
   
   public class Breed extends ReadOnlyData
   {
       
      
      public function Breed(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get shortNameId() : uint
      {
         return _target.shortNameId;
      }
      
      public function get longNameId() : uint
      {
         return _target.longNameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get gameplayDescriptionId() : uint
      {
         return _target.gameplayDescriptionId;
      }
      
      public function get maleLook() : String
      {
         return _target.maleLook;
      }
      
      public function get femaleLook() : String
      {
         return _target.femaleLook;
      }
      
      public function get creatureBonesId() : uint
      {
         return _target.creatureBonesId;
      }
      
      public function get maleArtwork() : int
      {
         return _target.maleArtwork;
      }
      
      public function get femaleArtwork() : int
      {
         return _target.femaleArtwork;
      }
      
      public function get statsPointsForStrength() : Object
      {
         return secure(_target.statsPointsForStrength);
      }
      
      public function get statsPointsForIntelligence() : Object
      {
         return secure(_target.statsPointsForIntelligence);
      }
      
      public function get statsPointsForChance() : Object
      {
         return secure(_target.statsPointsForChance);
      }
      
      public function get statsPointsForAgility() : Object
      {
         return secure(_target.statsPointsForAgility);
      }
      
      public function get statsPointsForVitality() : Object
      {
         return secure(_target.statsPointsForVitality);
      }
      
      public function get statsPointsForWisdom() : Object
      {
         return secure(_target.statsPointsForWisdom);
      }
      
      public function get breedSpellsId() : Object
      {
         return secure(_target.breedSpellsId);
      }
      
      public function get breedRoles() : Object
      {
         return secure(_target.breedRoles);
      }
      
      public function get maleColors() : Object
      {
         return secure(_target.maleColors);
      }
      
      public function get femaleColors() : Object
      {
         return secure(_target.femaleColors);
      }
      
      public function get spawnMap() : uint
      {
         return _target.spawnMap;
      }
      
      public function get complexity() : uint
      {
         return _target.complexity;
      }
      
      public function get sortIndex() : uint
      {
         return _target.sortIndex;
      }
   }
}
