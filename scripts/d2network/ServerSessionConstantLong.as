package d2network
{
   public class ServerSessionConstantLong extends ServerSessionConstant
   {
       
      
      public function ServerSessionConstantLong(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : Number
      {
         return _target.value;
      }
   }
}
