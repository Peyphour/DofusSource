package d2data
{
   import utils.ReadOnlyData;
   
   public class SkinMapping extends ReadOnlyData
   {
       
      
      public function SkinMapping(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get lowDefId() : int
      {
         return _target.lowDefId;
      }
   }
}
