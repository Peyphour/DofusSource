package d2data
{
   import utils.ReadOnlyData;
   
   public class TitleCategory extends ReadOnlyData
   {
       
      
      public function TitleCategory(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
   }
}
