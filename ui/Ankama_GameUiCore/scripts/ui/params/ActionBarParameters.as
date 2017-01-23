package ui.params
{
   public class ActionBarParameters
   {
       
      
      public var id:uint;
      
      public var orientation:uint;
      
      public var orientationChanged:Boolean;
      
      public var context:String;
      
      public function ActionBarParameters(param1:uint, param2:uint, param3:Boolean, param4:String)
      {
         super();
         this.id = param1;
         this.orientation = param2;
         this.orientationChanged = param3;
         this.context = param4;
      }
   }
}
