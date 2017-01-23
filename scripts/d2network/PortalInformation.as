package d2network
{
   import utils.ReadOnlyData;
   
   public class PortalInformation extends ReadOnlyData
   {
       
      
      public function PortalInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get portalId() : int
      {
         return _target.portalId;
      }
      
      public function get areaId() : int
      {
         return _target.areaId;
      }
   }
}
