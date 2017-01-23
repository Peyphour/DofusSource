package contextMenu
{
   public class ContextMenuPictureLabelItem extends ContextMenuItem
   {
       
      
      public var uri:String;
      
      public var txSize:int;
      
      public var pictureAfterLaber:Boolean;
      
      public function ContextMenuPictureLabelItem(param1:String, param2:String, param3:int, param4:Boolean, param5:Function = null, param6:Array = null, param7:Boolean = false, param8:Array = null, param9:Boolean = false, param10:Boolean = false, param11:String = null, param12:Boolean = false, param13:uint = 1000)
      {
         super(param2,param5,param6,param7,param8,param9,param10,param11,param12,param13);
         this.uri = param1;
         this.txSize = param3;
         this.pictureAfterLaber = param4;
      }
   }
}
