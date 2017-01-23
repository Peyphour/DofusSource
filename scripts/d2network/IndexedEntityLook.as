package d2network
{
   import utils.ReadOnlyData;
   
   public class IndexedEntityLook extends ReadOnlyData
   {
       
      
      public function IndexedEntityLook(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get look() : EntityLook
      {
         return secure(_target.look);
      }
      
      public function get index() : uint
      {
         return _target.index;
      }
   }
}
