package d2data
{
   import utils.ReadOnlyData;
   
   public class Url extends ReadOnlyData
   {
       
      
      public function Url(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get browserId() : int
      {
         return _target.browserId;
      }
      
      public function get url() : String
      {
         return _target.url;
      }
      
      public function get param() : String
      {
         return _target.param;
      }
      
      public function get method() : String
      {
         return _target.method;
      }
   }
}
