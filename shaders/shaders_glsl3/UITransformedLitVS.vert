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

struct UIParams
{
    vec4 Normal;
    mat4 Transform;
};

uniform vec4 CB0[32];
uniform vec4 CB1[5];
uniform vec4 CB2[1];
in vec4 POSITION;
in vec2 TEXCOORD0;
in vec4 COLOR0;
out vec2 VARYING0;
out vec4 VARYING1;
out vec3 VARYING2;
out vec3 VARYING3;
out vec3 VARYING4;

void main()
{
    vec4 _264 = POSITION * mat4(CB1[1], CB1[2], CB1[3], CB1[4]);
    vec4 _268 = _264 * mat4(CB0[0], CB0[1], CB0[2], CB0[3]);
    vec4 _399 = _268;
    _399.z = _268.z - CB2[0].x;
    float _289 = dot(CB1[0].xyz, -CB0[11].xyz);
    vec4 _343 = vec4(_264.xyz, 1.0);
    gl_Position = _399;
    VARYING0 = TEXCOORD0;
    VARYING1 = COLOR0;
    VARYING2 = (CB0[10].xyz * clamp(_289, 0.0, 1.0)) + (CB0[12].xyz * clamp(-_289, 0.0, 1.0));
    VARYING3 = ((_264.xyz + (CB1[0].xyz * 6.0)).yxz * CB0[17].xyz) + CB0[18].xyz;
    VARYING4 = vec3(dot(CB0[21], _343), dot(CB0[22], _343), dot(CB0[23], _343));
}

