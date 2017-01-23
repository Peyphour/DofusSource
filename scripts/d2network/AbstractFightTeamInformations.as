package d2network
{
   import utils.ReadOnlyData;
   
   public class AbstractFightTeamInformations extends ReadOnlyData
   {
       
      
      public function AbstractFightTeamInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get teamId() : uint
      {
         return _target.teamId;
      }
      
      public function get leaderId() : Number
      {
         return _target.leaderId;
      }
      
      public function get teamSide() : int
      {
         return _target.teamSide;
      }
      
      public function get teamTypeId() : uint
      {
         return _target.teamTypeId;
      }
      
      public function get nbWaves() : uint
      {
         return _target.nbWaves;
      }
   }
}
