package d2network
{
   import utils.ReadOnlyData;
   
   public class IdolsPreset extends ReadOnlyData
   {
       
      
      public function IdolsPreset(param1:*, param2:Object)
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
      
      public function get idolId() : Object
      {
         return secure(_target.idolId);
      }
   }
}
