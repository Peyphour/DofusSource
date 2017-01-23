package d2data
{
   import utils.ReadOnlyData;
   
   public class SoundUiElement extends ReadOnlyData
   {
       
      
      public function SoundUiElement(param1:*, param2:Object)
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
      
      public function get hookId() : uint
      {
         return _target.hookId;
      }
      
      public function get file() : String
      {
         return _target.file;
      }
      
      public function get volume() : uint
      {
         return _target.volume;
      }
   }
}
