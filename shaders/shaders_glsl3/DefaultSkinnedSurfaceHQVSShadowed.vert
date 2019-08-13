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

uniform vec4 CB0[32];
uniform vec4 CB1[216];
in vec4 POSITION;
in vec4 NORMAL;
in vec2 TEXCOORD0;
in vec2 TEXCOORD1;
in vec4 COLOR0;
in vec4 COLOR1;
in vec4 TEXCOORD2;
in vec4 TEXCOORD3;
out vec4 VARYING0;
out vec4 VARYING1;
out vec4 VARYING2;
out vec4 VARYING3;
out vec4 VARYING4;
out vec4 VARYING5;
out vec4 VARYING6;
out vec4 VARYING7;
out float VARYING8;

void main()
{
    vec3 _471 = (NORMAL.xyz * 0.0078740157186985015869140625) - vec3(1.0);
    vec3 _483 = (TEXCOORD2.xyz * 0.0078740157186985015869140625) - vec3(1.0);
    int _488 = int(COLOR1.x) * 3;
    int _494 = _488 + 1;
    int _499 = _488 + 2;
    float _504 = dot(CB1[_488 * 1 + 0], POSITION);
    float _507 = dot(CB1[_494 * 1 + 0], POSITION);
    float _510 = dot(CB1[_499 * 1 + 0], POSITION);
    vec3 _511 = vec3(_504, _507, _510);
    float _515 = dot(CB1[_488 * 1 + 0].xyz, _471);
    float _519 = dot(CB1[_494 * 1 + 0].xyz, _471);
    float _523 = dot(CB1[_499 * 1 + 0].xyz, _471);
    vec3 _537 = vec3(dot(CB1[_488 * 1 + 0].xyz, _483), dot(CB1[_494 * 1 + 0].xyz, _483), dot(CB1[_499 * 1 + 0].xyz, _483));
    vec4 _777 = vec4(0.0);
    _777.w = (TEXCOORD2.w * 0.0078740157186985015869140625) - 1.0;
    vec4 _573 = vec4(_504, _507, _510, 1.0);
    vec4 _576 = _573 * mat4(CB0[0], CB0[1], CB0[2], CB0[3]);
    vec4 _581 = vec4(TEXCOORD0, 0.0, 0.0);
    vec4 _586 = vec4(TEXCOORD1, 0.0, 0.0);
    float _612 = _576.w;
    vec4 _629 = ((exp2(TEXCOORD3 * 0.0625) - vec4(1.0)) * CB0[24].z) + vec4((0.5 * _612) * CB0[24].y);
    vec4 _783 = vec4(dot(CB0[21], _573), dot(CB0[22], _573), dot(CB0[23], _573), 0.0);
    _783.w = COLOR1.w * 0.0039215688593685626983642578125;
    gl_Position = _576;
    VARYING0 = vec4(_581.x, _581.y, _629.x, _629.y);
    VARYING1 = vec4(_586.x, _586.y, _629.z, _629.w);
    VARYING2 = COLOR0;
    VARYING3 = vec4(((_511 + (vec3(_515, _519, _523) * 6.0)).yxz * CB0[17].xyz) + CB0[18].xyz, 0.0);
    VARYING4 = vec4(CB0[7].xyz - _511, _612);
    VARYING5 = vec4(_515, _519, _523, COLOR1.z);
    VARYING6 = vec4(_537.x, _537.y, _537.z, _777.w);
    VARYING7 = _783;
    VARYING8 = NORMAL.w;
}

