varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

uniform float speed;
uniform float frequency;
uniform float size;

void main()
{
    float Vertical_Wave     = sin(time * speed + v_vTexcoord.x * frequency) * (size * v_vTexcoord.y) ;  
    float Horizontal_Wave   = sin(time * speed + v_vTexcoord.y * frequency) * (size * v_vTexcoord.x) ;  
    vec4 distort = v_vColour * texture2D( gm_BaseTexture, vec2( v_vTexcoord.x + Horizontal_Wave  , v_vTexcoord.y + Vertical_Wave ) );
    gl_FragColor = distort;
}
