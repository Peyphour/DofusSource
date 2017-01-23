package d2data
{
   import utils.ReadOnlyData;
   
   public class Tips extends ReadOnlyData
   {
       
      
      public function Tips(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get descId() : uint
      {
         return _target.descId;
      }
   }
}
