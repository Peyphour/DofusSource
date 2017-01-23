package d2network
{
   public class FightTemporarySpellImmunityEffect extends AbstractFightDispellableEffect
   {
       
      
      public function FightTemporarySpellImmunityEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get immuneSpellId() : int
      {
         return _target.immuneSpellId;
      }
   }
}
