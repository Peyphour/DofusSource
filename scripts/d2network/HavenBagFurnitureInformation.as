package d2network
{
   import utils.ReadOnlyData;
   
   public class HavenBagFurnitureInformation extends ReadOnlyData
   {
       
      
      public function HavenBagFurnitureInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get cellId() : uint
      {
         return _target.cellId;
      }
      
      public function get funitureId() : int
      {
         return _target.funitureId;
      }
      
      public function get orientation() : uint
      {
         return _target.orientation;
      }
   }
}
