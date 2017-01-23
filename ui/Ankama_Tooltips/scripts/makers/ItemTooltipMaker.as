package makers
{
   import blockParams.EffectsTooltipBlockParameters;
   import blocks.ConditionTooltipBlock;
   import blocks.DescriptionTooltipBlock;
   import blocks.HtmlEffectsTooltipBlock;
   import blocks.ItemDetailsBlock;
   import blocks.ItemHeaderBlock;
   import blocks.TextTooltipBlock;
   import blocks.TextWithTwoColumnsBlock;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import flash.ui.Keyboard;
   
   public class ItemTooltipMaker
   {
      
      private static const chunkType:String = "htmlChunks";
       
      
      private var _param:paramClass#154;
      
      public function ItemTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc12_:* = undefined;
         var _loc14_:EffectsTooltipBlockParameters = null;
         var _loc17_:* = undefined;
         var _loc18_:Object = null;
         var _loc19_:Idol = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc3_:UiApi = Api.ui;
         var _loc4_:UtilApi = Api.util;
         var _loc5_:SystemApi = Api.system;
         if(param1.hasOwnProperty("itemWrapper"))
         {
            param1 = param1.itemWrapper;
         }
         var _loc6_:* = Api.data.getItem(param1.objectGID).possibleEffects;
         var _loc7_:Boolean = false;
         var _loc8_:Array = new Array();
         this._param = new paramClass#154();
         var _loc9_:* = chunkType + "/item/baseWithBackground.txt";
         if(param2)
         {
            if(param2.hasOwnProperty("noBg"))
            {
               this._param.noBg = param2.noBg;
               if(this._param.noBg)
               {
                  _loc9_ = chunkType + "/item/base.txt";
               }
            }
            if(param2.hasOwnProperty("setMode"))
            {
               _loc7_ = param2.setMode;
               delete param2.setMode;
            }
            if(param2.hasOwnProperty("description"))
            {
               this._param.description = param2.description;
            }
            if(param2.hasOwnProperty("effects"))
            {
               this._param.effects = param2.effects;
            }
            if(param2.hasOwnProperty("CC_EC"))
            {
               this._param.CC_EC = param2.CC_EC;
            }
            if(param2.hasOwnProperty("noFooter"))
            {
               this._param.noFooter = param2.noFooter;
            }
            if(param2.hasOwnProperty("noTheoreticalEffects"))
            {
               this._param.noTheoreticalEffects = param2.noTheoreticalEffects;
            }
            if(param2.hasOwnProperty("header"))
            {
               this._param.header = param2.header;
               if(!this._param.header)
               {
                  _loc9_ = _loc9_.replace(".txt","NoIcon.txt");
               }
            }
            if(param2.hasOwnProperty("conditions"))
            {
               this._param.conditions = param2.conditions;
            }
            if(param2.hasOwnProperty("targetConditions"))
            {
               this._param.targetConditions = param2.targetConditions;
            }
            if(param2.hasOwnProperty("length"))
            {
               this._param.length = param2.length;
            }
            if(param2.hasOwnProperty("equipped"))
            {
               this._param.equipped = param2.equipped;
            }
            if(param2.hasOwnProperty("shortcutKey"))
            {
               this._param.shortcutKey = param2.shortcutKey;
            }
            if(param2.hasOwnProperty("showEffects"))
            {
               if(param2.showEffects && param1 && param1.effects.length <= 0)
               {
                  for each(_loc17_ in _loc6_)
                  {
                     _loc8_.push(_loc17_);
                  }
               }
            }
            if(param2.hasOwnProperty("averagePrice"))
            {
               this._param.averagePrice = param2.averagePrice;
            }
            if(param2.hasOwnProperty("contextual"))
            {
               this._param.contextual = param2.contextual;
            }
            if(param2.hasOwnProperty("addTheoreticalEffects"))
            {
               this._param.addTheoreticalEffects = param2.addTheoreticalEffects;
            }
            else
            {
               param2.addTheoreticalEffects = false;
            }
         }
         var _loc10_:Object = Api.tooltip.createTooltip(_loc9_,chunkType + "/base/container.txt",chunkType + "/base/separator.txt");
         _loc10_.chunkType = chunkType;
         if(this._param.equipped)
         {
            _loc10_.addBlock(new TextTooltipBlock(_loc3_.getText("ui.item.equipped"),{
               "css":"[local.css]normal.css",
               "classCss":"disabled"
            },chunkType).block);
         }
         _loc10_.addBlock(new ItemHeaderBlock(param1,this._param,chunkType).block);
         var _loc11_:Array = new Array();
         var _loc13_:Boolean = false;
         if(_loc8_.length)
         {
            for each(_loc12_ in _loc8_)
            {
               _loc11_.push(_loc12_);
            }
            _loc13_ = true;
         }
         else
         {
            for each(_loc12_ in param1.effects)
            {
               _loc11_.push(_loc12_);
            }
         }
         if(param1.enhanceable && !this._param.addTheoreticalEffects && (_loc5_.isKeyDown(Keyboard.CONTROL) || _loc5_.getOption("alwaysDisplayTheoreticalEffectsInTooltip","dofus")) && !_loc13_)
         {
            if(!this._param.noTheoreticalEffects)
            {
               if(param2)
               {
                  param2.addTheoreticalEffects = true;
               }
               this._param.addTheoreticalEffects = true;
            }
         }
         else if(!param1.enhanceable)
         {
            _loc6_ = null;
            this._param.addTheoreticalEffects = false;
         }
         for each(_loc12_ in param1.favoriteEffect)
         {
            _loc11_.push(_loc12_);
         }
         if(_loc11_.length && this._param.effects)
         {
            _loc14_ = EffectsTooltipBlockParameters.create(_loc11_,chunkType);
            _loc14_.length = this._param.length;
            _loc14_.showTheoreticalEffects = _loc13_;
            _loc14_.addTheoreticalEffects = this._param.addTheoreticalEffects;
            _loc14_.itemTheoreticalEffects = _loc6_;
            if(param2.hasOwnProperty("effects") && param2.effects || param2.hasOwnProperty("damages") && param2.damages || param2.hasOwnProperty("specialEffects") && param2.specialEffects)
            {
               if(param2.hasOwnProperty("damages"))
               {
                  _loc14_.showDamages = param2.damages;
               }
               if(param2.hasOwnProperty("specialEffects"))
               {
                  _loc14_.showSpecialEffects = param2.specialEffects;
               }
            }
            _loc10_.addBlock(new HtmlEffectsTooltipBlock(_loc14_).block);
         }
         if(_loc7_ && this._param.effects)
         {
            _loc18_ = Api.player.getPlayerSet(param1.objectGID);
            if(_loc18_)
            {
               _loc14_ = EffectsTooltipBlockParameters.create(_loc18_.setEffects,chunkType);
               _loc14_.length = this._param.length;
               _loc14_.showTheoreticalEffects = _loc13_;
               _loc14_.setInfo = _loc18_.setName + " (" + _loc18_.setObjects.length + "/" + _loc18_.allItems.length + ")";
               _loc10_.addBlock(new HtmlEffectsTooltipBlock(_loc14_).block);
            }
         }
         if(param1.typeId == 178)
         {
            if(_loc11_.length == 0)
            {
               _loc10_.addBlock(new TextTooltipBlock(Api.ui.processText(Api.ui.getText("ui.common.effects"),"") + Api.ui.getText("ui.common.colon"),{"classCss":"subtitle"},chunkType).block);
            }
            _loc19_ = Api.data.getIdolByItemId(param1.objectGID);
            _loc10_.addBlock(new TextTooltipBlock("• " + _loc19_.spellPair.description,{
               "classCss":"p",
               "width":this._param.length
            },chunkType).block);
         }
         var _loc15_:Object = param1.conditions;
         if(_loc15_ && _loc15_.text && this._param.conditions)
         {
            _loc10_.addBlock(new ConditionTooltipBlock(_loc15_,param1.criteria,null,false,chunkType).block);
         }
         var _loc16_:Object = param1.targetConditions;
         if(_loc16_ && _loc16_.text && this._param.targetConditions)
         {
            _loc10_.addBlock(new ConditionTooltipBlock(_loc16_,param1.criteria,null,true,chunkType).block);
         }
         _loc10_.addBlock(new ItemDetailsBlock(param1,this._param,chunkType).block);
         if(this._param.description)
         {
            _loc10_.addBlock(new DescriptionTooltipBlock(param1.description,"quote",chunkType).block);
         }
         if(!SpellTooltipMaker.SPELL_TAB_MODE && !this._param.noFooter)
         {
            _loc20_ = !param1.enhanceable || _loc13_ || !_loc6_ || !_loc6_.length || !_loc14_?"":"[ui.tooltip.item.tip2]";
            if(_loc5_.getOption("alwaysDisplayTheoreticalEffectsInTooltip","dofus"))
            {
               _loc20_ = "";
            }
            _loc21_ = "[ui.tooltip.item.tip]";
            if(param2 && param2.hasOwnProperty("noLeftFooter") && param2.noLeftFooter)
            {
               _loc21_ = "";
            }
            if(_loc21_ || _loc20_)
            {
               _loc10_.addBlock(new TextWithTwoColumnsBlock({
                  "leftCss":"footerleft",
                  "leftText":_loc21_,
                  "rightCss":"footerright",
                  "rightText":_loc20_
               },chunkType).block);
            }
         }
         return _loc10_;
      }
   }
}

class paramClass#154
{
    
   
   public var header:Boolean = true;
   
   public var effects:Boolean = true;
   
   public var description:Boolean = true;
   
   public var noBg:Boolean = false;
   
   public var CC_EC:Boolean = true;
   
   public var conditions:Boolean = true;
   
   public var targetConditions:Boolean = true;
   
   public var length:int = 409;
   
   public var averagePrice:Boolean = true;
   
   public var equipped:Boolean = false;
   
   public var shortcutKey:String;
   
   public var contextual:Boolean = false;
   
   public var noFooter:Boolean = false;
   
   public var addTheoreticalEffects:Boolean = false;
   
   public var noTheoreticalEffects:Boolean = false;
   
   function paramClass#154()
   {
      super();
   }
}
