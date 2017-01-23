package d2network
{
   import utils.ReadOnlyData;
   
   public class MapObstacle extends ReadOnlyData
   {
       
      
      public function MapObstacle(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get obstacleCellId() : uint
      {
         return _target.obstacleCellId;
      }
      
      public function get state() : uint
      {
         return _target.state;
      }
   }
}
