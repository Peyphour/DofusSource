package blocks
{
   import d2enums.BreedEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SpellShapeEnum;
   
   public class SpellHeaderBlock
   {
      
      private static var _shortcutColor:String;
       
      
      public var playerApi:Object;
      
      public var sysApi:Object;
      
      public var uiApi:Object;
      
      public var dataApi:Object;
      
      private var _spellItem:Object;
      
      private var _content:String = "";
      
      private var _block:Object;
      
      private var _param:paramClass#447;
      
      private var _shortcutKey:String;
      
      public function SpellHeaderBlock(param1:Object, param2:Object = null, param3:String = "chunk")
      {
         super();
         this.addApis();
         this._spellItem = param1;
         this._param = new paramClass#447();
         if(param2)
         {
            if(param2.hasOwnProperty("smallSpell"))
            {
               this._param.smallSpell = param2.smallSpell;
            }
            if(param2.hasOwnProperty("CC_EC"))
            {
               this._param.CC_EC = param2.CC_EC;
            }
            if(param2.hasOwnProperty("name"))
            {
               this._param.name = param2.name;
            }
            if(param2.hasOwnProperty("contextual"))
            {
               this._param.contextual = param2.contextual;
            }
            if(param2.hasOwnProperty("shortcutKey"))
            {
               this._param.shortcutKey = param2.shortcutKey;
            }
            if(param2.hasOwnProperty("effects"))
            {
               this._param.effects = param2.effects;
            }
         }
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("header",param3 + "/spell/header.txt"),Api.tooltip.createChunkData("details",param3 + "/spell/details.txt"),Api.tooltip.createChunkData("detailsCritical",param3 + "/spell/detailsCritical.txt"),Api.tooltip.createChunkData("detailsSpellZone",param3 + "/spell/detailsSpellZone.txt"),Api.tooltip.createChunkData("detailsEffect",param3 + "/spell/detailsEffect.txt"),Api.tooltip.createChunkData("p",param3 + "/text/p.txt"),Api.tooltip.createChunkData("separator",param3 + "/base/separator.txt")]);
      }
      
      private function getSpellHeaderChunkParams(param1:*) : Object
      {
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc2_:Object = new Object();
         _loc2_.name = param1.name;
         if(this._param.shortcutKey && this._param.shortcutKey != "")
         {
            if(!_shortcutColor)
            {
               _shortcutColor = this.sysApi.getConfigEntry("colors.shortcut").replace("0x","#");
            }
            _loc2_.name = _loc2_.name + (" <font color=\'" + _shortcutColor + "\'>(" + this._param.shortcutKey + ")</font>");
         }
         if(param1.useSpellLevelScaling)
         {
            _loc4_ = Api.player.getPlayedCharacterInfo();
            if(_loc4_ && _loc4_.level < param1.obtentionLevel)
            {
               if(param1.obtentionLevel > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  _loc3_ = "<span class=\'malus\'>" + this.uiApi.getText("ui.spell.requiredPrestige") + "</span>  <span class=\'value\'>" + (param1.obtentionLevel - ProtocolConstantsEnum.MAX_LEVEL) + "</span>";
               }
               else
               {
                  _loc3_ = "<span class=\'malus\'>" + this.uiApi.getText("ui.spell.requiredLevel") + "</span>  <span class=\'value\'>" + param1.obtentionLevel + "</span>";
               }
            }
            else if(param1.obtentionLevel > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc3_ = this.uiApi.getText("ui.common.prestige") + " <span class=\'value\'>" + (param1.obtentionLevel - ProtocolConstantsEnum.MAX_LEVEL) + "</span>";
            }
            else
            {
               _loc3_ = this.uiApi.getText("ui.common.level") + " <span class=\'value\'>" + param1.spellLevel + "</span>";
            }
         }
         else
         {
            _loc3_ = this.uiApi.getText("ui.common.rank","<span class=\'value\'>" + param1.spellLevel + "</span>");
         }
         _loc2_.rank = _loc3_;
         if(this.sysApi.getPlayerManager().hasRights)
         {
            _loc2_.name = _loc2_.name + (" (" + param1.id + ")");
            _loc2_.rank = _loc2_.rank + (" (" + param1.spellLevelInfos.id + ")");
         }
         return _loc2_;
      }
      
      private function getSpellDetailsChunkParams(param1:*) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:Object = new Object();
         _loc2_.apCost = param1.apCost;
         if(this._param.contextual)
         {
            _loc3_ = param1.maximalRangeWithBoosts;
         }
         else
         {
            _loc3_ = param1.maximalRange;
         }
         if(param1.minimalRange == _loc3_)
         {
            _loc4_ = _loc3_.toString();
         }
         else
         {
            _loc4_ = param1.minimalRange + " - " + _loc3_;
         }
         _loc2_.range = _loc4_;
         if(param1.rangeCanBeBoosted)
         {
            _loc2_.range = _loc2_.range + (" (" + this.uiApi.getText("ui.spell.rangeBoost") + ")");
         }
         return _loc2_;
      }
      
      private function getSpellZoneChunkParams(param1:*) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc2_:Object = new Object();
         var _loc3_:Object = param1.spellZoneEffects[0];
         var _loc4_:uint = _loc3_.zoneSize;
         for each(_loc5_ in param1.spellZoneEffects)
         {
            if(_loc5_.zoneShape != 0 && _loc5_.zoneSize < 63 && (_loc5_.zoneSize > _loc4_ || _loc5_.zoneSize == _loc4_ && _loc3_.zoneShape == SpellShapeEnum.P))
            {
               _loc4_ = _loc5_.zoneSize;
               _loc3_ = _loc5_;
            }
         }
         switch(_loc3_.zoneShape)
         {
            case SpellShapeEnum.minus:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.diagonal",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.A:
            case SpellShapeEnum.a:
               _loc6_ = this.uiApi.getText("ui.spellarea.everyone");
               break;
            case SpellShapeEnum.C:
               if(_loc3_.zoneSize == 63)
               {
                  _loc6_ = this.uiApi.getText("ui.spellarea.everyone");
               }
               else
               {
                  _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.circle",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               }
               break;
            case SpellShapeEnum.D:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.chessboard",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.L:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.line",_loc3_.zoneSize + 1),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.O:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.ring",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.Q:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.crossVoid",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.T:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.tarea",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.U:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.halfcircle",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.V:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.cone",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.X:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.cross",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.G:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.square",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.plus:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.plus",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.star:
               _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.spellarea.star",_loc3_.zoneSize),"m",_loc3_.zoneSize <= 1);
               break;
            case SpellShapeEnum.P:
         }
         _loc2_.spellZone = _loc6_;
         return _loc2_;
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this._content = "";
         if(this._param.name)
         {
            _loc1_ = this.getSpellHeaderChunkParams(this._spellItem);
            this._content = this._content + this._block.getChunk("header").processContent(_loc1_);
            this._content = this._content + this._block.getChunk("separator").processContent({});
         }
         _loc1_ = this.getSpellDetailsChunkParams(this._spellItem);
         this._content = this._content + this._block.getChunk("details").processContent(_loc1_);
         if(this._param.CC_EC)
         {
            if(this._param.contextual)
            {
               _loc2_ = this._spellItem.playerCriticalRate;
            }
            else
            {
               _loc2_ = this._spellItem.criticalHitProbability;
            }
            _loc3_ = this._spellItem.spellLevelInfos.criticalHitProbability != 0;
            if(_loc2_ > 54)
            {
               _loc2_ = 54;
            }
            _loc4_ = 55 - 1 / (1 / _loc2_);
            if(_loc4_ > 100)
            {
               _loc4_ = 100;
            }
            if(_loc3_)
            {
               this._content = this._content + this._block.getChunk("detailsCritical").processContent({"critical":_loc4_ + "%"});
            }
         }
         _loc1_ = this.getSpellZoneChunkParams(this._spellItem);
         if(_loc1_.spellZone)
         {
            this._content = this._content + this._block.getChunk("detailsSpellZone").processContent(_loc1_);
         }
         if(this._param.effects)
         {
            if(this._spellItem.spellBreed && this._spellItem.spellBreed <= BreedEnum.Huppermage && !this._param.smallSpell)
            {
               this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                  "text":Api.ui.getText("ui.common.breedSpell") + Api.ui.getText("ui.common.colon"),
                  "value":this.dataApi.getBreed(this._spellItem.spellBreed).shortName
               });
            }
            if(this._spellItem.castInLine && this._spellItem.range)
            {
               this._content = this._content + this._block.getChunk("p").processContent({"text":this.uiApi.getText("ui.spellInfo.castInLine")});
            }
            if(this._spellItem.castInDiagonal && this._spellItem.range)
            {
               this._content = this._content + this._block.getChunk("p").processContent({"text":this.uiApi.getText("ui.spellInfo.castInDiagonal")});
            }
            if(!this._spellItem.castTestLos && this._spellItem.range)
            {
               this._content = this._content + this._block.getChunk("p").processContent({"text":this.uiApi.getText("ui.spellInfo.castWithoutLos")});
            }
            if(this._spellItem.needTakenCell)
            {
               this._content = this._content + this._block.getChunk("p").processContent({"text":this.uiApi.getText("ui.spellInfo.castNeedTakenCell")});
            }
            if(this._spellItem.maxCastPerTarget)
            {
               this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                  "text":this.uiApi.getText("ui.spellInfo.maxCastPerTarget") + Api.ui.getText("ui.common.colon"),
                  "value":this._spellItem.maxCastPerTarget
               });
            }
            if(this._spellItem.maxStack > 0)
            {
               this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                  "text":this.uiApi.getText("ui.spellInfo.maxStack") + Api.ui.getText("ui.common.colon"),
                  "value":this._spellItem.maxStack
               });
            }
            if(this._spellItem.maxCastPerTurn)
            {
               this._content = this._content + this._block.getChunk("p").processContent({"text":this.uiApi.processText(this.uiApi.getText("ui.item.usePerTurn","<span class=\'value\'>" + this._spellItem.maxCastPerTurn + "</span>"),"n",this._spellItem.maxCastPerTurn <= 1)});
            }
            if(this._spellItem.minCastInterval)
            {
               this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                  "text":this.uiApi.getText("ui.spellInfo.minCastInterval") + Api.ui.getText("ui.common.colon"),
                  "value":this._spellItem.minCastInterval
               });
            }
            if(this._spellItem.globalCooldown)
            {
               if(this._spellItem.globalCooldown == -1)
               {
                  this._content = this._content + this._block.getChunk("p").processContent({"text":this.uiApi.getText("ui.spellInfo.globalCastInterval")});
               }
               else
               {
                  this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                     "text":this.uiApi.getText("ui.spellInfo.globalCastInterval") + Api.ui.getText("ui.common.colon"),
                     "value":this._spellItem.globalCooldown
                  });
               }
            }
            if(this._spellItem.statesRequired.length > 0)
            {
               for each(_loc5_ in this._spellItem.statesRequired)
               {
                  _loc6_ = this.dataApi.getSpellState(_loc5_);
                  if(!_loc6_.isSilent)
                  {
                     this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                        "text":this.uiApi.getText("ui.spellInfo.stateRequired") + Api.ui.getText("ui.common.colon"),
                        "value":_loc6_.name
                     });
                  }
               }
            }
            if(this._spellItem.statesForbidden.length > 0)
            {
               for each(_loc5_ in this._spellItem.statesForbidden)
               {
                  _loc6_ = this.dataApi.getSpellState(_loc5_);
                  if(!_loc6_.isSilent)
                  {
                     this._content = this._content + this._block.getChunk("detailsEffect").processContent({
                        "text":this.uiApi.getText("ui.spellInfo.stateForbidden") + Api.ui.getText("ui.common.colon"),
                        "value":_loc6_.name
                     });
                  }
               }
            }
         }
         this.removeApis();
      }
      
      public function getContent() : String
      {
         return this._content;
      }
      
      public function get block() : Object
      {
         return this._block;
      }
      
      private function addApis() : void
      {
         this.sysApi = Api.system;
         this.uiApi = Api.ui;
         this.dataApi = Api.data;
         this.playerApi = Api.player;
      }
      
      private function removeApis() : void
      {
         this.sysApi = null;
         this.uiApi = null;
         this.playerApi = null;
         this.dataApi = null;
      }
   }
}

class paramClass#447
{
    
   
   public var contextual:Boolean = false;
   
   public var smallSpell:Boolean = false;
   
   public var CC_EC:Boolean = true;
   
   public var name:Boolean = true;
   
   public var effects:Boolean = true;
   
   public var shortcutKey:String;
   
   function paramClass#447()
   {
      super();
   }
}
