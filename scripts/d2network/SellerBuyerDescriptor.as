package d2network
{
   import utils.ReadOnlyData;
   
   public class SellerBuyerDescriptor extends ReadOnlyData
   {
       
      
      public function SellerBuyerDescriptor(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get quantities() : Object
      {
         return secure(_target.quantities);
      }
      
      public function get types() : Object
      {
         return secure(_target.types);
      }
      
      public function get taxPercentage() : Number
      {
         return _target.taxPercentage;
      }
      
      public function get taxModificationPercentage() : Number
      {
         return _target.taxModificationPercentage;
      }
      
      public function get maxItemLevel() : uint
      {
         return _target.maxItemLevel;
      }
      
      public function get maxItemPerAccount() : uint
      {
         return _target.maxItemPerAccount;
      }
      
      public function get npcContextualId() : int
      {
         return _target.npcContextualId;
      }
      
      public function get unsoldDelay() : uint
      {
         return _target.unsoldDelay;
      }
   }
}
