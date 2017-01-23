package d2network
{
   public class GameFightFighterNamedLightInformations extends GameFightFighterLightInformations
   {
       
      
      public function GameFightFighterNamedLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
   }
}
