package d2network
{
   public class ObjectEffectLadder extends ObjectEffectCreature
   {
       
      
      public function ObjectEffectLadder(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get monsterCount() : uint
      {
         return _target.monsterCount;
      }
   }
}
