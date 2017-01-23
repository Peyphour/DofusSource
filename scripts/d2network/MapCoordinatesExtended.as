package d2network
{
   public class MapCoordinatesExtended extends MapCoordinatesAndId
   {
       
      
      public function MapCoordinatesExtended(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
   }
}
