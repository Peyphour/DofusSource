package d2network
{
   import utils.ReadOnlyData;
   
   public class ContentPart extends ReadOnlyData
   {
       
      
      public function ContentPart(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : String
      {
         return _target.id;
      }
      
      public function get state() : uint
      {
         return _target.state;
      }
   }
}
