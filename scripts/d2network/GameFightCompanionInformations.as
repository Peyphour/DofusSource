package d2network
{
   public class GameFightCompanionInformations extends GameFightFighterInformations
   {
       
      
      public function GameFightCompanionInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get companionGenericId() : uint
      {
         return _target.companionGenericId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get masterId() : Number
      {
         return _target.masterId;
      }
   }
}
