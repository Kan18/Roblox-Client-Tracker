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

in vec2 VARYING0;
out vec4 _entryPointOutput;

void main()
{
    float _222 = 1.0 / ((2.0 * CB1[1].z) * CB1[1].z);
    float _237 = float((2 * 0) + 1);
    float _253 = exp((((-1.0) - _237) * (_237 + 1.0)) * _222);
    float _256 = exp(((-_237) * _237) * _222) + _253;
    vec2 _266 = CB1[1].xy * (_237 + (_253 / _256));
    int _286 = 0 + 1;
    float _316 = float((2 * _286) + 1);
    float _325 = exp((((-1.0) - _316) * (_316 + 1.0)) * _222);
    float _326 = exp(((-_316) * _316) * _222) + _325;
    vec2 _329 = CB1[1].xy * (_316 + (_325 / _326));
    float _348 = float((2 * (_286 + 1)) + 1);
    float _357 = exp((((-1.0) - _348) * (_348 + 1.0)) * _222);
    float _358 = exp(((-_348) * _348) * _222) + _357;
    vec2 _361 = CB1[1].xy * (_348 + (_357 / _358));
    _entryPointOutput = (((texture(Texture0Texture, VARYING0) + ((texture(Texture0Texture, VARYING0 + _266) + texture(Texture0Texture, VARYING0 - _266)) * _256)) + ((texture(Texture0Texture, VARYING0 + _329) + texture(Texture0Texture, VARYING0 - _329)) * _326)) + ((texture(Texture0Texture, VARYING0 + _361) + texture(Texture0Texture, VARYING0 - _361)) * _358)) / vec4(((1.0 + (2.0 * _256)) + (2.0 * _326)) + (2.0 * _358));
}

//$$Texture0Texture=s0
