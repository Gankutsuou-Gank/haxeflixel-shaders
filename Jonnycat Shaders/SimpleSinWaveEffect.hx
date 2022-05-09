 

//da shader https://www.shadertoy.com/view/MsX3DN
class SimpleSinWaveEffect {
    public var shader:SimpleSinWaveShader = new SimpleSinWaveShader();

    public function new()
    {  
    shader.iTime.value = [0];
    shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight]; 
    } 
    public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight]; 
    }
  
  }
  

class SimpleSinWaveShader extends FlxShader
{
  @:glFragmentSource('
  void main() 
  {   
       //for da fixes
      vec2 fragCoord = openfl_TextureCoordv * iResolution; 
      // Get the UV Coordinate of your texture or Screen Texture, yo!
      vec2 uv = fragCoord.xy / iResolution.xy;
      
      // Flip that shit, cause shadertool be all "yolo opengl"
      uv.y = -1.0 - uv.y;
      
      // Modify that X coordinate by the sin of y to oscillate back and forth up in this.
      uv.x += sin(uv.y*10.0+iTime)/10.0;
      
      // Get the pixel color at the index.
      vec4 color = (flixel_texture2D(bitmap,uv));
      
      gl_FragColor = color;
    }
 
  ') 
  public function new()
  {
    super();
  }

}