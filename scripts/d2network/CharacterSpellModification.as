package d2network
{
   import utils.ReadOnlyData;
   
   public class CharacterSpellModification extends ReadOnlyData
   {
       
      
      public function CharacterSpellModification(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get modificationType() : uint
      {
         return _target.modificationType;
      }
      
      public function get spellId() : uint
      {
         return _target.spellId;
      }
      
      public function get value() : CharacterBaseCharacteristic
      {
         return secure(_target.value);
      }
   }
}
