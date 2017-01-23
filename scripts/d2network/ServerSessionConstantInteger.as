package d2network
{
   public class ServerSessionConstantInteger extends ServerSessionConstant
   {
       
      
      public function ServerSessionConstantInteger(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
