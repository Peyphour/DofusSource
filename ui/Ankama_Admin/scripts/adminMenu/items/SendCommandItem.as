package adminMenu.items
{
   public class SendCommandItem extends ExecItem
   {
       
      
      public var command:String;
      
      public function SendCommandItem(param1:String, param2:int = 0, param3:int = 1)
      {
         this.command = param1;
         super(param2,param3);
      }
      
      override public function get callbackFunction() : Function
      {
         switch(this.getReplaceString(this.command))
         {
            case "item":
            case "monster":
            case "look":
            case "fireworks":
            case "spell":
               return this.openSelectItem;
            default:
               return Api.consoleMod.addCommande;
         }
      }
      
      private function openSelectItem(... rest) : void
      {
         _cmdArg = rest;
         if(Api.uiApi.getUi("adminSelectItem"))
         {
            Api.uiApi.unloadUi("adminSelectItem");
         }
         Api.uiApi.loadUi("adminSelectItem","adminSelectItem",[this.execItemCmd,rest[0],true]);
      }
      
      private function execItemCmd(param1:String, param2:String) : void
      {
         var _loc3_:String = this.getReplaceString(param2);
         var _loc4_:int = param2.indexOf("#" + _loc3_);
         param2 = param2.substr(0,_loc4_) + param1 + param2.substr(_loc4_ + _loc3_.length + 1);
         _loc3_ = this.getReplaceString(param2);
         if(_loc3_)
         {
            _cmdArg[0] = param2;
            this.openSelectItem.apply(this,_cmdArg);
            _cmdArg[0] = this.command;
         }
         else
         {
            Api.consoleMod.addCommande(param2,_cmdArg[1],_cmdArg[2]);
         }
      }
      
      override public function getcallbackArgs(param1:Object) : Array
      {
         return [replace(this.command,param1),true,false];
      }
      
      private function getReplaceString(param1:String) : String
      {
         var _loc2_:uint = param1.indexOf("#");
         if(param1.substr(_loc2_ + 1,4) == "item")
         {
            return "item";
         }
         if(param1.substr(_loc2_ + 1,4) == "look")
         {
            return "look";
         }
         if(param1.substr(_loc2_ + 1,7) == "monster")
         {
            return "monster";
         }
         if(param1.substr(_loc2_ + 1,9) == "fireworks")
         {
            return "fireworks";
         }
         if(param1.substr(_loc2_ + 1,5) == "spell")
         {
            return "spell";
         }
         return null;
      }
   }
}
