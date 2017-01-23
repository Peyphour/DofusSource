package d2data
{
   import utils.ReadOnlyData;
   
   public class Title extends ReadOnlyData
   {
       
      
      public function Title(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameMaleId() : uint
      {
         return _target.nameMaleId;
      }
      
      public function get nameFemaleId() : uint
      {
         return _target.nameFemaleId;
      }
      
      public function get visible() : Boolean
      {
         return _target.visible;
      }
      
      public function get categoryId() : int
      {
         return _target.categoryId;
      }
   }
}
