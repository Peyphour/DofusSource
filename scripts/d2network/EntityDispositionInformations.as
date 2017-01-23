package d2network
{
   import utils.ReadOnlyData;
   
   public class EntityDispositionInformations extends ReadOnlyData
   {
       
      
      public function EntityDispositionInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get cellId() : int
      {
         return _target.cellId;
      }
      
      public function get direction() : uint
      {
         return _target.direction;
      }
   }
}
