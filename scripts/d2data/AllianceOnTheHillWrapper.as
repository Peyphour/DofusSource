package d2data
{
   import utils.ReadOnlyData;
   
   public class AllianceOnTheHillWrapper extends ReadOnlyData
   {
       
      
      public function AllianceOnTheHillWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
      
      public function get upEmblem() : EmblemWrapper
      {
         return secure(_target.upEmblem);
      }
      
      public function get backEmblem() : EmblemWrapper
      {
         return secure(_target.backEmblem);
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
      
      public function get roundWeigth() : uint
      {
         return _target.roundWeigth;
      }
      
      public function get matchScore() : uint
      {
         return _target.matchScore;
      }
      
      public function get side() : uint
      {
         return _target.side;
      }
   }
}
