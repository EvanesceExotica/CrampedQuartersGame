shader_type canvas_item;

uniform float FROSTYNESS = 2.0;
uniform float COLORIZE = 1.0;
uniform vec4 COLOR_RGB : hint_color;
uniform sampler2D iChannel1;
uniform sampler2D iChannel0;
uniform vec2 lensRadius;// = vec2(0.65*1.5, 0.05);
// 0.7,1.0,1.0;

float rand(vec2 uv) {
 
    float a = dot(uv, vec2(92., 80.));
    float b = dot(uv, vec2(41., 62.));
    
    float x = sin(a) + cos(b) * 51.;
    return fract(x);
}

void fragment()
{
vec2 resolution = 1.0/SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	//vec2 uv = FRAGCOORD.xy / resolution.xy;
    vec4 d = texture(iChannel1, uv);
	vec2 rnd = vec2(rand(uv+d.r*.05), rand(uv+d.b*.05));
    
    //vignette
  //  const vec2 lensRadius 	= vec2(0.65*1.5, 0.05);
    float dist = distance(uv.xy, vec2(0.5,0.5));
    float vigfin = pow(1.-smoothstep(lensRadius.x, lensRadius.y, dist),2.0);
   
    rnd *= .025*vigfin+d.rg*FROSTYNESS*vigfin;
    uv += rnd;


    COLOR = mix(texture(SCREEN_TEXTURE, uv), vec4(COLOR_RGB),COLORIZE*vec4(rnd.r));
}