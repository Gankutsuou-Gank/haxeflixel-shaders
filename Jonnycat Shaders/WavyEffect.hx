//1st shader port i made me jonnycat ported this shader https://www.shadertoy.com/view/4dSXRR  
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
  
class SurfEffect 
{ 
public var shader(default, null):SurfShader = new SurfShader(); 

public function new()
{  
  shader.iTime.value = [0];
  shader.amplitude.value = [0.10]; 
} 

public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
}  
public function setamplitude(goofy:Float){
  shader.amplitude.value = [goofy];
} 
}
class SurfShader extends FlxShader
{ 
@:glFragmentSource('
  #pragma header 
  uniform float iTime; 
  unifrom float amplitude;
  void main()
{
    vec2 texCoord = openfl_TextureCoordv;
    
    vec2 pulse = sin(iTime + texCoord); 

    float dist = 2.0 * length(texCoord.y - 0.5);
    
    vec2 newCoord = texCoord + amplitude * vec2(0.0, pulse.x); // y-axis only; 
    
    vec2 interpCoord = mix(newCoord, texCoord, dist);
	
    gl_fragColor = flixel_texture2D(bitmap, interpCoord);
}
  ')
  public function new()
  {
    super();
  }
} 
