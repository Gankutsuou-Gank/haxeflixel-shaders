package; 

import flixel.system.FlxAssets.FlxShader; 
 // da code https://www.shadertoy.com/view/3sGGRz
class FilmGrainEffect 
{ 
    public var shader:FilmGrainShader = new FilmGrainShader();
    public function new(){
     shader.iTime.value = [0];
    }
      
    public function update(elapsed:Float):Void
    {
      shader.iTime.value[0] += elapsed;
    }
}


class FilmGrainShader extends FlxShader
{
  @:glFragmentSource('
    #pragma header
    uniform float iTime 
    void main()
    {
        // Normalized pixel coordinates (from 0 to 1)
        vec2 uv = openfl_TextureCoordv;
        // Calculate noise and sample texture
        float mdf = 0.1; // increase for noise amount 
        float noise = (fract(sin(dot(uv, vec2(12.9898,78.233)*2.0)) * 43758.5453));
        vec4 tex = flixel_texture2D(bitmap, uv);
        //animate the effects strength
        mdf *= sin(iTime) + 1.0; 
        
        vec4 col = tex - noise * mdf;
    
        // Output to screen
        gl_fragColor = col;
    }
      ')
  public function new()
  {
    super();
  }

}