package d2network
{
   public class ServerSessionConstantString extends ServerSessionConstant
   {
       
      
      public function ServerSessionConstantString(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : String
      {
         return _target.value;
      }
   }
}
