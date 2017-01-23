package d2data
{
   import utils.ReadOnlyData;
   
   public class Smiley extends ReadOnlyData
   {
       
      
      public function Smiley(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get gfxId() : String
      {
         return _target.gfxId;
      }
      
      public function get forPlayers() : Boolean
      {
         return _target.forPlayers;
      }
      
      public function get triggers() : Object
      {
         return secure(_target.triggers);
      }
      
      public function get referenceId() : uint
      {
         return _target.referenceId;
      }
      
      public function get categoryId() : uint
      {
         return _target.categoryId;
      }
   }
}
