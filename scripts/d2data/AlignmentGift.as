package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentGift extends ReadOnlyData
   {
       
      
      public function AlignmentGift(param1:*, param2:Object)
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
      
      public function get effectId() : int
      {
         return _target.effectId;
      }
      
      public function get gfxId() : uint
      {
         return _target.gfxId;
      }
   }
}
