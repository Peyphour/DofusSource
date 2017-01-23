package
{
   import d2actions.*;
   import d2enums.FightEventEnum;
   import flash.utils.Dictionary;
   
   public class FightTexts
   {
      
      public static var cacheFighterName:Dictionary = new Dictionary();
      
      public static var cacheSpellName:Dictionary = new Dictionary();
      
      private static var _targets:Vector.<Number>;
      
      private static var _targetsTeam:String;
      
      private static var _logBuffer:String = "";
       
      
      public function FightTexts()
      {
         super();
      }
      
      public static function writeLog() : void
      {
      }
      
      private static function getSpellName(param1:Number, param2:int, param3:int, param4:uint, param5:uint) : String
      {
         var _loc6_:String = cacheSpellName[param4];
         if(!_loc6_)
         {
            _loc6_ = Api.dataApi.getSpell(param4).name;
            cacheSpellName[param4] = _loc6_;
         }
         var _loc7_:String = "event:spellEffectArea," + param1 + "," + param2 + "," + param3 + "," + param4 + "," + param5;
         _loc6_ = Api.chatApi.addHtmlLink(_loc6_,_loc7_);
         return _loc6_;
      }
      
      private static function getFighterName(param1:Number) : String
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc2_:* = "";
         if(_targetsTeam != "" || _targets.length > 0 && _targets.indexOf(param1) != -1)
         {
            _loc3_ = !!_targetsTeam?_targetsTeam.split(","):[" "];
            for each(_loc4_ in _loc3_)
            {
               if(_loc2_ != "")
               {
                  _loc2_ = _loc2_ + ", ";
               }
               switch(_loc4_)
               {
                  case "allies":
                     if(Api.fightApi.isSpectator())
                     {
                        _loc2_ = _loc2_ + Api.uiApi.getText("ui.common.attackers");
                     }
                     else
                     {
                        _loc2_ = _loc2_ + Api.uiApi.getText("ui.common.allies");
                     }
                     continue;
                  case "enemies":
                     if(Api.fightApi.isSpectator())
                     {
                        _loc2_ = _loc2_ + Api.uiApi.getText("ui.common.defenders");
                     }
                     else
                     {
                        _loc2_ = _loc2_ + Api.uiApi.getText("ui.common.enemies");
                     }
                     continue;
                  case "all":
                     _loc2_ = _loc2_ + Api.uiApi.getText("ui.common.everyone");
                     continue;
                  default:
                     _loc6_ = "";
                     for each(_loc5_ in _targets)
                     {
                        _loc6_ = _loc6_ + ((_loc6_ != ""?", ":"") + getFighterCacheName(_loc5_));
                     }
                     _loc2_ = _loc2_ + _loc6_;
                     continue;
               }
            }
         }
         else
         {
            _loc2_ = getFighterCacheName(param1);
         }
         return _loc2_;
      }
      
      private static function getFighterCacheName(param1:Number) : String
      {
         var _loc2_:String = cacheFighterName[param1];
         if(!_loc2_)
         {
            if(param1 > 0)
            {
               _loc2_ = Api.chatApi.addHtmlLink(Api.fightApi.getFighterName(param1),"event:entity," + param1 + ",1");
            }
            else if(param1 < 0)
            {
               _loc2_ = Api.chatApi.addHtmlLink(Api.fightApi.getFighterName(param1),"event:monsterFight," + param1);
            }
            cacheFighterName[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public static function event(param1:String, param2:Object, param3:Object = null, param4:String = "") : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc11_:Array = null;
         _targets = new Vector.<Number>();
         if(param3 != null)
         {
            for each(_loc6_ in param3)
            {
               if(_targets.indexOf(_loc6_) == -1)
               {
                  _targets.push(_loc6_);
               }
            }
         }
         _targetsTeam = param4;
         var _loc5_:String = "";
         switch(param1)
         {
            case FightEventEnum.FIGHTER_LIFE_LOSS_AND_DEATH:
               _loc5_ = Api.uiApi.getText("ui.fight.lifeLossAndDeath",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_LIFE_LOSS:
               _loc5_ = Api.uiApi.getText("ui.fight.lifeLoss",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_LIFE_GAIN:
               _loc5_ = Api.uiApi.getText("ui.fight.lifeGain",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_NO_CHANGE:
               _loc5_ = Api.uiApi.getText("ui.fight.noChange",getFighterName(param2[0]));
               break;
            case FightEventEnum.FIGHT_END:
               _loc5_ = Api.uiApi.getText("ui.fight.fightEnd");
               break;
            case FightEventEnum.FIGHTER_DEATH:
               _loc5_ = Api.uiApi.getText("ui.fight.isDead",!!_targetsTeam?getFighterName(param2[0]):param2[1]);
               _loc5_ = Api.uiApi.processText(_loc5_,"n",true);
               break;
            case FightEventEnum.FIGHTER_LEAVE:
               _loc5_ = Api.uiApi.getText("ui.fight.leave",getFighterName(param2[0]));
               break;
            case FightEventEnum.FIGHTER_CHANGE_LOOK:
               break;
            case FightEventEnum.FIGHTER_GOT_DISPELLED:
               _loc5_ = Api.uiApi.getText("ui.fight.dispell",getFighterName(param2[0]));
               break;
            case FightEventEnum.FIGHTER_SPELL_DISPELLED:
               _loc5_ = Api.uiApi.getText("ui.fight.dispellSpell",getFighterName(param2[0]),Api.dataApi.getSpell(param2[1]).name);
               break;
            case FightEventEnum.FIGHTER_EFFECTS_MODIFY_DURATION:
               _loc5_ = Api.uiApi.getText("ui.fight.effectsModifyDuration",getFighterName(param2[1]),param2[2]);
               break;
            case FightEventEnum.FIGHTER_SPELL_COOLDOWN_VARIATION:
               _loc7_ = param2[2] < 0?param2[2]:"+" + param2[2];
               _loc5_ = Api.uiApi.getText("ui.fight.cooldownVariation",getFighterName(param2[0]),Api.dataApi.getSpell(param2[1]).name,_loc7_);
               break;
            case FightEventEnum.FIGHTER_SPELL_IMMUNITY:
               _loc5_ = Api.uiApi.getText("ui.fight.noChange",getFighterName(param2[0]));
               break;
            case FightEventEnum.FIGHTER_AP_LOSS_DODGED:
               _loc5_ = Api.uiApi.getText("ui.fight.dodgeAP",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_MP_LOSS_DODGED:
               _loc5_ = Api.uiApi.getText("ui.fight.dodgeMP",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTERS_POSITION_EXCHANGE:
               break;
            case FightEventEnum.FIGHTER_VISIBILITY_CHANGED:
               switch(param2[1])
               {
                  case 1:
                     _loc5_ = Api.uiApi.getText("ui.fight.invisibility",getFighterName(param2[0]));
                     break;
                  case 2:
                  case 3:
                     _loc5_ = Api.uiApi.getText("ui.fight.visibility",getFighterName(param2[0]));
               }
               break;
            case FightEventEnum.FIGHTER_GOT_KILLED:
               if(param2[0] != param2[1])
               {
                  _loc5_ = Api.uiApi.getText("ui.fight.killed",getFighterCacheName(param2[0]),getFighterName(param2[1]));
               }
               break;
            case FightEventEnum.FIGHTER_TEMPORARY_BOOSTED:
               _loc8_ = int(param2[2]);
               _loc9_ = param2[1];
               if(_loc8_)
               {
                  _loc9_ = _loc9_ + " (" + param2[3] + ")";
               }
               _loc5_ = Api.uiApi.getText("ui.fight.effect",getFighterName(param2[0]),_loc9_);
               break;
            case FightEventEnum.FIGHTER_AP_USED:
               break;
            case FightEventEnum.FIGHTER_AP_LOST:
               _loc5_ = Api.uiApi.getText("ui.fight.lostAP",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_AP_GAINED:
               _loc5_ = Api.uiApi.getText("ui.fight.winAP",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_MP_USED:
               break;
            case FightEventEnum.FIGHTER_MP_LOST:
               _loc5_ = Api.uiApi.getText("ui.fight.lostMP",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_MP_GAINED:
               _loc5_ = Api.uiApi.getText("ui.fight.winMP",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_SHIELD_LOSS:
               _loc5_ = Api.uiApi.getText("ui.fight.lostShieldPoints",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_REDUCED_DAMAGES:
               _loc5_ = Api.uiApi.getText("ui.fight.reduceDamages",getFighterName(param2[0]),param2[1]);
               break;
            case FightEventEnum.FIGHTER_REFLECTED_DAMAGES:
               _loc5_ = Api.uiApi.getText("ui.fight.reflectDamages",getFighterName(param2[0]));
               break;
            case FightEventEnum.FIGHTER_REFLECTED_SPELL:
               _loc5_ = Api.uiApi.getText("ui.fight.reflectSpell",getFighterName(param2[0]));
               break;
            case FightEventEnum.FIGHTER_SLIDE:
               break;
            case FightEventEnum.FIGHTER_CASTED_SPELL:
               _loc5_ = Api.uiApi.getText("ui.fight.launchSpell",getFighterName(param2[0]),getSpellName(param2[0],param2[1],param2[2],param2[3],param2[4]));
               if(param2[5] == 2)
               {
                  _loc5_ = _loc5_ + (" " + Api.uiApi.getText("ui.fight.criticalHit"));
               }
               else if(param2[5] == 3)
               {
                  _loc5_ = _loc5_ + (" " + Api.uiApi.getText("ui.fight.criticalMiss"));
               }
               break;
            case FightEventEnum.FIGHTER_CLOSE_COMBAT:
               _loc5_ = Api.uiApi.getText("ui.fight.closeCombat",getFighterName(param2[0]),Api.dataApi.getItem(param2[1]).name);
               if(param2[2] == 2)
               {
                  _loc5_ = _loc5_ + (" " + Api.uiApi.getText("ui.fight.criticalHit"));
               }
               else if(param2[2] == 3)
               {
                  _loc5_ = _loc5_ + (" " + Api.uiApi.getText("ui.fight.criticalMiss"));
               }
               break;
            case FightEventEnum.FIGHTER_DID_CRITICAL_HIT:
               break;
            case FightEventEnum.FIGHTER_ENTERING_STATE:
               _loc10_ = "";
               if(param2.length == 3 && param2[2])
               {
                  _loc10_ = "</b> (" + param2[2] + ")<b>";
               }
               _loc5_ = Api.uiApi.getText("ui.fight.enterState",getFighterName(param2[0]),Api.dataApi.getSpellState(param2[1]).name + _loc10_);
               break;
            case FightEventEnum.FIGHTER_LEAVING_STATE:
               _loc5_ = Api.uiApi.getText("ui.fight.exitState",getFighterName(param2[0]),Api.dataApi.getSpellState(param2[1]).name);
               break;
            case FightEventEnum.FIGHTER_STEALING_KAMAS:
               _loc5_ = Api.uiApi.getText("ui.fight.stealMoney",getFighterCacheName(param2[0]),param2[2],getFighterName(param2[1]));
               _loc5_ = Api.uiApi.processText(_loc5_,"n",param2[2] <= 1);
               break;
            case FightEventEnum.FIGHTER_SUMMONED:
               break;
            case FightEventEnum.FIGHTER_GOT_TACKLED:
               _loc5_ = Api.uiApi.getText("ui.fight.dodgeFailed");
               if(param2.length > 1)
               {
                  _loc11_ = new Array();
                  if(param2[1] && param2[1] != 0)
                  {
                     _loc11_.push("-" + param2[1] + " " + Api.uiApi.getText("ui.common.ap"));
                  }
                  if(param2[2] && param2[2] != 0)
                  {
                     _loc11_.push("-" + param2[2] + " " + Api.uiApi.getText("ui.common.mp"));
                  }
                  _loc5_ = _loc5_ + (" (" + _loc11_.join(",") + ")");
               }
               break;
            case FightEventEnum.FIGHTER_TELEPORTED:
               break;
            case FightEventEnum.FIGHTER_TRIGGERED_GLYPH:
               _loc5_ = Api.uiApi.getText("ui.fight.startTrap",getFighterName(param2[0]),Api.dataApi.getSpell(param2[2]).name,getFighterName(param2[1]));
               break;
            case FightEventEnum.FIGHTER_TRIGGERED_TRAP:
               _loc5_ = Api.uiApi.getText("ui.fight.startTrap",getFighterName(param2[0]),Api.dataApi.getSpell(param2[2]).name,getFighterName(param2[1]));
               break;
            case FightEventEnum.FIGHTER_TRIGGERED_PORTAL:
               break;
            case FightEventEnum.GLYPH_APPEARED:
               break;
            case FightEventEnum.GLYPH_DISAPPEARED:
               break;
            case FightEventEnum.TRAP_APPEARED:
               break;
            case FightEventEnum.TRAP_DISAPPEARED:
               break;
            case FightEventEnum.PORTAL_APPEARED:
               break;
            case FightEventEnum.PORTAL_DISAPPEARED:
               break;
            case FightEventEnum.FIGHTER_CARRY:
               break;
            case FightEventEnum.FIGHTER_THROW:
               break;
            default:
               Api.sysApi.log(16,"Unknown fight event " + param1 + " received.");
               return;
         }
         if(_loc5_ && _loc5_.length > 0)
         {
            Api.sysApi.sendAction(new FightOutput(_loc5_,11));
         }
      }
   }
}
