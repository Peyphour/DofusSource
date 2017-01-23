package d2network
{
   import utils.ReadOnlyData;
   
   public class ActorRestrictionsInformations extends ReadOnlyData
   {
       
      
      public function ActorRestrictionsInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get cantBeAggressed() : Boolean
      {
         return _target.cantBeAggressed;
      }
      
      public function get cantBeChallenged() : Boolean
      {
         return _target.cantBeChallenged;
      }
      
      public function get cantTrade() : Boolean
      {
         return _target.cantTrade;
      }
      
      public function get cantBeAttackedByMutant() : Boolean
      {
         return _target.cantBeAttackedByMutant;
      }
      
      public function get cantRun() : Boolean
      {
         return _target.cantRun;
      }
      
      public function get forceSlowWalk() : Boolean
      {
         return _target.forceSlowWalk;
      }
      
      public function get cantMinimize() : Boolean
      {
         return _target.cantMinimize;
      }
      
      public function get cantMove() : Boolean
      {
         return _target.cantMove;
      }
      
      public function get cantAggress() : Boolean
      {
         return _target.cantAggress;
      }
      
      public function get cantChallenge() : Boolean
      {
         return _target.cantChallenge;
      }
      
      public function get cantExchange() : Boolean
      {
         return _target.cantExchange;
      }
      
      public function get cantAttack() : Boolean
      {
         return _target.cantAttack;
      }
      
      public function get cantChat() : Boolean
      {
         return _target.cantChat;
      }
      
      public function get cantBeMerchant() : Boolean
      {
         return _target.cantBeMerchant;
      }
      
      public function get cantUseObject() : Boolean
      {
         return _target.cantUseObject;
      }
      
      public function get cantUseTaxCollector() : Boolean
      {
         return _target.cantUseTaxCollector;
      }
      
      public function get cantUseInteractive() : Boolean
      {
         return _target.cantUseInteractive;
      }
      
      public function get cantSpeakToNPC() : Boolean
      {
         return _target.cantSpeakToNPC;
      }
      
      public function get cantChangeZone() : Boolean
      {
         return _target.cantChangeZone;
      }
      
      public function get cantAttackMonster() : Boolean
      {
         return _target.cantAttackMonster;
      }
      
      public function get cantWalk8Directions() : Boolean
      {
         return _target.cantWalk8Directions;
      }
   }
}
