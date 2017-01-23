package d2network
{
   import utils.ReadOnlyData;
   
   public class PrismSubareaEmptyInfo extends ReadOnlyData
   {
       
      
      public function PrismSubareaEmptyInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
   }
}
