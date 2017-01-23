package d2network
{
   public class GameRolePlayMutantInformations extends GameRolePlayHumanoidInformations
   {
       
      
      public function GameRolePlayMutantInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get monsterId() : uint
      {
         return _target.monsterId;
      }
      
      public function get powerLevel() : int
      {
         return _target.powerLevel;
      }
   }
}
