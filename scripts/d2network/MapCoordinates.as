package d2network
{
   import utils.ReadOnlyData;
   
   public class MapCoordinates extends ReadOnlyData
   {
       
      
      public function MapCoordinates(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
   }
}
