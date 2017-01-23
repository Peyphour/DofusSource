package d2data
{
   import d2network.JobDescription;
   import utils.ReadOnlyData;
   
   public class KnownJobWrapper extends ReadOnlyData
   {
       
      
      public function KnownJobWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get jobDescription() : JobDescription
      {
         return secure(_target.jobDescription);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get iconId() : int
      {
         return _target.iconId;
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
      
      public function get jobBookSubscriber() : Boolean
      {
         return _target.jobBookSubscriber;
      }
   }
}
