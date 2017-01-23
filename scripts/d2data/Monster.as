package d2data
{
   import utils.ReadOnlyData;
   
   public class Monster extends ReadOnlyData
   {
       
      
      public function Monster(param1:*, param2:Object)
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
      
      public function get gfxId() : uint
      {
         return _target.gfxId;
      }
      
      public function get race() : int
      {
         return _target.race;
      }
      
      public function get grades() : Object
      {
         return secure(_target.grades);
      }
      
      public function get look() : String
      {
         return _target.look;
      }
      
      public function get useSummonSlot() : Boolean
      {
         return _target.useSummonSlot;
      }
      
      public function get useBombSlot() : Boolean
      {
         return _target.useBombSlot;
      }
      
      public function get canPlay() : Boolean
      {
         return _target.canPlay;
      }
      
      public function get canTackle() : Boolean
      {
         return _target.canTackle;
      }
      
      public function get animFunList() : Object
      {
         return secure(_target.animFunList);
      }
      
      public function get isBoss() : Boolean
      {
         return _target.isBoss;
      }
      
      public function get drops() : Object
      {
         return secure(_target.drops);
      }
      
      public function get subareas() : Object
      {
         return secure(_target.subareas);
      }
      
      public function get spells() : Object
      {
         return secure(_target.spells);
      }
      
      public function get favoriteSubareaId() : int
      {
         return _target.favoriteSubareaId;
      }
      
      public function get isMiniBoss() : Boolean
      {
         return _target.isMiniBoss;
      }
      
      public function get isQuestMonster() : Boolean
      {
         return _target.isQuestMonster;
      }
      
      public function get correspondingMiniBossId() : uint
      {
         return _target.correspondingMiniBossId;
      }
      
      public function get speedAdjust() : Number
      {
         return _target.speedAdjust;
      }
      
      public function get creatureBoneId() : int
      {
         return _target.creatureBoneId;
      }
      
      public function get canBePushed() : Boolean
      {
         return _target.canBePushed;
      }
      
      public function get fastAnimsFun() : Boolean
      {
         return _target.fastAnimsFun;
      }
      
      public function get canSwitchPos() : Boolean
      {
         return _target.canSwitchPos;
      }
      
      public function get incompatibleIdols() : Object
      {
         return secure(_target.incompatibleIdols);
      }
      
      public function get allIdolsDisabled() : Boolean
      {
         return _target.allIdolsDisabled;
      }
      
      public function get dareAvailable() : Boolean
      {
         return _target.dareAvailable;
      }
      
      public function get incompatibleChallenges() : Object
      {
         return secure(_target.incompatibleChallenges);
      }
   }
}
