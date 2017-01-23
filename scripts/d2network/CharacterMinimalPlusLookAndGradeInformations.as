package d2network
{
   public class CharacterMinimalPlusLookAndGradeInformations extends CharacterMinimalPlusLookInformations
   {
       
      
      public function CharacterMinimalPlusLookAndGradeInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
   }
}
