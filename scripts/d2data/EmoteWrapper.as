package d2data
{
   import utils.ReadOnlyData;
   
   public class EmoteWrapper extends ReadOnlyData
   {
       
      
      public function EmoteWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get position() : uint
      {
         return _target.position;
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get gfxId() : int
      {
         return _target.gfxId;
      }
      
      public function get isOkForMultiUse() : Boolean
      {
         return _target.isOkForMultiUse;
      }
      
      public function get quantity() : uint
      {
         return _target.quantity;
      }
   }
}
