package d2data
{
   import utils.ReadOnlyData;
   
   public class BreedRole extends ReadOnlyData
   {
       
      
      public function BreedRole(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get assetId() : int
      {
         return _target.assetId;
      }
      
      public function get color() : int
      {
         return _target.color;
      }
   }
}
