package d2network
{
   import utils.ReadOnlyData;
   
   public class TreasureHuntFlag extends ReadOnlyData
   {
       
      
      public function TreasureHuntFlag(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get state() : uint
      {
         return _target.state;
      }
   }
}
