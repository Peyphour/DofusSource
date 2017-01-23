package d2network
{
   public class CharacterHardcoreOrEpicInformations extends CharacterBaseInformations
   {
       
      
      public function CharacterHardcoreOrEpicInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get deathState() : uint
      {
         return _target.deathState;
      }
      
      public function get deathCount() : uint
      {
         return _target.deathCount;
      }
      
      public function get deathMaxLevel() : uint
      {
         return _target.deathMaxLevel;
      }
   }
}
