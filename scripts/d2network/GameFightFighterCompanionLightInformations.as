package d2network
{
   public class GameFightFighterCompanionLightInformations extends GameFightFighterLightInformations
   {
       
      
      public function GameFightFighterCompanionLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get companionId() : uint
      {
         return _target.companionId;
      }
      
      public function get masterId() : Number
      {
         return _target.masterId;
      }
   }
}
