package d2network
{
   import utils.ReadOnlyData;
   
   public class RemodelingInformation extends ReadOnlyData
   {
       
      
      public function RemodelingInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get cosmeticId() : uint
      {
         return _target.cosmeticId;
      }
      
      public function get colors() : Object
      {
         return secure(_target.colors);
      }
   }
}
