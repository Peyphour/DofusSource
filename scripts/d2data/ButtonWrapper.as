package d2data
{
   import utils.ReadOnlyData;
   
   public class ButtonWrapper extends ReadOnlyData
   {
       
      
      public function ButtonWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get position() : uint
      {
         return _target.position;
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get uriName() : String
      {
         return _target.uriName;
      }
      
      public function get callback() : Function
      {
         return secure(_target.callback);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get shortcut() : String
      {
         return _target.shortcut;
      }
      
      public function get description() : String
      {
         return _target.description;
      }
   }
}
