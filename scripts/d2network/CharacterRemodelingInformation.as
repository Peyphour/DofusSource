package d2network
{
   public class CharacterRemodelingInformation extends AbstractCharacterInformation
   {
       
      
      public function CharacterRemodelingInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get cosmeticId() : uint
      {
         return _target.cosmeticId;
      }
      
      public function get colors() : Object
      {
         return secure(_target.colors);
      }
   }
}
