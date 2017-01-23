package d2network
{
   public class CharacterToRemodelInformations extends CharacterRemodelingInformation
   {
       
      
      public function CharacterToRemodelInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get possibleChangeMask() : uint
      {
         return _target.possibleChangeMask;
      }
      
      public function get mandatoryChangeMask() : uint
      {
         return _target.mandatoryChangeMask;
      }
   }
}
