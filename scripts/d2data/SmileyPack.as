package d2data
{
   import utils.ReadOnlyData;
   
   public class SmileyPack extends ReadOnlyData
   {
       
      
      public function SmileyPack(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get smileys() : Object
      {
         return secure(_target.smileys);
      }
   }
}
