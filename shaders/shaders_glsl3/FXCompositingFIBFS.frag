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
uniform sampler2D Texture2Texture;
uniform sampler2D Texture3Texture;

in vec2 VARYING0;
out vec4 _entryPointOutput;

void main()
{
    vec3 _218 = texture(Texture0Texture, VARYING0).xyz;
    vec3 _228 = texture(Texture3Texture, VARYING0).xyz;
    vec3 _252 = texture(Texture2Texture, VARYING0).xyz * CB1[4].w;
    _entryPointOutput = vec4(sqrt(clamp(((((_218 * _218) * 4.0) + ((_228 * _228) * 4.0)) + (_252 * _252)) * 0.25, vec3(0.0), vec3(1.0))), 1.0);
}

//$$Texture0Texture=s0
//$$Texture2Texture=s2
//$$Texture3Texture=s3
