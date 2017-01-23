package d2network
{
   import utils.ReadOnlyData;
   
   public class EntityLook extends ReadOnlyData
   {
       
      
      public function EntityLook(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get bonesId() : uint
      {
         return _target.bonesId;
      }
      
      public function get skins() : Object
      {
         return secure(_target.skins);
      }
      
      public function get indexedColors() : Object
      {
         return secure(_target.indexedColors);
      }
      
      public function get scales() : Object
      {
         return secure(_target.scales);
      }
      
      public function get subentities() : Object
      {
         return secure(_target.subentities);
      }
   }
}
