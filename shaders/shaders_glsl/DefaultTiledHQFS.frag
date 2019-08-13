#version 110

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

struct MaterialParams
{
    float textureTiling;
    float specularScale;
    float glossScale;
    float reflectionScale;
    float normalShadowScale;
    float specularLod;
    float glossLod;
    float normalDetailTiling;
    float normalDetailScale;
    float farTilingDiffuse;
    float farTilingNormal;
    float farTilingSpecular;
    float farDiffuseCutoff;
    float farNormalCutoff;
    float farSpecularCutoff;
    float optBlendColorK;
    float farDiffuseCutoffScale;
    float farNormalCutoffScale;
    float farSpecularCutoffScale;
    float isNonSmoothPlastic;
};

uniform vec4 CB0[32];
uniform vec4 CB2[5];
uniform sampler2D ShadowMapTexture;
uniform sampler3D LightMapTexture;
uniform sampler3D LightGridSkylightTexture;
uniform samplerCube EnvironmentMapTexture;
uniform sampler2D DiffuseMapTexture;
uniform sampler2D NormalMapTexture;
uniform sampler2D NormalDetailMapTexture;
uniform sampler2D StudsMapTexture;
uniform sampler2D SpecularMapTexture;

varying vec4 VARYING0;
varying vec4 VARYING1;
varying vec4 VARYING2;
varying vec4 VARYING3;
varying vec4 VARYING4;
varying vec4 VARYING5;
varying vec4 VARYING6;
varying vec4 VARYING7;
varying float VARYING8;

void main()
{
    vec2 _1788 = VARYING1.xy;
    _1788.y = (fract(VARYING1.y) + VARYING8) * 0.25;
    float _1222 = VARYING4.w * CB0[24].y;
    float _1234 = clamp(1.0 - _1222, 0.0, 1.0);
    vec2 _1266 = VARYING0.xy * CB2[0].x;
    vec4 _1273 = texture2D(DiffuseMapTexture, _1266);
    vec2 _1385 = texture2D(NormalMapTexture, _1266).wy * 2.0;
    vec2 _1387 = _1385 - vec2(1.0);
    float _1395 = sqrt(clamp(1.0 + dot(vec2(1.0) - _1385, _1387), 0.0, 1.0));
    vec2 _1300 = (vec3(_1387, _1395).xy + (vec3((texture2D(NormalDetailMapTexture, _1266 * CB2[1].w).wy * 2.0) - vec2(1.0), 0.0).xy * CB2[2].x)).xy * _1234;
    float _1306 = _1300.x;
    vec4 _1338 = texture2D(SpecularMapTexture, _1266);
    vec2 _1362 = mix(vec2(CB2[1].y, CB2[1].z), (_1338.xy * vec2(CB2[0].y, CB2[0].z)) + vec2(0.0, 0.00999999977648258209228515625), vec2(_1234));
    vec3 _1011 = normalize(((VARYING6.xyz * _1306) + (cross(VARYING5.xyz, VARYING6.xyz) * _1300.y)) + (VARYING5.xyz * _1395));
    vec3 _1015 = -CB0[11].xyz;
    float _1016 = dot(_1011, _1015);
    vec3 _1039 = vec4(((mix(vec3(1.0), VARYING2.xyz, vec3(clamp(_1273.w + CB2[3].w, 0.0, 1.0))) * _1273.xyz) * (1.0 + (_1306 * CB2[1].x))) * (texture2D(StudsMapTexture, _1788).x * 2.0), VARYING2.w).xyz;
    vec3 _1427 = vec3(CB0[15].x);
    float _1529 = clamp(dot(step(CB0[20].xyz, abs(VARYING3.xyz - CB0[19].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 _1473 = VARYING3.yzx - (VARYING3.yzx * _1529);
    vec4 _1483 = vec4(clamp(_1529, 0.0, 1.0));
    vec4 _1484 = mix(texture3D(LightMapTexture, _1473), vec4(0.0), _1483);
    vec4 _1489 = mix(texture3D(LightGridSkylightTexture, _1473), vec4(1.0), _1483);
    vec4 _1539 = texture2D(ShadowMapTexture, VARYING7.xy);
    float _1552 = (1.0 - ((step(_1539.x, VARYING7.z) * clamp(CB0[25].z + (CB0[25].w * abs(VARYING7.z - 0.5)), 0.0, 1.0)) * _1539.y)) * _1489.y;
    vec3 _1058 = textureCube(EnvironmentMapTexture, reflect(-VARYING4.xyz, _1011)).xyz;
    vec3 _1107 = ((min(((_1484.xyz * (_1484.w * 120.0)).xyz + CB0[8].xyz) + (CB0[9].xyz * _1489.x), vec3(CB0[17].w)) + (((CB0[10].xyz * clamp(_1016, 0.0, 1.0)) + (CB0[12].xyz * max(-_1016, 0.0))) * _1552)) * mix(mix(_1039, _1039 * _1039, _1427).xyz, mix(_1058, (_1058 * _1058) * CB0[15].w, _1427), vec3((_1338.y * _1234) * CB2[0].w)).xyz) + (CB0[10].xyz * (((step(0.0, _1016) * _1362.x) * _1552) * pow(clamp(dot(_1011, normalize(_1015 + normalize(VARYING4.xyz))), 0.0, 1.0), _1362.y)));
    vec4 _1815 = vec4(_1107.x, _1107.y, _1107.z, vec4(0.0).w);
    _1815.w = VARYING2.w;
    vec2 _1132 = min(VARYING0.wz, VARYING1.wz);
    float _1139 = min(_1132.x, _1132.y) / _1222;
    vec3 _1163 = (_1815.xyz * clamp((clamp((_1222 * CB0[25].x) + CB0[25].y, 0.0, 1.0) * (1.5 - _1139)) + _1139, 0.0, 1.0)).xyz;
    vec3 _1660 = mix(CB0[14].xyz, mix(_1163, sqrt(clamp(_1163 * CB0[15].z, vec3(0.0), vec3(1.0))) + vec3((-0.00048828125) + (0.0009765625 * fract(52.98291778564453125 * fract(dot(gl_FragCoord.xy, vec2(0.067110560834407806396484375, 0.005837149918079376220703125)))))), _1427).xyz, vec3(clamp((CB0[13].x * length(VARYING4.xyz)) + CB0[13].y, 0.0, 1.0)));
    gl_FragData[0] = vec4(_1660.x, _1660.y, _1660.z, _1815.w);
}

//$$ShadowMapTexture=s1
//$$LightMapTexture=s6
//$$LightGridSkylightTexture=s7
//$$EnvironmentMapTexture=s2
//$$DiffuseMapTexture=s3
//$$NormalMapTexture=s4
//$$NormalDetailMapTexture=s8
//$$StudsMapTexture=s0
//$$SpecularMapTexture=s5
