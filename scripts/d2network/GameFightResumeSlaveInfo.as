package d2network
{
   import utils.ReadOnlyData;
   
   public class GameFightResumeSlaveInfo extends ReadOnlyData
   {
       
      
      public function GameFightResumeSlaveInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get slaveId() : Number
      {
         return _target.slaveId;
      }
      
      public function get spellCooldowns() : Object
      {
         return secure(_target.spellCooldowns);
      }
      
      public function get summonCount() : uint
      {
         return _target.summonCount;
      }
      
      public function get bombCount() : uint
      {
         return _target.bombCount;
      }
   }
}
