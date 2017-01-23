package d2network
{
   import utils.ReadOnlyData;
   
   public class StartupActionAddObject extends ReadOnlyData
   {
       
      
      public function StartupActionAddObject(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get uid() : uint
      {
         return _target.uid;
      }
      
      public function get title() : String
      {
         return _target.title;
      }
      
      public function get text() : String
      {
         return _target.text;
      }
      
      public function get descUrl() : String
      {
         return _target.descUrl;
      }
      
      public function get pictureUrl() : String
      {
         return _target.pictureUrl;
      }
      
      public function get items() : Object
      {
         return secure(_target.items);
      }
   }
}
