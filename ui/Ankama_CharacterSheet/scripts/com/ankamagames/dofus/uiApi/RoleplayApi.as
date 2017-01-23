package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.almanax.AlmanaxCalendar;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   
   public class RoleplayApi
   {
       
      
      public function RoleplayApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getTotalFightOnCurrentMap() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getSpellToForgetList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getEmotesList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getUsableEmotesList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSpawnMap() : uint
      {
         return 0;
      }
      
      [Trusted]
      public function getEntitiesOnCell(param1:int) : Array
      {
         return null;
      }
      
      [Trusted]
      public function getPlayersIdOnCurrentMap() : Array
      {
         return null;
      }
      
      [Trusted]
      public function getPlayerIsInCurrentMap(param1:Number) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function isUsingInteractive() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getFight(param1:int) : Object
      {
         return null;
      }
      
      [Trusted]
      public function putEntityOnTop(param1:Object) : void
      {
      }
      
      [Trusted]
      public function playGfx(param1:uint, param2:uint) : void
      {
      }
      
      [Untrusted]
      public function getEntityInfos(param1:Object) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getEntityByName(param1:String) : Object
      {
         return null;
      }
      
      [Trusted]
      public function switchButtonWrappers(param1:Object, param2:Object) : void
      {
      }
      
      [Trusted]
      public function setButtonWrapperActivation(param1:Object, param2:Boolean, param3:String = "") : void
      {
      }
      
      [Trusted]
      public function playEntityAnimation(param1:int, param2:String) : void
      {
      }
      
      [Trusted]
      public function playSpellAnimation(param1:int, param2:int, param3:int) : void
      {
      }
      
      [Untrusted]
      public function showNpcBubble(param1:int, param2:String) : void
      {
      }
      
      [Untrusted]
      public function getMonsterXpBoostMultiplier(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getMonsterDropBoostMultiplier(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getRaceXpBoostMultiplier(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getRaceDropBoostMultiplier(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getMonsterGroupString(param1:*) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterGroupFromString(param1:String) : GameRolePlayGroupMonsterInformations
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxCalendar() : AlmanaxCalendar
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxMonsterXpBonusMultiplier(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlmanaxMonsterDropChanceBonusMultiplier(param1:int) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlmanaxMonsterStarRateBonus() : int
      {
         return 0;
      }
   }
}
