package d2network
{
   import utils.ReadOnlyData;
   
   public class SubEntity extends ReadOnlyData
   {
       
      
      public function SubEntity(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get bindingPointCategory() : uint
      {
         return _target.bindingPointCategory;
      }
      
      public function get bindingPointIndex() : uint
      {
         return _target.bindingPointIndex;
      }
      
      public function get subEntityLook() : EntityLook
      {
         return secure(_target.subEntityLook);
      }
   }
}
