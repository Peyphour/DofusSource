package d2data
{
   import utils.ReadOnlyData;
   
   public class OfflineSaleWrapper extends ReadOnlyData
   {
       
      
      public function OfflineSaleWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get index() : uint
      {
         return _target.index;
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get itemId() : uint
      {
         return _target.itemId;
      }
      
      public function get itemName() : String
      {
         return _target.itemName;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
      
      public function get kamas() : Number
      {
         return _target.kamas;
      }
   }
}
