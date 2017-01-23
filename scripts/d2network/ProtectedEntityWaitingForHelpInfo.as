package d2network
{
   import utils.ReadOnlyData;
   
   public class ProtectedEntityWaitingForHelpInfo extends ReadOnlyData
   {
       
      
      public function ProtectedEntityWaitingForHelpInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get timeLeftBeforeFight() : int
      {
         return _target.timeLeftBeforeFight;
      }
      
      public function get waitTimeForPlacement() : int
      {
         return _target.waitTimeForPlacement;
      }
      
      public function get nbPositionForDefensors() : uint
      {
         return _target.nbPositionForDefensors;
      }
   }
}
