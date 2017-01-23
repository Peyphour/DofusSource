package d2data
{
   import d2network.CharacterMinimalPlusLookInformations;
   import utils.ReadOnlyData;
   
   public class SocialFightersWrapper extends ReadOnlyData
   {
       
      
      public function SocialFightersWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get ally() : uint
      {
         return _target.ally;
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
