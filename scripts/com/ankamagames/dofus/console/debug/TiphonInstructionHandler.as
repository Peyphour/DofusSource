package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.Dictionary;
   
   public class TiphonInstructionHandler implements ConsoleInstructionHandler
   {
      
      private static var _monsters:Dictionary;
      
      private static var _monsterNameList:Array;
       
      
      public function TiphonInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:TiphonEntityLook = null;
         var _loc7_:AdminQuietCommandMessage = null;
         var _loc8_:IEntity = null;
         switch(param2)
         {
            case "additem":
               if(param3.length != 0)
               {
                  param1.output("need 1 parameter (item ID)");
               }
               (DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as TiphonSprite).look.addSkin(parseInt(param3[0]));
               break;
            case "looklike":
               if(!_monsters)
               {
                  this.parseMonster();
               }
               _loc4_ = param3.join(" ").toLowerCase().split(" {npc}").join("").split(" {monster}").join("");
               if(_monsters[_loc4_])
               {
                  param1.output("look like " + _monsters[_loc4_]);
                  _loc7_ = new AdminQuietCommandMessage();
                  _loc7_.initAdminQuietCommandMessage("look * " + _monsters[_loc4_]);
                  if(PlayerManager.getInstance().hasRights)
                  {
                     ConnectionsHandler.getConnection().send(_loc7_);
                  }
               }
               break;
            case "relook":
               if(param3.length != 2)
               {
                  param1.output("need 2 parameters : target bones ID and new look");
               }
               _loc5_ = parseInt(param3[0]);
               _loc6_ = TiphonEntityLook.fromString(param3[1]);
               for each(_loc8_ in EntitiesManager.getInstance().entities)
               {
                  if(_loc8_ is TiphonSprite && TiphonSprite(_loc8_).look.getBone() == _loc5_)
                  {
                     TiphonSprite(_loc8_).look.updateFrom(_loc6_);
                  }
               }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "looklike":
               return "look a npc or monster, param is monser\'s or pnc\'s name, you can use autocompletion";
            case "relook":
               return "Change the look of all entities currently displayed that have a specific boneId";
            default:
               return null;
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:IEntity = null;
         var _loc4_:Array = [];
         switch(param1)
         {
            case "looklike":
               if(!_monsters)
               {
                  this.parseMonster();
               }
               _loc5_ = param3.join(" ").toLowerCase();
               for each(_loc6_ in _monsterNameList)
               {
                  if(_loc6_.indexOf(_loc5_) != -1)
                  {
                     _loc4_.push(_loc6_);
                  }
               }
               break;
            case "relook":
               for each(_loc7_ in EntitiesManager.getInstance().entities)
               {
                  if(_loc7_ is TiphonSprite && _loc4_.indexOf(TiphonSprite(_loc7_).look.getBone()) == -1)
                  {
                     _loc4_.push(TiphonSprite(_loc7_).look.getBone());
                  }
               }
         }
         return _loc4_;
      }
      
      private function parseMonster() : void
      {
         var _loc2_:Monster = null;
         var _loc3_:Npc = null;
         _monsters = new Dictionary();
         _monsterNameList = [];
         var _loc1_:Array = Monster.getMonsters();
         for each(_loc2_ in _loc1_)
         {
            _monsterNameList.push(_loc2_.name.toLowerCase() + " {monster}");
            _monsters[_loc2_.name.toLowerCase()] = _loc2_.look;
         }
         _loc1_ = Npc.getNpcs();
         for each(_loc3_ in _loc1_)
         {
            _monsterNameList.push(_loc3_.name.toLowerCase() + " {npc}");
            _monsters[_loc3_.name.toLowerCase()] = _loc3_.look;
         }
      }
   }
}
