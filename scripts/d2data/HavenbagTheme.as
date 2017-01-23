package d2data
{
   import utils.ReadOnlyData;
   
   public class HavenbagTheme extends ReadOnlyData
   {
       
      
      public function HavenbagTheme(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : int
      {
         return _target.nameId;
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
   }
}
