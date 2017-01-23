package d2data
{
   import utils.ReadOnlyData;
   
   public class AbuseReasons extends ReadOnlyData
   {
       
      
      public function AbuseReasons(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get _abuseReasonId() : uint
      {
         return _target._abuseReasonId;
      }
      
      public function get _mask() : uint
      {
         return _target._mask;
      }
      
      public function get _reasonTextId() : int
      {
         return _target._reasonTextId;
      }
   }
}
