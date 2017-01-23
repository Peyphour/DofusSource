package d2network
{
   public class GameFightFighterNamedInformations extends GameFightFighterInformations
   {
       
      
      public function GameFightFighterNamedInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get status() : PlayerStatus
      {
         return secure(_target.status);
      }
   }
}
