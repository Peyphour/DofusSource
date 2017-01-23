package d2network
{
   public class CharacterMinimalPlusLookInformations extends CharacterMinimalInformations
   {
       
      
      public function CharacterMinimalPlusLookInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get entityLook() : EntityLook
      {
         return secure(_target.entityLook);
      }
   }
}
