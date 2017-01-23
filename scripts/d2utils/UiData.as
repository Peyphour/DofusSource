package d2utils
{
   import utils.DirectAccessObject;
   
   public dynamic class UiData extends DirectAccessObject
   {
       
      
      public function UiData(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get module() : UiModule
      {
         return _target.module;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get file() : String
      {
         return _target.file;
      }
      
      public function get uiClassName() : String
      {
         return _target.uiClassName;
      }
      
      public function get xml() : String
      {
         return _target.xml;
      }
      
      public function get uiGroupName() : String
      {
         return _target.uiGroupName;
      }
   }
}
