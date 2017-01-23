package makers
{
   import blockParams.EffectsTooltipBlockParameters;
   import blocks.DescriptionTooltipBlock;
   import blocks.HtmlEffectsTooltipBlock;
   import blocks.SpellHeaderBlock;
   import blocks.TextTooltipBlock;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   
   public class SpellTooltipMaker
   {
      
      private static const chunkType:String = "htmlChunks";
      
      public static var SPELL_TAB_MODE:Boolean;
       
      
      private var _param:paramClass#179;
      
      public function SpellTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc4_:* = null;
         var _loc7_:Object = null;
         var _loc8_:EffectsTooltipBlockParameters = null;
         var _loc3_:Object = Api.data;
         this._param = new paramClass#179();
         SPELL_TAB_MODE = param2 && param2.hasOwnProperty("spellTab") && param2.spellTab;
         if(param2)
         {
            if(param2.hasOwnProperty("noBg"))
            {
               this._param.noBg = param2.noBg;
            }
            if(param2.hasOwnProperty("description"))
            {
               this._param.description = param2.description;
            }
            if(param2.hasOwnProperty("effects"))
            {
               this._param.effects = param2.effects;
            }
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
            if(param2.hasOwnProperty("header"))
            {
               this._param.header = param2.header;
            }
            if(param2.hasOwnProperty("contextual"))
            {
               this._param.contextual = param2.contextual;
            }
            if(param2.hasOwnProperty("shortcutKey"))
            {
               this._param.shortcutKey = param2.shortcutKey;
            }
            if(param2.hasOwnProperty("footer"))
            {
               this._param.footer = param2.footer;
            }
         }
         if(!this._param.CC_EC && !this._param.description && !this._param.effects && !this._param.name)
         {
            return "";
         }
         if(this._param.noBg)
         {
            _loc4_ = chunkType + "/spell/base";
         }
         else
         {
            _loc4_ = chunkType + "/spell/baseWithBackground";
         }
         if(this._param.name)
         {
            _loc4_ = _loc4_ + ".txt";
         }
         else
         {
            _loc4_ = _loc4_ + "NoIcon.txt";
         }
         var _loc5_:Object = Api.tooltip.createTooltip(_loc4_,chunkType + "/base/container.txt",chunkType + "/base/separator.txt");
         _loc5_.chunkType = chunkType;
         var _loc6_:Object = param1;
         if(_loc6_ is SpellWrapper && _loc6_.isSpellWeapon)
         {
            _loc7_ = Api.player.getWeapon();
            if(_loc7_)
            {
               return new ItemTooltipMaker().createTooltip(_loc7_,{
                  "noBg":this._param.noBg,
                  "header":this._param.name,
                  "effects":this._param.effects,
                  "contextual":this._param.contextual,
                  "conditions":true,
                  "description":this._param.description,
                  "CC_EC":this._param.CC_EC,
                  "contextual":true,
                  "shortcutKey":this._param.shortcutKey
               });
            }
         }
         if(this._param.header)
         {
            _loc5_.addBlock(new SpellHeaderBlock(_loc6_,param2,chunkType).block);
         }
         if(this._param.description && _loc6_.description)
         {
            _loc5_.addBlock(new DescriptionTooltipBlock(_loc6_.description,"description",chunkType).block);
         }
         if(this._param.effects)
         {
            if(!_loc6_.hideEffects && _loc6_.effects.length)
            {
               _loc8_ = EffectsTooltipBlockParameters.create(_loc6_.effects);
               _loc8_.chunkType = chunkType;
               _loc8_.splitDamageAndEffects = false;
               _loc5_.addBlock(new HtmlEffectsTooltipBlock(_loc8_).block);
            }
            if(!_loc6_.hideEffects && _loc6_.criticalEffect.length)
            {
               _loc8_ = EffectsTooltipBlockParameters.create(_loc6_.criticalEffect);
               _loc8_.isCriticalEffects = true;
               _loc8_.splitDamageAndEffects = false;
               _loc8_.chunkType = chunkType;
               _loc5_.addBlock(new HtmlEffectsTooltipBlock(_loc8_).block);
            }
         }
         if(!SPELL_TAB_MODE && this._param.footer)
         {
            _loc5_.addBlock(new TextTooltipBlock(Api.ui.getText("ui.tooltip.spell.tip"),{"classCss":"footer"},chunkType).block);
         }
         return _loc5_;
      }
   }
}

class paramClass#179
{
    
   
   public var contextual:Boolean = false;
   
   public var name:Boolean = true;
   
   public var header:Boolean = true;
   
   public var footer:Boolean = true;
   
   public var description:Boolean = true;
   
   public var effects:Boolean = true;
   
   public var noBg:Boolean = false;
   
   public var smallSpell:Boolean = false;
   
   public var CC_EC:Boolean = true;
   
   public var shortcutKey:String = "";
   
   function paramClass#179()
   {
      super();
   }
}
