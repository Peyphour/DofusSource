package d2data
{
   import utils.ReadOnlyData;
   
   public class AlmanaxZodiac extends ReadOnlyData
   {
       
      
      public function AlmanaxZodiac(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get description() : String
      {
         return _target.description;
      }
      
      public function get webImageUrl() : String
      {
         return _target.webImageUrl;
      }
   }
}
