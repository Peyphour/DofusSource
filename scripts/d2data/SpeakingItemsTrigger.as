package d2data
{
   import utils.ReadOnlyData;
   
   public class SpeakingItemsTrigger extends ReadOnlyData
   {
       
      
      public function SpeakingItemsTrigger(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get triggersId() : int
      {
         return _target.triggersId;
      }
      
      public function get textIds() : Object
      {
         return secure(_target.textIds);
      }
      
      public function get states() : Object
      {
         return secure(_target.states);
      }
   }
}
