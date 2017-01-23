package d2network
{
   public class CharacterMinimalGuildInformations extends CharacterMinimalPlusLookInformations
   {
       
      
      public function CharacterMinimalGuildInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guild() : BasicGuildInformations
      {
         return secure(_target.guild);
      }
   }
}
