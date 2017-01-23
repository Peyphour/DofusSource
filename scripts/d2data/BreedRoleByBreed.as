package d2data
{
   import utils.ReadOnlyData;
   
   public class BreedRoleByBreed extends ReadOnlyData
   {
       
      
      public function BreedRoleByBreed(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get breedId() : int
      {
         return _target.breedId;
      }
      
      public function get roleId() : int
      {
         return _target.roleId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get value() : int
      {
         return _target.value;
      }
      
      public function get order() : int
      {
         return _target.order;
      }
   }
}
