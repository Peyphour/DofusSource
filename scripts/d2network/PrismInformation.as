package d2network
{
   import utils.ReadOnlyData;
   
   public class PrismInformation extends ReadOnlyData
   {
       
      
      public function PrismInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get state() : uint
      {
         return _target.state;
      }
      
      public function get nextVulnerabilityDate() : uint
      {
         return _target.nextVulnerabilityDate;
      }
      
      public function get placementDate() : uint
      {
         return _target.placementDate;
      }
      
      public function get rewardTokenCount() : uint
      {
         return _target.rewardTokenCount;
      }
   }
}
