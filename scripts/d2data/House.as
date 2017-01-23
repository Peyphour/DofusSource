package d2data
{
   import utils.ReadOnlyData;
   
   public class House extends ReadOnlyData
   {
       
      
      public function House(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get typeId() : int
      {
         return _target.typeId;
      }
      
      public function get defaultPrice() : uint
      {
         return _target.defaultPrice;
      }
      
      public function get nameId() : int
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : int
      {
         return _target.descriptionId;
      }
      
      public function get gfxId() : int
      {
         return _target.gfxId;
      }
   }
}
