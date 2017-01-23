package d2data
{
   import utils.ReadOnlyData;
   
   public class CreationCharacterWrapper extends ReadOnlyData
   {
       
      
      public function CreationCharacterWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get gender() : Boolean
      {
         return _target.gender;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get cosmeticId() : uint
      {
         return _target.cosmeticId;
      }
      
      public function get colors() : Object
      {
         return secure(_target.colors);
      }
      
      public function get entityLook() : Object
      {
         return secure(_target.entityLook);
      }
   }
}
