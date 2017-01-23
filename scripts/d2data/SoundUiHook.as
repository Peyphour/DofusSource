package d2data
{
   import utils.ReadOnlyData;
   
   public class SoundUiHook extends ReadOnlyData
   {
       
      
      public function SoundUiHook(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
   }
}
