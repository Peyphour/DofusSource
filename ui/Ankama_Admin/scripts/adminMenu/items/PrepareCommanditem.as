package adminMenu.items
{
   public class PrepareCommanditem extends SendCommandItem
   {
       
      
      public function PrepareCommanditem(param1:String, param2:int = 0, param3:int = 1)
      {
         super(param1,param2,param3);
      }
      
      override public function getcallbackArgs(param1:Object) : Array
      {
         return [replace(command,param1),false,true];
      }
   }
}
