package d2utils
{
   public dynamic class PreCompiledUiModule extends UiModule
   {
       
      
      public function PreCompiledUiModule(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function hasDefinition(param1:UiData) : Boolean
      {
         return _target.hasDefinition(param1);
      }
      
      public function getDefinition(param1:UiData) : Object
      {
         return _target.getDefinition(param1);
      }
      
      public function addUiDefinition(param1:Object, param2:UiData) : void
      {
         _target.addUiDefinition(param1,param2);
      }
      
      public function flush(param1:Object) : void
      {
         _target.flush(param1);
      }
   }
}
