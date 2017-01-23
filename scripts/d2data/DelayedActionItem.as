package d2data
{
   import utils.ReadOnlyData;
   
   public class DelayedActionItem extends ReadOnlyData
   {
       
      
      public function DelayedActionItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get dataId() : int
      {
         return _target.dataId;
      }
      
      public function get endTime() : Number
      {
         return _target.endTime;
      }
   }
}
