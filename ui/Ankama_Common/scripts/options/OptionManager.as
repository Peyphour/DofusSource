package options
{
   import com.ankamagames.dofus.uiApi.SystemApi;
   
   public class OptionManager
   {
      
      private static var _self:OptionManager;
       
      
      public var sysApi:SystemApi;
      
      private var _options:Array;
      
      private var _indexedOption:Array;
      
      public function OptionManager()
      {
         this._options = new Array();
         this._indexedOption = new Array();
         super();
         if(_self)
         {
            throw new Error("Singleton Error");
         }
      }
      
      public static function getInstance() : OptionManager
      {
         if(!_self)
         {
            _self = new OptionManager();
         }
         return _self;
      }
      
      public function createItem(param1:String, param2:String, param3:String, param4:String = null, param5:Array = null) : OptionItem
      {
         return new OptionItem(param1,param2,param3,param4,param5);
      }
      
      public function addItem(param1:OptionItem) : void
      {
         if(this._indexedOption[param1.id])
         {
            return;
         }
         this._indexedOption[param1.id] = param1;
         this._options.push(param1);
      }
      
      public function get items() : Array
      {
         return this._options;
      }
   }
}
