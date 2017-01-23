package types
{
   public class ConfigProperty
   {
       
      
      public var associatedComponent;
      
      public var associatedProperty:String;
      
      public var associatedConfigModule:String;
      
      public function ConfigProperty(param1:String, param2:String, param3:String)
      {
         super();
         this.associatedComponent = param1;
         this.associatedConfigModule = param3;
         this.associatedProperty = param2;
      }
   }
}
