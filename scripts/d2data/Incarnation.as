package d2data
{
   import utils.ReadOnlyData;
   
   public class Incarnation extends ReadOnlyData
   {
       
      
      public function Incarnation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get lookMale() : String
      {
         return _target.lookMale;
      }
      
      public function get lookFemale() : String
      {
         return _target.lookFemale;
      }
   }
}
