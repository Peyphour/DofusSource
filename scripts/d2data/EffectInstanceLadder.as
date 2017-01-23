package d2data
{
   public class EffectInstanceLadder extends EffectInstanceCreature
   {
       
      
      public function EffectInstanceLadder(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get monsterCount() : uint
      {
         return _target.monsterCount;
      }
   }
}
