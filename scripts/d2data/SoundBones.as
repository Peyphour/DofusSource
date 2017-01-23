package d2data
{
   import utils.ReadOnlyData;
   
   public class SoundBones extends ReadOnlyData
   {
       
      
      public function SoundBones(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get keys() : Object
      {
         return secure(_target.keys);
      }
      
      public function get values() : Object
      {
         return secure(_target.values);
      }
   }
}
