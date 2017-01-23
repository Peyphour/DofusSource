package d2network
{
   public class FightEntityDispositionInformations extends EntityDispositionInformations
   {
       
      
      public function FightEntityDispositionInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get carryingCharacterId() : Number
      {
         return _target.carryingCharacterId;
      }
   }
}
