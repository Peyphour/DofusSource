package d2network
{
   public class FightTemporaryBoostWeaponDamagesEffect extends FightTemporaryBoostEffect
   {
       
      
      public function FightTemporaryBoostWeaponDamagesEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get weaponTypeId() : int
      {
         return _target.weaponTypeId;
      }
   }
}
