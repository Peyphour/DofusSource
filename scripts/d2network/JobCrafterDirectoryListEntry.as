package d2network
{
   import utils.ReadOnlyData;
   
   public class JobCrafterDirectoryListEntry extends ReadOnlyData
   {
       
      
      public function JobCrafterDirectoryListEntry(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerInfo() : JobCrafterDirectoryEntryPlayerInfo
      {
         return secure(_target.playerInfo);
      }
      
      public function get jobInfo() : JobCrafterDirectoryEntryJobInfo
      {
         return secure(_target.jobInfo);
      }
   }
}
