package d2network
{
   public class GameFightMutantInformations extends GameFightFighterNamedInformations
   {
       
      
      public function GameFightMutantInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get powerLevel() : uint
      {
         return _target.powerLevel;
      }
   }
}
