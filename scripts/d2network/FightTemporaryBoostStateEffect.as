package d2network
{
   public class FightTemporaryBoostStateEffect extends FightTemporaryBoostEffect
   {
       
      
      public function FightTemporaryBoostStateEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get stateId() : int
      {
         return _target.stateId;
      }
   }
}
