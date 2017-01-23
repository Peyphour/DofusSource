package d2network
{
   public class CharacterMinimalInformations extends CharacterBasicMinimalInformations
   {
       
      
      public function CharacterMinimalInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
