package d2network
{
   public class GameRolePlayGroupMonsterWaveInformations extends GameRolePlayGroupMonsterInformations
   {
       
      
      public function GameRolePlayGroupMonsterWaveInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get nbWaves() : uint
      {
         return _target.nbWaves;
      }
      
      public function get alternatives() : Object
      {
         return secure(_target.alternatives);
      }
   }
}
