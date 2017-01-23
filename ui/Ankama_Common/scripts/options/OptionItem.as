package options
{
   public class OptionItem
   {
       
      
      public var id:String;
      
      public var name:String;
      
      public var description:String;
      
      public var ui:String;
      
      public var childItems:Array;
      
      public function OptionItem(param1:String, param2:String, param3:String, param4:String = null, param5:Array = null)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.description = param3;
         this.ui = param4;
         this.childItems = param5;
      }
      
      public function get label() : String
      {
         return this.name;
      }
   }
}
