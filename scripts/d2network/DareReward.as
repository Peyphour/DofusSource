package d2network
{
   import utils.ReadOnlyData;
   
   public class DareReward extends ReadOnlyData
   {
       
      
      public function DareReward(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get monsterId() : uint
      {
         return _target.monsterId;
      }
      
      public function get kamas() : uint
      {
         return _target.kamas;
      }
      
      public function get dareId() : Number
      {
         return _target.dareId;
      }
   }
}
