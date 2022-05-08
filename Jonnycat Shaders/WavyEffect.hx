//1st shader port i made me jonnycat ported this shader https://www.shadertoy.com/view/4dSXRR   
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
  
class WavyEffect 
{ 
public var shader(default, null):WavyShader = new WavyShader(); 

public function new()
{  
  shader.data.iTime.value = [0];
  shader.data.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight]; 
  shader.data.frequency.value = [8.0];  
  shader.data.amplitude.value = [0.05]; 
} 

public function update(elapsed:Float){
    shader.data.iTime.value[0] += elapsed;
    shader.data.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight]; 
}  
public function setfrequency(chickennuggets:Float){
  shader.data.frequency.value = [chickennuggets];
}  
public function setamplitude(goof:Float){
  shader.data.amplitude.value = [goof];
} 
}
class WavyShader extends FlxShader
{ 
@:glFragmentSource('
  #pragma header
  uniform vec2 iResolution; 
  uniform float iTime;  
  uniform float frequency; 
  uniform float amplitude;
  void main()
  {
      vec2 fragCoord = openfl_TextureCoordv * iResolution;  

      vec2 texCoord = fragCoord.xy / iResolution.xy; 
      
      vec2 pulse = sin(iTime - frequency * texCoord);
      float dist = 2.0 * length(texCoord.y - 0.5);
      
      vec2 newCoord = texCoord + amplitude * vec2(0.0, pulse.x); // y-axis only; 
      
      vec2 interpCoord = mix(newCoord, texCoord, dist);
    
      gl_FragColor = texture2D(bitmap,interpCoord);
  }
  ')
  public function new()
  {
    super();
  }
} 
