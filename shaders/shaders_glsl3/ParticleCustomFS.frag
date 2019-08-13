#version 150

struct Globals
{
    mat4 ViewProjection;
    vec4 ViewRight;
    vec4 ViewUp;
    vec4 ViewDir;
    vec3 CameraPosition;
    vec3 AmbientColor;
    vec3 SkyAmbient;
    vec3 Lamp0Color;
    vec3 Lamp0Dir;
    vec3 Lamp1Color;
    vec4 FogParams;
    vec4 FogColor_GlobalForceFieldTime;
    vec4 Technology_Exposure;
    vec4 LightBorder;
    vec4 LightConfig0;
    vec4 LightConfig1;
    vec4 LightConfig2;
    vec4 LightConfig3;
    vec4 ShadowMatrix0;
    vec4 ShadowMatrix1;
    vec4 ShadowMatrix2;
    vec4 RefractionBias_FadeDistance_GlowFactor_SpecMul;
    vec4 OutlineBrightness_ShadowInfo;
    vec4 CascadeSphere0;
    vec4 CascadeSphere1;
    vec4 CascadeSphere2;
    vec4 CascadeSphere3;
    float hybridLerpDist;
    float hybridLerpSlope;
    float evsmPosExp;
    float evsmNegExp;
    float globalShadow;
    float shadowBias;
    float shadowAlphaRef;
    float debugFlagsShadows;
};

struct EmitterParams
{
    vec4 ModulateColor;
    vec4 Params;
    vec4 AtlasParams;
};

uniform vec4 CB0[32];
uniform vec4 CB1[3];
uniform sampler2D LightingAtlasTexture;
uniform sampler2D texTexture;

in vec3 VARYING0;
in vec4 VARYING1;
in vec2 VARYING2;
out vec4 _entryPointOutput;

void main()
{
    vec4 _253 = texture(texTexture, VARYING0.xy);
    vec3 _266 = (_253.xyz * VARYING1.xyz).xyz;
    vec3 _322 = vec3(CB0[15].x);
    vec4 _332 = texture(LightingAtlasTexture, VARYING2);
    vec3 _274 = mix(_266, _266 * _266, _322).xyz;
    vec3 _286 = mix(_274, (_332.xyz * (_332.w * 120.0)) * _274, vec3(CB1[2].w)).xyz;
    float _300 = (VARYING1.w * _253.w) * clamp(VARYING0.z, 0.0, 1.0);
    vec3 _306 = mix(_286, sqrt(clamp(_286 * CB0[15].z, vec3(0.0), vec3(1.0))), _322).xyz * _300;
    vec4 _394 = vec4(_306.x, _306.y, _306.z, vec4(0.0).w);
    _394.w = _300 * CB1[1].y;
    _entryPointOutput = _394;
}

//$$LightingAtlasTexture=s2
//$$texTexture=s0
