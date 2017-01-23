package d2network
{
   public class FightTemporaryBoostEffect extends AbstractFightDispellableEffect
   {
       
      
      public function FightTemporaryBoostEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get delta() : int
      {
         return _target.delta;
      }
   }
}
