package d2network
{
   import utils.ReadOnlyData;
   
   public class JobExperience extends ReadOnlyData
   {
       
      
      public function JobExperience(param1:*, param2:Object)
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
      
      public function get jobXP() : Number
      {
         return _target.jobXP;
      }
      
      public function get jobXpLevelFloor() : Number
      {
         return _target.jobXpLevelFloor;
      }
      
      public function get jobXpNextLevelFloor() : Number
      {
         return _target.jobXpNextLevelFloor;
      }
   }
}
