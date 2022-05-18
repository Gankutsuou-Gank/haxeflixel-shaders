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
//da code https://www.shadertoy.com/view/WsVSzV
class FastCRTEffect 
{
    public var shader(default, null):FastCRTShader = new FastCRTShader();

    public var warp(default, set):Float = 0.75;
    public var scan(default, set):Float = 0.75;

    function set_scanlol(value:Float):Float {
		scanlol = value;
        shader.scan.value = [value];
        return value;
	}

	function set_warplol(value:Float):Float {
		warplol = value;
        shader.warp.value = [value];
        return value;
	}
    public function update(elapsed:Float){
        shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
    }
    public function new() {
        shader.warp.value = [0.75];
        shader.scan.value = [0.75];
        shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
    }
}

class FastCRTShader extends FlxShader
{ //NOTE: DONT ADD VALUES TO uRadius or uSmoothness IN GLFRAGMENTSOURCE!!!!!!!!!!!! DO IT VIA SET FUNCTIONS INSTEAD
    @:glFragmentSource('
    #pragma header 
    uniform vec2 iResolution;  
    uniform float warp; // simulate curvature of CRT monitor
    unifrom float scan; // simulate darkness between scanlines

void main()
	{  
    //its for haxe
    vec2 fragCoord = openfl_TextureCoordv * iResolution;
    // squared distance from center
    vec2 uv = fragCoord/iResolution.xy;
    vec2 dc = abs(0.5-uv);
    dc *= dc;
    
    // warp the fragment coordinates
    uv.x -= 0.5; uv.x *= 1.0+(dc.y*(0.3*warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0+(dc.x*(0.4*warp)); uv.y += 0.5;

    // sample inside boundaries, otherwise set to black
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
        gl_fragColor = vec4(0.0,0.0,0.0,1.0);
    else
    	{
        // determine if we are drawing in a scanline
        float apply = abs(sin(fragCoord.y)*0.5*scan);
        // sample the texture
    	gl_fragColor = vec4(mix(texture2D(bitmap,uv).rgb,vec3(0.0),apply),1.0);
        }
	}
   ')
    
    public function new() {
        super();
    }
}