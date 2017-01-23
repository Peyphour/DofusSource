package d2data
{
   import utils.ReadOnlyData;
   
   public class EffectInstance extends ReadOnlyData
   {
       
      
      public function EffectInstance(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get effectUid() : uint
      {
         return _target.effectUid;
      }
      
      public function get effectId() : uint
      {
         return _target.effectId;
      }
      
      public function get targetId() : int
      {
         return _target.targetId;
      }
      
      public function get targetMask() : String
      {
         return _target.targetMask;
      }
      
      public function get duration() : int
      {
         return _target.duration;
      }
      
      public function get delay() : int
      {
         return _target.delay;
      }
      
      public function get random() : int
      {
         return _target.random;
      }
      
      public function get group() : int
      {
         return _target.group;
      }
      
      public function get modificator() : int
      {
         return _target.modificator;
      }
      
      public function get trigger() : Boolean
      {
         return _target.trigger;
      }
      
      public function get triggers() : String
      {
         return _target.triggers;
      }
      
      public function get visibleInTooltip() : Boolean
      {
         return _target.visibleInTooltip;
      }
      
      public function get visibleInBuffUi() : Boolean
      {
         return _target.visibleInBuffUi;
      }
      
      public function get visibleInFightLog() : Boolean
      {
         return _target.visibleInFightLog;
      }
      
      public function get zoneSize() : Object
      {
         return secure(_target.zoneSize);
      }
      
      public function get zoneShape() : uint
      {
         return _target.zoneShape;
      }
      
      public function get zoneMinSize() : Object
      {
         return secure(_target.zoneMinSize);
      }
      
      public function get zoneEfficiencyPercent() : Object
      {
         return secure(_target.zoneEfficiencyPercent);
      }
      
      public function get zoneMaxEfficiency() : Object
      {
         return secure(_target.zoneMaxEfficiency);
      }
      
      public function get zoneStopAtTarget() : Object
      {
         return secure(_target.zoneStopAtTarget);
      }
      
      public function get effectElement() : int
      {
         return _target.effectElement;
      }
   }
}
