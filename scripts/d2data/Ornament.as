package d2data
{
   import utils.ReadOnlyData;
   
   public class Ornament extends ReadOnlyData
   {
       
      
      public function Ornament(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get visible() : Boolean
      {
         return _target.visible;
      }
      
      public function get assetId() : int
      {
         return _target.assetId;
      }
      
      public function get iconId() : int
      {
         return _target.iconId;
      }
      
      public function get rarity() : int
      {
         return _target.rarity;
      }
      
      public function get order() : int
      {
         return _target.order;
      }
   }
}
