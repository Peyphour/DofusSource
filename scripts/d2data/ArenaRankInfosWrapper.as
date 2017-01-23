package d2data
{
   import utils.ReadOnlyData;
   
   public class ArenaRankInfosWrapper extends ReadOnlyData
   {
       
      
      public function ArenaRankInfosWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get rank() : int
      {
         return _target.rank;
      }
      
      public function get maxRank() : int
      {
         return _target.maxRank;
      }
      
      public function get todayFightCount() : int
      {
         return _target.todayFightCount;
      }
      
      public function get todayVictoryCount() : int
      {
         return _target.todayVictoryCount;
      }
   }
}
