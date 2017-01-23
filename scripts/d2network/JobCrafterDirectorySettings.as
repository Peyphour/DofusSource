package d2network
{
   import utils.ReadOnlyData;
   
   public class JobCrafterDirectorySettings extends ReadOnlyData
   {
       
      
      public function JobCrafterDirectorySettings(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get jobId() : uint
      {
         return _target.jobId;
      }
      
      public function get minLevel() : uint
      {
         return _target.minLevel;
      }
      
      public function get free() : Boolean
      {
         return _target.free;
      }
   }
}
