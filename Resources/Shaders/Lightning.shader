shader_type canvas_item;

uniform float time;
uniform vec2 resolution;
const float count = 7.0;

float Hash (vec2 p, in float s){
	return fract(sin(dot(vec3(p.xy, 10.0 * abs(sin(s))), vec3(27.1, 61.7, 12.4)))*273758.5453123);
}

float noise(in vec2 p, in float s){
	vec2 i = floor(p);
	vec2 f = fract(p);
	f *= f * (3.0-2.0*f);
	return mix(mix(Hash(i + vec2(0.0, 0.0),s), Hash(i+vec2(1.0, 0.1), s ), f.x), mix (Hash(i+vec2(0.0,1.0), s), Hash(i+ vec2(1.0, 0.0),s Hash(i+vec2(1.0, 1.0), s, f.y) * s;
}
float fbm(vec2 p){
	float v= 0.0;
	v+= noise(p*1.0, 0.35);
	v+= noise(p*2.0, 0.25);
	v+= noise(p*4.0, 0.125);
	v+= noise(p*8.0, 0.0625);
	return v;
}

void fragment(){
	vec2 uv = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
	finalColor += t* vec3(0.357 + 0.1, 0.5, 2.0);
	
	gl_FragColor = vec4(finalColor, 1.0);
}
}