package d2data
{
   import utils.ReadOnlyData;
   
   public class Shortcut extends ReadOnlyData
   {
       
      
      public function Shortcut(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get defaultBind() : Bind
      {
         return secure(_target.defaultBind);
      }
   }
}
