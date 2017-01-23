package d2network
{
   public class CharacterBaseInformations extends CharacterMinimalPlusLookInformations
   {
       
      
      public function CharacterBaseInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
   }
}
