#version 110

struct Params
{
    vec4 TextureSize;
    vec4 Params1;
    vec4 Params2;
    vec4 Params3;
    vec4 Params4;
    vec4 Params5;
    vec4 Params6;
    vec4 Bloom;
};

uniform vec4 CB1[8];
uniform sampler2D Texture0Texture;
uniform sampler2D Texture2Texture;
uniform sampler2D Texture3Texture;

varying vec2 VARYING0;

void main()
{
    vec4 _175 = texture2D(Texture0Texture, VARYING0);
    vec3 _179 = texture2D(Texture2Texture, VARYING0).xyz;
    vec4 _182 = texture2D(Texture3Texture, VARYING0);
    float _186 = 1.0 - _182.w;
    vec3 _192 = _175.xyz;
    vec3 _222 = (_179 + (min(vec3(1.0), (_182.xyz * CB1[4].y) + (_192 * _186)).xyz * (vec3(1.0) - _179))).xyz + (_192 * (clamp(_186 - _175.w, 0.0, 1.0) * _186));
    gl_FragData[0] = clamp(vec4(_222.x, _222.y, _222.z, _175.w), vec4(0.0), vec4(1.0));
}

//$$Texture0Texture=s0
//$$Texture2Texture=s2
//$$Texture3Texture=s3
