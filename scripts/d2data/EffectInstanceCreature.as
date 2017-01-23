package d2data
{
   public class EffectInstanceCreature extends EffectInstance
   {
       
      
      public function EffectInstanceCreature(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get monsterFamilyId() : uint
      {
         return _target.monsterFamilyId;
      }
   }
}
