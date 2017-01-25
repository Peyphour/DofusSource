package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.console.moduleLogger.ModuleDebugManager;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.frames.BenchmarkFrame;
   import com.ankamagames.dofus.logic.common.frames.DebugBotFrame;
   import com.ankamagames.dofus.logic.common.frames.FightBotFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.misc.BenchmarkMovementBehavior;
   import com.ankamagames.dofus.misc.utils.frames.LuaScriptRecorderFrame;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.BenchmarkCharacter;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.prng.PRNG;
   import com.ankamagames.jerakine.utils.prng.ParkMillerCarta;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.TiphonDebugManager;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class BenchmarkInstructionHandler implements ConsoleInstructionHandler
   {
      
      private static var id:uint = 50000;
       
      
      protected var _log:Logger;
      
      public function BenchmarkInstructionHandler()
      {
         this._log = Log.getLogger(getQualifiedClassName(BenchmarkInstructionHandler));
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:IAnimated = null;
         var _loc5_:LuaScriptRecorderFrame = null;
         var _loc6_:FightEntitiesFrame = null;
         var _loc7_:Dictionary = null;
         var _loc8_:IAnimated = null;
         var _loc9_:FpsManager = null;
         var _loc10_:* = null;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:PRNG = null;
         var _loc20_:uint = 0;
         var _loc21_:BenchmarkCharacter = null;
         var _loc22_:MapPoint = null;
         var _loc23_:GameContextActorInformations = null;
         var _loc24_:GameFightMonsterInformations = null;
         var _loc25_:DebugBotFrame = null;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:* = false;
         var _loc29_:String = null;
         var _loc30_:Array = null;
         var _loc31_:String = null;
         switch(param2)
         {
            case "addmovingcharacter":
               if(param3.length > 0)
               {
                  _loc19_ = new ParkMillerCarta(4538651);
                  _loc20_ = 0;
                  while(_loc20_ < parseInt(param3[1]))
                  {
                     _loc21_ = new BenchmarkCharacter(id++,TiphonEntityLook.fromString(param3[0]));
                     do
                     {
                        _loc22_ = MapPoint.fromCellId(_loc19_.nextIntR(0,AtouinConstants.MAP_CELLS_COUNT));
                     }
                     while(!DataMapProvider.getInstance().pointMov(_loc22_.x,_loc22_.y));
                     
                     _loc21_.position = MapPoint.fromCellId(_loc22_.cellId);
                     _loc21_.display();
                     _loc21_.move(BenchmarkMovementBehavior.getRandomPath(_loc21_));
                     _loc20_++;
                  }
               }
               break;
            case "setanimation":
               _loc4_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
               _loc5_ = Kernel.getWorker().getFrame(LuaScriptRecorderFrame) as LuaScriptRecorderFrame;
               if(Kernel.getWorker().getFrame(LuaScriptRecorderFrame))
               {
                  _loc5_.createLine("player","setAnimation",param3[0],true);
               }
               _loc4_.setAnimation(param3[0]);
               break;
            case "setdirection":
               _loc6_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
               _loc7_ = _loc6_.getEntitiesDictionnary();
               _loc8_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
               for each(_loc23_ in _loc7_)
               {
                  if(_loc23_ is GameFightMonsterInformations)
                  {
                     _loc24_ = _loc23_ as GameFightMonsterInformations;
                     if(_loc24_.creatureGenericId == parseInt(param3[1]))
                     {
                        _loc8_ = DofusEntities.getEntity(_loc24_.contextualId) as IAnimated;
                        _loc8_.setDirection(param3[0]);
                     }
                  }
               }
               _loc8_.setDirection(param3[0]);
               break;
            case "tiphon-error":
               TiphonDebugManager.disable();
               break;
            case "bot-spectator":
               if(Kernel.getWorker().contains(DebugBotFrame))
               {
                  Kernel.getWorker().removeFrame(DebugBotFrame.getInstance());
                  param1.output("Arret du bot-spectator, " + DebugBotFrame.getInstance().fightCount + " combat(s) vu");
               }
               else
               {
                  _loc25_ = DebugBotFrame.getInstance();
                  _loc26_ = param3.indexOf("debugchat");
                  if(_loc26_ != -1)
                  {
                     _loc27_ = 500;
                     if(param3.length > _loc26_ + 1)
                     {
                        _loc27_ = param3[_loc26_ + 1];
                     }
                     _loc25_.enableChatMessagesBot(true,_loc27_);
                  }
                  Kernel.getWorker().addFrame(_loc25_);
                  param1.output("Démarrage du bot-spectator ");
               }
               break;
            case "bot-fight":
               if(Kernel.getWorker().contains(FightBotFrame))
               {
                  Kernel.getWorker().removeFrame(FightBotFrame.getInstance());
                  param1.output("Arret du bot-fight, " + FightBotFrame.getInstance().fightCount + " combat(s) effectué");
               }
               else
               {
                  Kernel.getWorker().addFrame(FightBotFrame.getInstance());
                  param1.output("Démarrage du bot-fight ");
               }
               break;
            case "fps":
               ModuleDebugManager.display(!ModuleDebugManager.isDisplayed,false);
               break;
            case "fpsmanager":
               _loc9_ = FpsManager.getInstance();
               if(StageShareManager.stage.contains(_loc9_))
               {
                  _loc9_.hide();
               }
               else
               {
                  _loc28_ = param3.indexOf("external") != -1;
                  if(_loc28_)
                  {
                     param1.output("Fps Manager External");
                  }
                  _loc9_.display(_loc28_);
               }
               break;
            case "tacticmode":
               TacticModeManager.getInstance().hide();
               _loc11_ = false;
               _loc12_ = 0;
               _loc13_ = false;
               _loc14_ = false;
               _loc15_ = false;
               _loc16_ = false;
               _loc17_ = true;
               _loc18_ = true;
               for each(_loc29_ in param3)
               {
                  _loc30_ = _loc29_.split("=");
                  if(_loc30_ != null)
                  {
                     _loc31_ = _loc30_[1];
                     if(_loc29_.search("fightzone") != -1 && _loc30_.length > 1)
                     {
                        _loc13_ = _loc31_.toLowerCase() == "true"?true:false;
                     }
                     else if(_loc29_.search("clearcache") != -1 && _loc30_.length > 1)
                     {
                        _loc11_ = _loc31_.toLowerCase() == "true"?false:true;
                     }
                     else if(_loc29_.search("mode") != -1 && _loc30_.length > 1)
                     {
                        _loc12_ = _loc31_.toLowerCase() == "rp"?1:0;
                     }
                     else if(_loc29_.search("interactivecells") != -1 && _loc30_.length > 1)
                     {
                        _loc14_ = _loc31_.toLowerCase() == "true"?true:false;
                     }
                     else if(_loc29_.search("scalezone") != -1 && _loc30_.length > 1)
                     {
                        _loc16_ = _loc31_.toLowerCase() == "true"?true:false;
                     }
                     else if(_loc29_.search("show") != -1 && _loc30_.length > 1)
                     {
                        _loc15_ = _loc31_.toLowerCase() == "true"?true:false;
                     }
                     else if(_loc29_.search("flattencells") != -1 && _loc30_.length > 1)
                     {
                        _loc17_ = _loc31_.toLowerCase() == "true"?true:false;
                     }
                     else if(_loc29_.search("blocLDV") != -1 && _loc30_.length > 1)
                     {
                        _loc18_ = _loc31_.toLowerCase() == "true"?true:false;
                     }
                  }
               }
               if(_loc15_)
               {
                  TacticModeManager.getInstance().setDebugMode(_loc13_,_loc11_,_loc12_,_loc14_,_loc16_,_loc17_,_loc18_);
                  TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap,true);
                  _loc10_ = "Activation";
               }
               else
               {
                  _loc10_ = "Désactivation";
               }
               _loc10_ = _loc10_ + " du mode tactique.";
               param1.output(_loc10_);
               break;
            case "chainteleport":
               if(Kernel.getWorker().contains(BenchmarkFrame))
               {
                  Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(BenchmarkFrame));
               }
               else
               {
                  Kernel.getWorker().addFrame(new BenchmarkFrame());
               }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "setdirection":
               return "Set direction of the player if only one arg is used. You can specifie a second arg that will be the generic ID of a monster (use tab to list them)";
            case "addmovingcharacter":
               return "Add a new mobile character on scene.";
            case "fps":
               return "Displays the performance of the client.";
            case "fpsmanager":
               return "Displays the performance of the client." + "\n    external";
            case "bot-spectator":
               return "Start/Stop the auto join fight spectator bot" + "\n    debugchat";
            case "tiphon-error":
               return "Désactive l\'affichage des erreurs du moteur d\'animation.";
            case "tacticmode":
               return "Active/Désactive le mode tactique" + "\n    show=[true|false]" + "\n    clearcache=[true|false]" + "\n    mode=[fight|RP]" + "\n    interactivecells=[true|false] " + "\n    fightzone=[true|false]" + "\n    scalezone=[true|false]" + "\n    flattencells=[true|false]";
            case "chainteleport":
               return "Chain teleport in all game area";
            default:
               return "Unknow command";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc4_:TiphonSprite = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:FightEntitiesFrame = null;
         var _loc9_:Dictionary = null;
         var _loc10_:IAnimated = null;
         var _loc11_:Array = null;
         var _loc12_:GameContextActorInformations = null;
         var _loc13_:GameFightMonsterInformations = null;
         switch(param1)
         {
            case "tacticmode":
               return ["show","clearcache","mode","interactivecells","fightzone","scalezone","flattencells"];
            case "setanimation":
               _loc4_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as TiphonSprite;
               _loc5_ = _loc4_.animationList;
               _loc6_ = [];
               for each(_loc7_ in _loc5_)
               {
                  if(_loc7_.indexOf("Anim") != -1)
                  {
                     _loc6_.push(_loc7_);
                  }
               }
               _loc6_.sort();
               return _loc6_;
            case "setdirection":
               if(param2 == 0)
               {
                  return [0,1,2,3,4,5,6,7];
               }
               if(param2 == 1)
               {
                  _loc8_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
                  _loc9_ = _loc8_.getEntitiesDictionnary();
                  _loc10_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
                  _loc11_ = [];
                  for each(_loc12_ in _loc9_)
                  {
                     if(_loc12_ is GameFightMonsterInformations)
                     {
                        _loc13_ = _loc12_ as GameFightMonsterInformations;
                        _loc11_.push(Monster.getMonsterById(_loc13_.creatureGenericId).id + " " + Monster.getMonsterById(_loc13_.creatureGenericId).name);
                     }
                  }
                  _loc11_.sort();
                  return _loc11_;
               }
            default:
               return [];
         }
      }
   }
}
