package d2data
{
   import utils.ReadOnlyData;
   
   public class CompanionCharacteristic extends ReadOnlyData
   {
       
      
      public function CompanionCharacteristic(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get caracId() : int
      {
         return _target.caracId;
      }
      
      public function get companionId() : int
      {
         return _target.companionId;
      }
      
      public function get order() : int
      {
         return _target.order;
      }
      
      public function get statPerLevelRange() : Object
      {
         return secure(_target.statPerLevelRange);
      }
   }
}
