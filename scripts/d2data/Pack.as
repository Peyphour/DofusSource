package d2data
{
   import utils.ReadOnlyData;
   
   public class Pack extends ReadOnlyData
   {
       
      
      public function Pack(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get hasSubAreas() : Boolean
      {
         return _target.hasSubAreas;
      }
   }
}
