package d2network
{
   import utils.ReadOnlyData;
   
   public class PresetItem extends ReadOnlyData
   {
       
      
      public function PresetItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get position() : uint
      {
         return _target.position;
      }
      
      public function get objGid() : uint
      {
         return _target.objGid;
      }
      
      public function get objUid() : uint
      {
         return _target.objUid;
      }
   }
}
