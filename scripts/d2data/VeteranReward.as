package d2data
{
   import utils.ReadOnlyData;
   
   public class VeteranReward extends ReadOnlyData
   {
       
      
      public function VeteranReward(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get requiredSubDays() : uint
      {
         return _target.requiredSubDays;
      }
      
      public function get itemGID() : uint
      {
         return _target.itemGID;
      }
      
      public function get itemQuantity() : uint
      {
         return _target.itemQuantity;
      }
   }
}
