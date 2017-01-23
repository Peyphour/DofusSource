package adminMenu.items
{
   public class SendChatItem extends ExecItem
   {
       
      
      public var text:String;
      
      public function SendChatItem(param1:String, param2:int = 0, param3:int = 0)
      {
         this.text = param1;
         super(param2,param3);
      }
      
      override public function get callbackFunction() : Function
      {
         var _loc1_:Object = Api.uiApi.getUi("chat");
         if(_loc1_ && _loc1_.uiClass)
         {
            return _loc1_.uiClass.sendMessage;
         }
         return null;
      }
      
      override public function getcallbackArgs(param1:Object) : Array
      {
         return [replace(this.text,param1)];
      }
   }
}
