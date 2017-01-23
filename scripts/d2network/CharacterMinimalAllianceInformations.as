package d2network
{
   public class CharacterMinimalAllianceInformations extends CharacterMinimalGuildInformations
   {
       
      
      public function CharacterMinimalAllianceInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get alliance() : BasicAllianceInformations
      {
         return secure(_target.alliance);
      }
   }
}
