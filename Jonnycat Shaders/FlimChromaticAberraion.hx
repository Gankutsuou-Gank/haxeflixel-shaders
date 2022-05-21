 
// da code https://www.shadertoy.com/view/llK3RR
class FilmChromaticAberrationShader extends FlxShader
{ 
 @:glFragmentSource("
		#pragma header 
        uniform vec4 iMouse;  
        uniform vec2 iResolution; 

		// Given a vec2 in [-1,+1], generate a texture coord in [0,+1]
vec2 barrelDistortion( vec2 p, vec2 amt )
{
    p = 2.0 * p - 1.0;

    /*
    const float maxBarrelPower = 5.0;
	//note: http://glsl.heroku.com/e#3290.7 , copied from Little Grasshopper
    float theta  = atan(p.y, p.x);
    vec2 radius = vec2( length(p) );
    radius = pow(radius, 1.0 + maxBarrelPower * amt);
    p.x = radius.x * cos(theta);
    p.y = radius.y * sin(theta);

	/*/
    // much faster version
    //const float maxBarrelPower = 5.0;
    //float radius = length(p);
    float maxBarrelPower = sqrt(5.0);
    float radius = dot(p,p); //faster but doesn't match above accurately
    p *= pow(vec2(radius), maxBarrelPower * amt);
	/* */

    return p * 0.5 + 0.5;
}

//note: from https://www.shadertoy.com/view/MlSXR3
vec2 brownConradyDistortion(vec2 uv, float scalar)
{
// AH!!!    uv = uv * 2.0 - 1.0;
    uv = (uv - 0.5 ) * 2.0;
    
    if( true )
    {
        // positive values of K1 give barrel distortion, negative give pincushion
        float barrelDistortion1 = -0.02 * scalar; // K1 in text books
        float barrelDistortion2 = 0.0 * scalar; // K2 in text books

        float r2 = dot(uv,uv);
        uv *= 1.0 + barrelDistortion1 * r2 + barrelDistortion2 * r2 * r2;
        //uv *= 1.0 + barrelDistortion1 * r2;
    }
    
    // tangential distortion (due to off center lens elements)
    // is not modeled in this function, but if it was, the terms would go here
//    return uv * 0.5 + 0.5;
   return (uv / 2.0) + 0.5;
}

void main()
{   //don't delete
	vec2 uv = fragCoord.xy / iResolution.xy; 
    //for haxe 
    vec2 fragCoord = openfl_TextureCoordv * iResolution;

    float maxDistort = 4.0 * (1.0-iMouse.x/iResolution.x);

    float scalar = 1.0 * maxDistort;
//    vec4 colourScalar = vec4(2.0, 1.5, 1.0, 1.0);
    vec4 colourScalar = vec4(700.0, 560.0, 490.0, 1.0);	// Based on the true wavelengths of red, green, blue light.
    colourScalar /= max(max(colourScalar.x, colourScalar.y), colourScalar.z);
    colourScalar *= 2.0;
    
    colourScalar *= scalar;
    
    vec4 sourceCol = texture2D(bitmap, uv);

    const float numTaps = 8.0;
    
    
    gl_fragColor = vec4( 0.0 );
    for( float tap = 0.0; tap < numTaps; tap += 1.0 )
    {
        gl_fragColor.r += texture2D(bitmap, brownConradyDistortion(uv, colourScalar.r)).r;
        gl_fragColor.g += texture2D(bitmap, brownConradyDistortion(uv, colourScalar.g)).g;
        gl_fragColor.b += texture2D(bitmap, brownConradyDistortion(uv, colourScalar.b)).b;
        
        colourScalar *= 0.99;
    }
    
    gl_fragColor /= numTaps;
  
    gl_fragColor.a = 1.0;
}
		")
	public function new()
	{
		super();
	}
}
