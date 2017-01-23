package d2network
{
   import utils.ReadOnlyData;
   
   public class AbstractFightDispellableEffect extends ReadOnlyData
   {
       
      
      public function AbstractFightDispellableEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get uid() : uint
      {
         return _target.uid;
      }
      
      public function get targetId() : Number
      {
         return _target.targetId;
      }
      
      public function get turnDuration() : int
      {
         return _target.turnDuration;
      }
      
      public function get dispelable() : uint
      {
         return _target.dispelable;
      }
      
      public function get spellId() : uint
      {
         return _target.spellId;
      }
      
      public function get effectId() : uint
      {
         return _target.effectId;
      }
      
      public function get parentBoostUid() : uint
      {
         return _target.parentBoostUid;
      }
   }
}
