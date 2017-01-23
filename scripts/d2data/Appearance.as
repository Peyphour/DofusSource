package d2data
{
   import utils.ReadOnlyData;
   
   public class Appearance extends ReadOnlyData
   {
       
      
      public function Appearance(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get data() : String
      {
         return _target.data;
      }
   }
}
