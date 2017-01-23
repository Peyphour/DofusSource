package d2data
{
   import utils.ReadOnlyData;
   
   public class BasicCharacterWrapper extends ReadOnlyData
   {
       
      
      public function BasicCharacterWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get entityLook() : Object
      {
         return secure(_target.entityLook);
      }
      
      public function get breedId() : uint
      {
         return _target.breedId;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get deathState() : uint
      {
         return _target.deathState;
      }
      
      public function get deathCount() : uint
      {
         return _target.deathCount;
      }
      
      public function get bonusXp() : uint
      {
         return _target.bonusXp;
      }
      
      public function get unusable() : Boolean
      {
         return _target.unusable;
      }
   }
}
