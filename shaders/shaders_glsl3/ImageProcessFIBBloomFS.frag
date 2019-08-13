#version 150

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
uniform sampler2D Texture3Texture;

in vec2 VARYING0;
out vec4 _entryPointOutput;

void main()
{
    vec3 _275 = texture(Texture0Texture, VARYING0).xyz;
    vec3 _280 = texture(Texture3Texture, VARYING0).xyz;
    vec3 _315 = ((_275 * _275) * 4.0) + ((_280 * _280) * 4.0);
    vec3 _357 = _315 * CB1[5].x;
    vec3 _375 = ((_315 * (_357 + vec3(CB1[5].y))) / ((_315 * (_357 + vec3(CB1[5].z))) + vec3(CB1[5].w))) * CB1[6].x;
    _entryPointOutput = vec4(dot(_375, CB1[1].xyz) + CB1[1].w, dot(_375, CB1[2].xyz) + CB1[2].w, dot(_375, CB1[3].xyz) + CB1[3].w, 1.0);
}

//$$Texture0Texture=s0
//$$Texture3Texture=s3
