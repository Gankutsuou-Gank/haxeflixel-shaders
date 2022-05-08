package; 

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import flixel.math.FlxPoint;

using StringTools;
typedef ShaderEffect = {
  var shader:Dynamic;
} 

class NoteEffect {
  public var shader:NoteShader = new NoteShader();
  public function new(){
    shader.flash.value = [0];
  }

  public function setFlash(val: Float){
    shader.flash.value=[val];
  }

} 

class NoteShader extends FlxShader
{
  @:glFragmentSource('
    #pragma header
    uniform float flash;

    float scaleNum(float x, float l1, float h1, float l2, float h2){
        return ((x - l1) * (h2 - l2) / (h1 - l1) + l2);
    }

    void main()
    {
        vec4 col = flixel_texture2D(bitmap, openfl_TextureCoordv);
        vec4 newCol = col;
        if(flash!=0.0 && col.a>0.0)
          newCol = mix(col,vec4(1.0,1.0,1.0,col.a),flash) * col.a;

        gl_FragColor = newCol;
    }
  ')
  public function new()
  {
    super();
  }

}