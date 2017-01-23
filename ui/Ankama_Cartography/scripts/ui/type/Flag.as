package ui.type
{
   import flash.geom.Point;
   
   public class Flag
   {
       
      
      public var id:String;
      
      public var position:Point;
      
      public var legend:String;
      
      public var color:uint;
      
      public var canBeManuallyRemoved:Boolean;
      
      public var worldMap:int;
      
      public var allowDuplicate:Boolean;
      
      public function Flag(param1:String, param2:int, param3:int, param4:String, param5:int = -1, param6:Boolean = true, param7:Boolean = false)
      {
         super();
         this.id = param1;
         this.position = new Point(param2,param3);
         this.legend = param4;
         this.color = param5;
         this.canBeManuallyRemoved = param6;
         this.allowDuplicate = param7;
      }
   }
}
