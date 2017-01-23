package d2network
{
   public class CharacterBasicMinimalInformations extends AbstractCharacterInformation
   {
       
      
      public function CharacterBasicMinimalInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
   }
}
