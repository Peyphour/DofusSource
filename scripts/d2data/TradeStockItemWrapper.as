package d2data
{
   import utils.ReadOnlyData;
   
   public class TradeStockItemWrapper extends ReadOnlyData
   {
       
      
      public function TradeStockItemWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get itemWrapper() : ItemWrapper
      {
         return secure(_target.itemWrapper);
      }
      
      public function get price() : uint
      {
         return _target.price;
      }
      
      public function get category() : int
      {
         return _target.category;
      }
      
      public function get criterion() : GroupItemCriterion
      {
         return secure(_target.criterion);
      }
   }
}
