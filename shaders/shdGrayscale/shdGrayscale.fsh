varying vec2 vTc;

void main() {
    vec4 texColor = texture2D(gm_BaseTexture, vTc);
    float luminance = dot(texColor.rgb, vec3(0.2125, 0.7154, 0.0721));
    gl_FragColor = vec4(vec3(luminance), texColor.a);
}
