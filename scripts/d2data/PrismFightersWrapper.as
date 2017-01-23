package d2data
{
   import d2network.CharacterMinimalPlusLookInformations;
   import utils.ReadOnlyData;
   
   public class PrismFightersWrapper extends ReadOnlyData
   {
       
      
      public function PrismFightersWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerCharactersInformations() : CharacterMinimalPlusLookInformations
      {
         return secure(_target.playerCharactersInformations);
      }
      
      public function get entityLook() : Object
      {
         return secure(_target.entityLook);
      }
   }
}
