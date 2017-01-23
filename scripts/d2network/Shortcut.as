package d2network
{
   import utils.ReadOnlyData;
   
   public class Shortcut extends ReadOnlyData
   {
       
      
      public function Shortcut(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get slot() : uint
      {
         return _target.slot;
      }
   }
}
