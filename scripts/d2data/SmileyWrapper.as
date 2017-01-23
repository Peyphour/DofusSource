package d2data
{
   import utils.ReadOnlyData;
   
   public class SmileyWrapper extends ReadOnlyData
   {
       
      
      public function SmileyWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get iconId() : String
      {
         return _target.iconId;
      }
      
      public function get packId() : int
      {
         return _target.packId;
      }
      
      public function get categoryId() : int
      {
         return _target.categoryId;
      }
      
      public function get isOkForMultiUse() : Boolean
      {
         return _target.isOkForMultiUse;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
