package d2data
{
   import utils.ReadOnlyData;
   
   public class SpellState extends ReadOnlyData
   {
       
      
      public function SpellState(param1:*, param2:Object)
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
      
      public function get preventsSpellCast() : Boolean
      {
         return _target.preventsSpellCast;
      }
      
      public function get preventsFight() : Boolean
      {
         return _target.preventsFight;
      }
      
      public function get isSilent() : Boolean
      {
         return _target.isSilent;
      }
      
      public function get cantDealDamage() : Boolean
      {
         return _target.cantDealDamage;
      }
      
      public function get invulnerable() : Boolean
      {
         return _target.invulnerable;
      }
      
      public function get incurable() : Boolean
      {
         return _target.incurable;
      }
      
      public function get cantBeMoved() : Boolean
      {
         return _target.cantBeMoved;
      }
      
      public function get cantBePushed() : Boolean
      {
         return _target.cantBePushed;
      }
      
      public function get cantSwitchPosition() : Boolean
      {
         return _target.cantSwitchPosition;
      }
      
      public function get effectsIds() : Object
      {
         return secure(_target.effectsIds);
      }
      
      public function get icon() : String
      {
         return _target.icon;
      }
      
      public function get iconVisibilityMask() : int
      {
         return _target.iconVisibilityMask;
      }
      
      public function get invulnerableMelee() : Boolean
      {
         return _target.invulnerableMelee;
      }
      
      public function get invulnerableRange() : Boolean
      {
         return _target.invulnerableRange;
      }
   }
}
