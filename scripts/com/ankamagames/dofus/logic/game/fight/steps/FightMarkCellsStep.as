package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   
   public class FightMarkCellsStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _markId:int;
      
      private var _markType:int;
      
      private var _markSpellLevel:SpellLevel;
      
      private var _cells:Vector.<GameActionMarkedCell>;
      
      private var _markSpellId:int;
      
      private var _markTeamId:int;
      
      private var _markImpactCell:int;
      
      private var _markActive:Boolean;
      
      public function FightMarkCellsStep(param1:int, param2:int, param3:Vector.<GameActionMarkedCell>, param4:int, param5:SpellLevel, param6:int, param7:int, param8:Boolean = true)
      {
         super();
         this._markId = param1;
         this._markType = param2;
         this._cells = param3;
         this._markSpellId = param4;
         this._markSpellLevel = param5;
         this._markTeamId = param6;
         this._markImpactCell = param7;
         this._markActive = param8;
      }
      
      public function get stepType() : String
      {
         return "markCells";
      }
      
      override public function start() : void
      {
         var _loc4_:GameActionMarkedCell = null;
         var _loc5_:AddGlyphGfxStep = null;
         var _loc6_:String = null;
         var _loc7_:FightTurnFrame = null;
         var _loc8_:PathElement = null;
         var _loc9_:Boolean = false;
         var _loc1_:Spell = Spell.getSpellById(this._markSpellId);
         var _loc2_:SpellLevel = _loc1_.getSpellLevel(this._markSpellLevel.grade);
         if(this._markType == GameActionMarkTypeEnum.WALL || _loc2_.hasZoneShape(SpellShapeEnum.semicolon))
         {
            if(_loc1_.getParamByName("glyphGfxId") || true)
            {
               for each(_loc4_ in this._cells)
               {
                  _loc5_ = new AddGlyphGfxStep(_loc1_.getParamByName("glyphGfxId"),_loc4_.cellId,this._markId,this._markType,this._markTeamId);
                  _loc5_.start();
               }
            }
         }
         else if(_loc1_.getParamByName("glyphGfxId") && !MarkedCellsManager.getInstance().getGlyph(this._markId) && this._markImpactCell != -1)
         {
            _loc5_ = new AddGlyphGfxStep(_loc1_.getParamByName("glyphGfxId"),this._markImpactCell,this._markId,this._markType,this._markTeamId);
            _loc5_.start();
         }
         MarkedCellsManager.getInstance().addMark(this._markId,this._markType,_loc1_,this._markSpellLevel,this._cells,this._markTeamId,this._markActive,this._markImpactCell);
         var _loc3_:MarkInstance = MarkedCellsManager.getInstance().getMarkDatas(this._markId);
         if(_loc3_)
         {
            _loc6_ = FightEventEnum.UNKNOWN_FIGHT_EVENT;
            switch(_loc3_.markType)
            {
               case GameActionMarkTypeEnum.GLYPH:
                  _loc6_ = FightEventEnum.GLYPH_APPEARED;
                  break;
               case GameActionMarkTypeEnum.TRAP:
                  _loc6_ = FightEventEnum.TRAP_APPEARED;
                  break;
               case GameActionMarkTypeEnum.PORTAL:
                  _loc6_ = FightEventEnum.PORTAL_APPEARED;
                  break;
               default:
                  _log.warn("Unknown mark type (" + _loc3_.markType + ").");
            }
            FightEventsHelper.sendFightEvent(_loc6_,[_loc3_.associatedSpell.id],0,castingSpellId);
            _loc7_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(_loc7_ && _loc7_.myTurn && _loc7_.lastPath)
            {
               for each(_loc8_ in _loc7_.lastPath.path)
               {
                  if(_loc3_.cells.indexOf(_loc8_.cellId) != -1)
                  {
                     _loc9_ = true;
                     break;
                  }
               }
               if(_loc9_)
               {
                  _loc7_.updatePath();
               }
            }
         }
         executeCallbacks();
      }
   }
}
