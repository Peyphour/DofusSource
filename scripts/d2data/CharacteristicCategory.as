package d2data
{
   import utils.ReadOnlyData;
   
   public class CharacteristicCategory extends ReadOnlyData
   {
       
      
      public function CharacteristicCategory(param1:*, param2:Object)
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
      
      public function get order() : int
      {
         return _target.order;
      }
      
      public function get characteristicIds() : Object
      {
         return secure(_target.characteristicIds);
      }
   }
}
