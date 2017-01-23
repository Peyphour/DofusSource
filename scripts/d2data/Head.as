package d2data
{
   import utils.ReadOnlyData;
   
   public class Head extends ReadOnlyData
   {
       
      
      public function Head(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get skins() : String
      {
         return _target.skins;
      }
      
      public function get assetId() : String
      {
         return _target.assetId;
      }
      
      public function get breed() : uint
      {
         return _target.breed;
      }
      
      public function get gender() : uint
      {
         return _target.gender;
      }
      
      public function get label() : String
      {
         return _target.label;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
   }
}
