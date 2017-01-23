package d2data
{
   public class PresetWrapper extends ItemWrapper
   {
       
      
      public function PresetWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get gfxId() : int
      {
         return _target.gfxId;
      }
      
      public function get _objects() : Object
      {
         return secure(_target._objects);
      }
      
      public function get mount() : Boolean
      {
         return _target.mount;
      }
   }
}
