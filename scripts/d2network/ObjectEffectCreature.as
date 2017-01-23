package d2network
{
   public class ObjectEffectCreature extends ObjectEffect
   {
       
      
      public function ObjectEffectCreature(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get monsterFamilyId() : uint
      {
         return _target.monsterFamilyId;
      }
   }
}
