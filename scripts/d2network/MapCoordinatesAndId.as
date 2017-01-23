package d2network
{
   public class MapCoordinatesAndId extends MapCoordinates
   {
       
      
      public function MapCoordinatesAndId(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
   }
}
