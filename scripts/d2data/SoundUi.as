package d2data
{
   import utils.ReadOnlyData;
   
   public class SoundUi extends ReadOnlyData
   {
       
      
      public function SoundUi(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get uiName() : String
      {
         return _target.uiName;
      }
      
      public function get openFile() : String
      {
         return _target.openFile;
      }
      
      public function get closeFile() : String
      {
         return _target.closeFile;
      }
      
      public function get subElements() : Object
      {
         return secure(_target.subElements);
      }
   }
}
