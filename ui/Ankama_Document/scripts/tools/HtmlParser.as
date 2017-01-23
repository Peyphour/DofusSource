package tools
{
   public final class HtmlParser
   {
       
      
      public function HtmlParser()
      {
         super();
      }
      
      public static function parseText(param1:String) : String
      {
         var _loc2_:RegExp = null;
         param1 = param1.split("<strong>").join("<b>");
         param1 = param1.split("</strong>").join("</b>");
         param1 = param1.split("<br />").join("");
         param1 = param1.split("<br/>").join("");
         param1 = param1.split("<BR />").join("");
         param1 = param1.split("<BR/>").join("");
         param1 = param1.split("&OElig;").join("Œ");
         _loc2_ = /<span style="color: #([0-9a-fA-F]{1,6})">(.*)</span>/g;
         param1 = param1.replace(_loc2_,"<font color=\'#$1\'>$2</font>");
         _loc2_ = /<span style="font-size: xx-small">(.*)</span>/g;
         param1 = param1.replace(_loc2_,"<font size=\'14\'>$1</font>");
         _loc2_ = /<span style="font-size: xx-large">(.*)</span>/g;
         param1 = param1.replace(_loc2_,"<font size=\'22\'>$1</font>");
         return param1;
      }
   }
}
