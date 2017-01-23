package d2network
{
   public class GameFightMinimalStatsPreparation extends GameFightMinimalStats
   {
       
      
      public function GameFightMinimalStatsPreparation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get initiative() : uint
      {
         return _target.initiative;
      }
   }
}
