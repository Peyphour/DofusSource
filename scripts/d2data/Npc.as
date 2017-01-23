package d2data
{
   import utils.ReadOnlyData;
   
   public class Npc extends ReadOnlyData
   {
       
      
      public function Npc(param1:*, param2:Object)
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
      
      public function get dialogMessages() : Object
      {
         return secure(_target.dialogMessages);
      }
      
      public function get dialogReplies() : Object
      {
         return secure(_target.dialogReplies);
      }
      
      public function get actions() : Object
      {
         return secure(_target.actions);
      }
      
      public function get gender() : uint
      {
         return _target.gender;
      }
      
      public function get look() : String
      {
         return _target.look;
      }
      
      public function get tokenShop() : int
      {
         return _target.tokenShop;
      }
      
      public function get animFunList() : Object
      {
         return secure(_target.animFunList);
      }
      
      public function get fastAnimsFun() : Boolean
      {
         return _target.fastAnimsFun;
      }
   }
}
