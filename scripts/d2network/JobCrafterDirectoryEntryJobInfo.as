package d2network
{
   import utils.ReadOnlyData;
   
   public class JobCrafterDirectoryEntryJobInfo extends ReadOnlyData
   {
       
      
      public function JobCrafterDirectoryEntryJobInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get jobId() : uint
      {
         return _target.jobId;
      }
      
      public function get jobLevel() : uint
      {
         return _target.jobLevel;
      }
      
      public function get free() : Boolean
      {
         return _target.free;
      }
      
      public function get minLevel() : uint
      {
         return _target.minLevel;
      }
   }
}
