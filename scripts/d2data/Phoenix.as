package d2data
{
   import utils.ReadOnlyData;
   
   public class Phoenix extends ReadOnlyData
   {
       
      
      public function Phoenix(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mapId() : uint
      {
         return _target.mapId;
      }
   }
}
