package d2network
{
   import utils.ReadOnlyData;
   
   public class JobBookSubscription extends ReadOnlyData
   {
       
      
      public function JobBookSubscription(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get jobId() : uint
      {
         return _target.jobId;
      }
      
      public function get subscribed() : Boolean
      {
         return _target.subscribed;
      }
   }
}
