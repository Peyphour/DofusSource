package d2network
{
   public class GameFightFighterMonsterLightInformations extends GameFightFighterLightInformations
   {
       
      
      public function GameFightFighterMonsterLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get creatureGenericId() : uint
      {
         return _target.creatureGenericId;
      }
   }
}
