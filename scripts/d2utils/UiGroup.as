package d2utils
{
   import utils.DirectAccessObject;
   
   public dynamic class UiGroup extends DirectAccessObject
   {
       
      
      public function UiGroup(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get exclusive() : Boolean
      {
         return _target.exclusive;
      }
      
      public function get permanent() : Boolean
      {
         return _target.permanent;
      }
      
      public function get uis() : Object
      {
         return _target.uis;
      }
   }
}
