package d2network
{
   import utils.ReadOnlyData;
   
   public class Preset extends ReadOnlyData
   {
       
      
      public function Preset(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get presetId() : uint
      {
         return _target.presetId;
      }
      
      public function get symbolId() : uint
      {
         return _target.symbolId;
      }
      
      public function get mount() : Boolean
      {
         return _target.mount;
      }
      
      public function get objects() : Object
      {
         return secure(_target.objects);
      }
   }
}
