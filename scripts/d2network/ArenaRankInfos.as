package d2network
{
   import utils.ReadOnlyData;
   
   public class ArenaRankInfos extends ReadOnlyData
   {
       
      
      public function ArenaRankInfos(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get rank() : uint
      {
         return _target.rank;
      }
      
      public function get bestRank() : uint
      {
         return _target.bestRank;
      }
      
      public function get victoryCount() : uint
      {
         return _target.victoryCount;
      }
      
      public function get fightcount() : uint
      {
         return _target.fightcount;
      }
   }
}
