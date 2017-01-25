package com.ankamagames.dofus.logic.game.fight.fightEvents
{
   import com.ankamagames.berilia.managers.HtmlManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.misc.TypeAction;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FightEventsHelper
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightEventsHelper));
      
      private static var _fightEvents:Vector.<FightEvent> = new Vector.<FightEvent>();
      
      private static var _events:Vector.<Vector.<FightEvent>> = new Vector.<Vector.<FightEvent>>();
      
      private static var _joinedEvents:Vector.<FightEvent>;
      
      private static var sysApi:SystemApi = new SystemApi();
      
      public static var _detailsActive:Boolean;
      
      private static var _lastSpellId:int;
      
      private static const NOT_GROUPABLE_BY_TYPE_EVENTS:Array = [FightEventEnum.FIGHTER_CASTED_SPELL];
      
      private static const SKIP_ENTITY_ALIVE_CHECK_EVENTS:Array = [FightEventEnum.FIGHTER_GOT_KILLED,FightEventEnum.FIGHTER_DEATH];
       
      
      public function FightEventsHelper()
      {
         super();
      }
      
      public static function reset() : void
      {
         _fightEvents = new Vector.<FightEvent>();
         _events = new Vector.<Vector.<FightEvent>>();
         _joinedEvents = new Vector.<FightEvent>();
         _lastSpellId = -1;
      }
      
      public static function sendFightEvent(param1:String, param2:Array, param3:Number, param4:int, param5:Boolean = false, param6:int = 0, param7:int = 1) : void
      {
         var _loc9_:FightEvent = null;
         var _loc10_:FightEvent = null;
         var _loc8_:FightEvent = new FightEvent(param1,param2,param3,param6,param4,_fightEvents.length,param7);
         if(param5)
         {
            KernelEventsManager.getInstance().processCallback(HookList.FightEvent,_loc8_.name,_loc8_.params,[_loc8_.targetId]);
            sendFightLogToChat(_loc8_);
         }
         else
         {
            if(param1)
            {
               _fightEvents.splice(0,0,_loc8_);
            }
            if(_joinedEvents && _joinedEvents.length > 0)
            {
               if(_joinedEvents[0].name == FightEventEnum.FIGHTER_GOT_TACKLED)
               {
                  if(param1 == FightEventEnum.FIGHTER_MP_LOST || param1 == FightEventEnum.FIGHTER_AP_LOST)
                  {
                     _joinedEvents.splice(0,0,_loc8_);
                     return;
                  }
                  if(param1 != FightEventEnum.FIGHTER_VISIBILITY_CHANGED)
                  {
                     _loc9_ = _joinedEvents.shift();
                     for each(_loc10_ in _joinedEvents)
                     {
                        if(_loc10_.name == FightEventEnum.FIGHTER_AP_LOST)
                        {
                           _loc9_.params[1] = _loc10_.params[1];
                        }
                        else
                        {
                           _loc9_.params[2] = _loc10_.params[1];
                        }
                     }
                     addFightText(_loc9_);
                     _joinedEvents = null;
                  }
               }
            }
            else if(param1 == FightEventEnum.FIGHTER_GOT_TACKLED)
            {
               _joinedEvents = new Vector.<FightEvent>();
               _joinedEvents.push(_loc8_);
               return;
            }
            if(param1)
            {
               addFightText(_loc8_);
            }
         }
      }
      
      private static function addFightText(param1:FightEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<FightEvent> = null;
         var _loc5_:Vector.<FightEvent> = null;
         var _loc6_:FightEvent = null;
         var _loc2_:int = _events.length;
         var _loc7_:Boolean = NOT_GROUPABLE_BY_TYPE_EVENTS.indexOf(param1.name) == -1?true:false;
         if(param1.name == FightEventEnum.FIGHTER_CASTED_SPELL)
         {
            _lastSpellId = param1.params[3];
         }
         if(param1.name == FightEventEnum.FIGHTER_LIFE_LOSS || param1.name == FightEventEnum.FIGHTER_LIFE_GAIN || param1.name == FightEventEnum.FIGHTER_SHIELD_LOSS)
         {
            param1.params.push(_lastSpellId);
         }
         if(param1.name == FightEventEnum.FIGHTER_LIFE_LOSS)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc6_ = _events[_loc3_][0];
               if(_loc6_.name == FightEventEnum.FIGHTER_REDUCED_DAMAGES && _loc6_.castingSpellId == param1.castingSpellId && _loc6_.targetId == param1.targetId)
               {
                  _loc7_ = false;
                  break;
               }
               _loc3_++;
            }
         }
         if(_loc7_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = _events[_loc3_];
               _loc6_ = _loc5_[0];
               if(_loc6_.name == param1.name && (_loc6_.castingSpellId == param1.castingSpellId || param1.castingSpellId == -1))
               {
                  if((_loc6_.name == FightEventEnum.FIGHTER_LIFE_LOSS || param1.name == FightEventEnum.FIGHTER_LIFE_GAIN || param1.name == FightEventEnum.FIGHTER_SHIELD_LOSS) && _loc6_.params[_loc6_.params.length - 1] != param1.params[param1.params.length - 1])
                  {
                     break;
                  }
                  _loc4_ = _loc5_;
                  break;
               }
               _loc3_++;
            }
         }
         if(_loc4_ == null)
         {
            _loc4_ = new Vector.<FightEvent>();
            _events.push(_loc4_);
         }
         _loc4_.push(param1);
      }
      
      public static function sendAllFightEvent(param1:Boolean = false) : void
      {
         if(param1)
         {
            sendEvents(null);
         }
         else
         {
            StageShareManager.stage.addEventListener(Event.ENTER_FRAME,sendEvents);
         }
      }
      
      private static function sendEvents(param1:Event = null) : void
      {
         StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,sendEvents);
         sendFightEvent(null,null,0,-1);
         sendAllFightEvents();
         var _loc2_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc3_:Dictionary = !!_loc2_?_loc2_.getEntitiesDictionnary():new Dictionary();
         _detailsActive = sysApi.getOption("showLogPvDetails","dofus");
         groupAllEventsForDisplay(_loc3_);
      }
      
      public static function groupAllEventsForDisplay(param1:Dictionary) : void
      {
         var _loc5_:Vector.<FightEvent> = null;
         var _loc6_:FightEvent = null;
         var _loc7_:FightEvent = null;
         var _loc8_:Vector.<FightEvent> = null;
         var _loc9_:Vector.<Number> = null;
         var _loc10_:* = null;
         var _loc11_:int = 0;
         var _loc12_:FightEvent = null;
         var _loc13_:Vector.<FightEvent> = null;
         var _loc2_:int = PlayedCharacterManager.getInstance().teamId;
         var _loc3_:Vector.<Number> = getTargetsWhoDiesAfterALifeLoss();
         var _loc4_:Dictionary = new Dictionary();
         while(_events.length > 0)
         {
            _loc5_ = _events[0];
            if(_loc5_ == null || _loc5_.length == 0)
            {
               _events.splice(0,1);
            }
            else
            {
               _loc6_ = _loc5_[0];
               _loc9_ = extractTargetsId(_loc5_);
               _loc4_ = groupFightEventsByTarget(_loc5_);
               for(_loc10_ in _loc4_)
               {
                  _loc6_ = _loc4_[_loc10_][0];
                  if(_loc4_[_loc10_].length > 1 && (_loc6_.name == FightEventEnum.FIGHTER_LIFE_LOSS || _loc6_.name == FightEventEnum.FIGHTER_LIFE_GAIN || _loc6_.name == FightEventEnum.FIGHTER_SHIELD_LOSS))
                  {
                     switch(_loc6_.name)
                     {
                        case FightEventEnum.FIGHTER_LIFE_LOSS:
                        case FightEventEnum.FIGHTER_SHIELD_LOSS:
                           _loc11_ = -1;
                           break;
                        case FightEventEnum.FIGHTER_LIFE_GAIN:
                        default:
                           _loc11_ = 1;
                     }
                     _loc7_ = groupByElements(_loc4_[_loc10_],_loc11_,_detailsActive,_loc3_.indexOf(_loc6_.targetId) != -1,_loc6_.castingSpellId);
                     if(!_loc8_)
                     {
                        _loc8_ = new Vector.<FightEvent>();
                     }
                     _loc8_.push(_loc7_);
                     for each(_loc12_ in _loc4_[_loc10_])
                     {
                        _loc5_.splice(_loc5_.indexOf(_loc12_),1);
                     }
                  }
                  else
                  {
                     _loc13_ = _loc5_.concat();
                     for each(_loc6_ in _loc13_)
                     {
                        if(_loc6_.name == FightEventEnum.FIGHTER_DEATH && _loc3_.indexOf(_loc6_.targetId) != -1)
                        {
                           _loc5_.splice(_loc5_.indexOf(_loc6_),1);
                        }
                     }
                     groupByTeam(_loc2_,_loc9_,_loc5_,param1,_loc3_);
                     _loc13_ = _loc5_.concat();
                     for each(_loc6_ in _loc13_)
                     {
                        sendFightLogToChat(_loc6_,"",null,_detailsActive,_loc6_.name == FightEventEnum.FIGHTER_LIFE_LOSS && _loc3_.indexOf(_loc6_.targetId) != -1);
                        _loc5_.splice(_loc5_.indexOf(_loc6_),1);
                     }
                     _loc13_ = null;
                  }
               }
               if(_loc8_ && _loc8_.length > 0)
               {
                  groupByTeam(_loc2_,_loc9_,_loc8_,param1,_loc3_,false);
                  if(_loc8_.length > 0)
                  {
                     for each(_loc7_ in _loc8_)
                     {
                        sendFightLogToChat(_loc7_,"",null,false,_loc7_.name == FightEventEnum.FIGHTER_LIFE_LOSS && _loc3_.indexOf(_loc7_.targetId) != -1);
                     }
                  }
                  _loc8_ = null;
               }
            }
         }
      }
      
      public static function extractTargetsId(param1:Vector.<FightEvent>) : Vector.<Number>
      {
         var _loc3_:FightEvent = null;
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         for each(_loc3_ in param1)
         {
            if(_loc2_.indexOf(_loc3_.targetId) == -1)
            {
               _loc2_.push(_loc3_.targetId);
            }
         }
         return _loc2_;
      }
      
      public static function extractGroupableTargets(param1:Vector.<FightEvent>) : Vector.<FightEvent>
      {
         var _loc4_:FightEvent = null;
         var _loc2_:FightEvent = param1[0];
         var _loc3_:Vector.<FightEvent> = new Vector.<FightEvent>();
         for each(_loc4_ in param1)
         {
            if(needToGroupFightEventsData(getNumberOfParametersToCheck(_loc2_),_loc4_,_loc2_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function groupFightEventsByTarget(param1:Vector.<FightEvent>) : Dictionary
      {
         var _loc3_:FightEvent = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            if(_loc2_[_loc3_.targetId.toString()] == null)
            {
               _loc2_[_loc3_.targetId.toString()] = new Array();
            }
            _loc2_[_loc3_.targetId.toString()].push(_loc3_);
         }
         return _loc2_;
      }
      
      public static function groupSameFightEvents(param1:Array, param2:FightEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:FightEvent = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_[0];
            if(needToGroupFightEventsData(getNumberOfParametersToCheck(_loc4_),param2,_loc4_))
            {
               _loc3_.push(param2);
               return;
            }
         }
         param1.push(new Array(param2));
      }
      
      public static function getTargetsWhoDiesAfterALifeLoss() : Vector.<Number>
      {
         var _loc3_:FightEvent = null;
         var _loc4_:Vector.<FightEvent> = null;
         var _loc1_:Vector.<Number> = new Vector.<Number>();
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         var _loc5_:Vector.<Vector.<FightEvent>> = _events.concat();
         for each(_loc4_ in _loc5_)
         {
            for each(_loc3_ in _loc4_)
            {
               if(_loc3_.name == FightEventEnum.FIGHTER_LIFE_LOSS)
               {
                  _loc1_.push(_loc3_.targetId);
               }
               else if(_loc3_.name == FightEventEnum.FIGHTER_DEATH && _loc1_.indexOf(_loc3_.targetId) != -1)
               {
                  _loc2_.push(_loc3_.targetId);
               }
            }
         }
         return _loc2_;
      }
      
      private static function groupByElements(param1:Array, param2:int, param3:Boolean = true, param4:Boolean = false, param5:int = -1) : FightEvent
      {
         var _loc9_:int = 0;
         var _loc10_:FightEvent = null;
         var _loc11_:String = null;
         var _loc13_:String = null;
         var _loc6_:String = "";
         var _loc7_:int = 0;
         var _loc8_:Boolean = true;
         for each(_loc10_ in param1)
         {
            if(!(param5 != -1 && param5 != _loc10_.castingSpellId))
            {
               if(_loc9_ && _loc10_.params[2] != _loc9_)
               {
                  _loc8_ = false;
               }
               _loc9_ = _loc10_.params[2];
               _loc7_ = _loc7_ + _loc10_.params[1];
               if(param2 == -1)
               {
                  _loc6_ = _loc6_ + (formateColorsForFightDamages(_loc10_.params[1],_loc10_.params[2]) + " + ");
               }
               else
               {
                  _loc6_ = _loc6_ + (_loc10_.params[1] + " + ");
               }
            }
         }
         _loc11_ = !!param4?"fightLifeLossAndDeath":param1[0].name;
         var _loc12_:Array = new Array();
         _loc12_[0] = param1[0].params[0];
         if(param2 == -1)
         {
            _loc13_ = formateColorsForFightDamages("-" + _loc7_.toString(),!!_loc8_?int(_loc9_):-1);
         }
         else
         {
            _loc13_ = _loc7_.toString();
         }
         if(param3 && param1.length > 1)
         {
            _loc13_ = _loc13_ + ("</b> (" + _loc6_.substr(0,_loc6_.length - 3) + ")<b>");
         }
         _loc12_[1] = _loc13_;
         return new FightEvent(_loc11_,_loc12_,_loc12_[0],2,param1[0].castingSpellId,param1.length,1);
      }
      
      private static function groupByTeam(param1:int, param2:Vector.<Number>, param3:Vector.<FightEvent>, param4:Dictionary, param5:Vector.<Number>, param6:Boolean = true) : Boolean
      {
         var _loc8_:FightEvent = null;
         var _loc9_:Vector.<Number> = null;
         var _loc10_:Vector.<FightEvent> = null;
         var _loc11_:FightEvent = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         if(param3.length == 0)
         {
            return false;
         }
         var _loc7_:Vector.<FightEvent> = param3.concat();
         while(_loc7_.length > 1)
         {
            _loc10_ = getGroupedListEvent(_loc7_);
            if(_loc10_.length <= 1)
            {
               continue;
            }
            _loc9_ = new Vector.<Number>();
            for each(_loc8_ in _loc10_)
            {
               _loc9_.push(_loc8_.targetId);
            }
            _loc11_ = _loc10_[0];
            _loc12_ = groupEntitiesByTeam(param1,_loc9_,param4,SKIP_ENTITY_ALIVE_CHECK_EVENTS.indexOf(param3[0].name) == -1);
            switch(_loc12_)
            {
               case "all":
               case "allies":
               case "enemies":
                  removeEventFromEventsList(param3,_loc10_);
                  if(_loc11_.name == "fighterLifeLoss" && param5.indexOf(_loc10_[0].targetId) != -1)
                  {
                     sendFightLogToChat(_loc11_,_loc12_,null,param6,true);
                  }
                  else
                  {
                     sendFightLogToChat(_loc11_,_loc12_,null,param6);
                  }
                  continue;
               case "other":
                  removeEventFromEventsList(param3,_loc10_);
                  if(_loc11_.name == "fighterLifeLoss" && param5.indexOf(_loc10_[0].targetId) != -1)
                  {
                     sendFightLogToChat(_loc11_,"",_loc9_,param6,true);
                  }
                  else
                  {
                     sendFightLogToChat(_loc11_,"",_loc9_,param6);
                  }
                  continue;
               case "none":
                  _log.warn("Failed to group FightEvents for the team \'none\'");
                  continue;
               default:
                  for each(_loc13_ in param4)
                  {
                     if(_loc12_.indexOf("allies") != -1 && _loc13_.teamId == param1 || _loc12_.indexOf("enemies") != -1 && _loc13_.teamId != param1)
                     {
                        _loc9_.splice(_loc9_.indexOf(_loc13_.contextualId),1);
                     }
                  }
                  removeEventFromEventsList(param3,_loc10_);
                  if(_loc11_.name == "fighterLifeLoss" && param5.indexOf(_loc10_[0].targetId) != -1)
                  {
                     sendFightLogToChat(_loc11_,_loc12_,_loc9_,param6,true);
                  }
                  else
                  {
                     sendFightLogToChat(_loc11_,_loc12_,_loc9_,param6);
                  }
                  continue;
            }
         }
         return false;
      }
      
      public static function getGroupedListEvent(param1:Vector.<FightEvent>) : Vector.<FightEvent>
      {
         var _loc4_:FightEvent = null;
         var _loc2_:FightEvent = param1[0];
         var _loc3_:Vector.<FightEvent> = new Vector.<FightEvent>();
         _loc3_.push(_loc2_);
         for each(_loc4_ in param1)
         {
            if(_loc3_.indexOf(_loc4_) == -1 && needToGroupFightEventsData(getNumberOfParametersToCheck(_loc2_),_loc4_,_loc2_))
            {
               _loc3_.push(_loc4_);
            }
         }
         removeEventFromEventsList(param1,_loc3_);
         return _loc3_;
      }
      
      public static function removeEventFromEventsList(param1:Vector.<FightEvent>, param2:Vector.<FightEvent>) : void
      {
         var _loc3_:FightEvent = null;
         for each(_loc3_ in param2)
         {
            param1.splice(param1.indexOf(_loc3_),1);
         }
      }
      
      public static function groupEntitiesByTeam(param1:int, param2:Vector.<Number>, param3:Dictionary, param4:Boolean = true) : String
      {
         var _loc9_:GameFightFighterInformations = null;
         var _loc10_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         for each(_loc9_ in param3)
         {
            if(_loc9_ != null)
            {
               if(_loc9_.teamId == param1)
               {
                  _loc7_++;
               }
               else
               {
                  _loc8_++;
               }
               if((!param4 || param4 && _loc9_.alive) && param2.indexOf(_loc9_.contextualId) != -1)
               {
                  if(_loc9_.teamId == param1)
                  {
                     _loc5_++;
                  }
                  else
                  {
                     _loc6_++;
                  }
               }
            }
         }
         _loc10_ = "";
         if(_loc7_ == _loc5_ && _loc8_ == _loc6_)
         {
            return "all";
         }
         if(_loc5_ > 1 && _loc5_ == _loc7_)
         {
            _loc10_ = _loc10_ + ((_loc10_ != ""?",":"") + "allies");
            if(_loc6_ > 0 && _loc6_ < _loc8_)
            {
               _loc10_ = _loc10_ + ",other";
            }
         }
         if(_loc6_ > 1 && _loc6_ == _loc8_)
         {
            _loc10_ = _loc10_ + ((_loc10_ != ""?",":"") + "enemies");
            if(_loc5_ > 0 && _loc5_ < _loc7_)
            {
               _loc10_ = _loc10_ + ",other";
            }
         }
         if(_loc10_ == "" && param2.length > 1)
         {
            _loc10_ = _loc10_ + ((_loc10_ != ""?",":"") + "other");
         }
         return _loc10_ == ""?"none":_loc10_;
      }
      
      private static function getNumberOfParametersToCheck(param1:FightEvent) : int
      {
         var _loc2_:int = param1.params.length;
         if(_loc2_ > param1.checkParams)
         {
            _loc2_ = param1.checkParams;
         }
         return _loc2_;
      }
      
      private static function needToGroupFightEventsData(param1:int, param2:FightEvent, param3:FightEvent) : Boolean
      {
         var _loc4_:int = 0;
         if(param2.castingSpellId != param3.castingSpellId)
         {
            return false;
         }
         _loc4_ = param2.firstParamToCheck;
         while(_loc4_ < param1)
         {
            if(param2.params[_loc4_] != param3.params[_loc4_])
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      private static function sendAllFightEvents() : void
      {
         var _loc1_:int = _fightEvents.length - 1;
         while(_loc1_ >= 0)
         {
            if(_fightEvents[_loc1_])
            {
               KernelEventsManager.getInstance().processCallback(HookList.FightEvent,_fightEvents[_loc1_].name,_fightEvents[_loc1_].params,[_fightEvents[_loc1_].targetId]);
            }
            _loc1_--;
         }
         clearData();
      }
      
      public static function clearData() : void
      {
         _fightEvents = new Vector.<FightEvent>();
      }
      
      private static function sendFightLogToChat(param1:FightEvent, param2:String = "", param3:Vector.<Number> = null, param4:Boolean = true, param5:Boolean = false) : void
      {
         var _loc6_:String = param1.name == FightEventEnum.FIGHTER_LIFE_LOSS && param5?"fightLifeLossAndDeath":param1.name;
         var _loc7_:Array = param1.params.concat();
         if(param4)
         {
            if(param1.name == FightEventEnum.FIGHTER_LIFE_LOSS || param1.name == FightEventEnum.FIGHTER_SHIELD_LOSS)
            {
               _loc7_[1] = formateColorsForFightDamages("-" + _loc7_[1],_loc7_[2]);
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.FightText,_loc6_,_loc7_,param3,param2);
      }
      
      private static function formateColorsForFightDamages(param1:String, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = "";
         var _loc5_:TypeAction = TypeAction.getTypeActionById(param2);
         var _loc6_:int = _loc5_ == null?-1:int(_loc5_.elementId);
         switch(_loc6_)
         {
            case -1:
               _loc4_ = XmlConfig.getInstance().getEntry("colors.fight.text.multi");
               break;
            case 0:
               _loc4_ = XmlConfig.getInstance().getEntry("colors.fight.text.neutral");
               break;
            case 1:
               _loc4_ = XmlConfig.getInstance().getEntry("colors.fight.text.earth");
               break;
            case 2:
               _loc4_ = XmlConfig.getInstance().getEntry("colors.fight.text.fire");
               break;
            case 3:
               _loc4_ = XmlConfig.getInstance().getEntry("colors.fight.text.water");
               break;
            case 4:
               _loc4_ = XmlConfig.getInstance().getEntry("colors.fight.text.air");
               break;
            case 5:
            default:
               _loc4_ = "";
         }
         if(_loc4_ != "")
         {
            _loc3_ = HtmlManager.addTag(param1,HtmlManager.SPAN,{"color":_loc4_});
         }
         else
         {
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      public static function get fightEvents() : Vector.<FightEvent>
      {
         return _fightEvents;
      }
      
      public static function get events() : Vector.<Vector.<FightEvent>>
      {
         return _events;
      }
      
      public static function get joinedEvents() : Vector.<FightEvent>
      {
         return _joinedEvents;
      }
   }
}
