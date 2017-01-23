package d2data
{
   import utils.ReadOnlyData;
   
   public class SpellWrapper extends ReadOnlyData
   {
       
      
      public function SpellWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get spellLevel() : int
      {
         return _target.spellLevel;
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get criticalEffect() : Object
      {
         return secure(_target.criticalEffect);
      }
      
      public function get gfxId() : int
      {
         return _target.gfxId;
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get versionNum() : int
      {
         return _target.versionNum;
      }
   }
}
