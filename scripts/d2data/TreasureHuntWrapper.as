package d2data
{
   import utils.ReadOnlyData;
   
   public class TreasureHuntWrapper extends ReadOnlyData
   {
       
      
      public function TreasureHuntWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get questType() : uint
      {
         return _target.questType;
      }
      
      public function get checkPointCurrent() : uint
      {
         return _target.checkPointCurrent;
      }
      
      public function get checkPointTotal() : uint
      {
         return _target.checkPointTotal;
      }
      
      public function get totalStepCount() : uint
      {
         return _target.totalStepCount;
      }
      
      public function get availableRetryCount() : int
      {
         return _target.availableRetryCount;
      }
      
      public function get stepList() : Object
      {
         return secure(_target.stepList);
      }
   }
}
