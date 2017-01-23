package d2network
{
   public class GameFightFighterInformations extends GameContextActorInformations
   {
       
      
      public function GameFightFighterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get teamId() : uint
      {
         return _target.teamId;
      }
      
      public function get wave() : uint
      {
         return _target.wave;
      }
      
      public function get alive() : Boolean
      {
         return _target.alive;
      }
      
      public function get stats() : GameFightMinimalStats
      {
         return secure(_target.stats);
      }
      
      public function get previousPositions() : Object
      {
         return secure(_target.previousPositions);
      }
   }
}
