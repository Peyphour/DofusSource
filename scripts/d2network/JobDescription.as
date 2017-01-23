package d2network
{
   import utils.ReadOnlyData;
   
   public class JobDescription extends ReadOnlyData
   {
       
      
      public function JobDescription(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get jobId() : uint
      {
         return _target.jobId;
      }
      
      public function get skills() : Object
      {
         return secure(_target.skills);
      }
   }
}
