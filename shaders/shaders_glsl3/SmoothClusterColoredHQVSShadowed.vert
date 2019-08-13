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
uniform vec4 CB2[74];
uniform vec4 CB1[1];
uniform vec4 CB4[36];
in vec4 POSITION;
in vec4 NORMAL;
in vec4 TEXCOORD0;
in vec4 TEXCOORD1;
out vec3 VARYING0;
out vec4 VARYING1;
out vec4 VARYING2;
out vec4 VARYING3;
out vec4 VARYING4;
out vec3 VARYING5;
out vec3 VARYING6;
out vec4 VARYING7;
out vec3 VARYING8;
out vec4 VARYING9;

void main()
{
    vec3 _529 = (POSITION.xyz * CB1[0].w) + CB1[0].xyz;
    vec3 _535 = (NORMAL.xyz * 0.0078740157186985015869140625) - vec3(1.0);
    vec4 _540 = vec4(_529, 1.0);
    vec4 _543 = _540 * mat4(CB0[0], CB0[1], CB0[2], CB0[3]);
    vec4 _1017 = _543;
    _1017.z = _543.z - (float(POSITION.w < 0.0) * 0.00200000009499490261077880859375);
    vec3 _559 = CB0[7].xyz - _529;
    int _728 = int(TEXCOORD1.x);
    int _741 = 36 + int(TEXCOORD0.x);
    vec2 _753 = vec2(dot(_529, CB2[_728 * 1 + 0].xyz), dot(_529, CB2[(18 + _728) * 1 + 0].xyz)) * CB2[_741 * 1 + 0].x;
    float _759 = ((NORMAL.w * 0.0078125) - 1.0) * CB2[_741 * 1 + 0].z;
    int _799 = int(TEXCOORD1.y);
    int _812 = 36 + int(TEXCOORD0.y);
    vec2 _824 = vec2(dot(_529, CB2[_799 * 1 + 0].xyz), dot(_529, CB2[(18 + _799) * 1 + 0].xyz)) * CB2[_812 * 1 + 0].x;
    float _830 = ((TEXCOORD0.w * 0.0078125) - 1.0) * CB2[_812 * 1 + 0].z;
    int _870 = int(TEXCOORD1.z);
    int _883 = 36 + int(TEXCOORD0.z);
    vec2 _895 = vec2(dot(_529, CB2[_870 * 1 + 0].xyz), dot(_529, CB2[(18 + _870) * 1 + 0].xyz)) * CB2[_883 * 1 + 0].x;
    float _901 = ((TEXCOORD1.w * 0.0078125) - 1.0) * CB2[_883 * 1 + 0].z;
    bvec3 _628 = equal(abs(POSITION.www), vec3(1.0, 2.0, 3.0));
    vec3 _629 = vec3(_628.x ? vec3(1.0).x : vec3(0.0).x, _628.y ? vec3(1.0).y : vec3(0.0).y, _628.z ? vec3(1.0).z : vec3(0.0).z);
    bvec3 _647 = greaterThan(TEXCOORD1.xyz, vec3(7.5));
    gl_Position = _1017;
    VARYING0 = _629;
    VARYING1 = vec4(((_753 * sqrt(1.0 - (_759 * _759))) + (_753.yx * vec2(_759, -_759))) + (vec2(NORMAL.w, floor(NORMAL.w * 2.6651442050933837890625)) * CB2[_741 * 1 + 0].y), ((_824 * sqrt(1.0 - (_830 * _830))) + (_824.yx * vec2(_830, -_830))) + (vec2(TEXCOORD0.w, floor(TEXCOORD0.w * 2.6651442050933837890625)) * CB2[_812 * 1 + 0].y));
    VARYING2 = vec4(TEXCOORD0.x, 0.0, TEXCOORD0.y, 0.0);
    VARYING3 = vec4(((_895 * sqrt(1.0 - (_901 * _901))) + (_895.yx * vec2(_901, -_901))) + (vec2(TEXCOORD1.w, floor(TEXCOORD1.w * 2.6651442050933837890625)) * CB2[_883 * 1 + 0].y), TEXCOORD0.z, 0.0);
    VARYING4 = vec4(((_529 + (_535 * 6.0)).yxz * CB0[17].xyz) + CB0[18].xyz, (CB0[13].x * length(_559)) + CB0[13].y);
    VARYING5 = vec3(dot(CB0[21], _540), dot(CB0[22], _540), dot(CB0[23], _540));
    VARYING6 = _535;
    VARYING7 = vec4(_559, _543.w);
    VARYING8 = vec3(_647.x ? vec3(1.0).x : vec3(0.0).x, _647.y ? vec3(1.0).y : vec3(0.0).y, _647.z ? vec3(1.0).z : vec3(0.0).z);
    VARYING9 = ((CB4[int(TEXCOORD0.x + 0.5) * 1 + 0] * _629.x) + (CB4[int(TEXCOORD0.y + 0.5) * 1 + 0] * _629.y)) + (CB4[int(TEXCOORD0.z + 0.5) * 1 + 0] * _629.z);
}

