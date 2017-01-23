package d2network
{
   public class FightTemporarySpellBoostEffect extends FightTemporaryBoostEffect
   {
       
      
      public function FightTemporarySpellBoostEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get boostedSpellId() : uint
      {
         return _target.boostedSpellId;
      }
   }
}
