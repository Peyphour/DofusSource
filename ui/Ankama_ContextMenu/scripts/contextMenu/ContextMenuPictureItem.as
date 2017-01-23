package contextMenu
{
   public class ContextMenuPictureItem extends ContextMenuItem
   {
       
      
      public var uri:String;
      
      public function ContextMenuPictureItem(param1:String, param2:Function = null, param3:Array = null, param4:Boolean = false, param5:Array = null, param6:Boolean = false, param7:Boolean = false, param8:String = null, param9:Boolean = false, param10:uint = 1000)
      {
         super("",param2,param3,param4,param5,param6,param7,param8,param9,param10);
         this.uri = param1;
      }
   }
}
