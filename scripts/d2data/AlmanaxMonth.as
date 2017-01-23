package d2data
{
   import utils.ReadOnlyData;
   
   public class AlmanaxMonth extends ReadOnlyData
   {
       
      
      public function AlmanaxMonth(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get monthNum() : uint
      {
         return _target.monthNum;
      }
      
      public function get protectorName() : String
      {
         return _target.protectorName;
      }
      
      public function get protectorDescription() : String
      {
         return _target.protectorDescription;
      }
      
      public function get webImageUrl() : String
      {
         return _target.webImageUrl;
      }
   }
}
