#version 150

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
#include <LightShadowGPUTransform.h>
uniform vec4 CB0[52];
uniform vec4 CB8[24];
uniform sampler2D ShadowAtlasTexture;
uniform sampler3D LightMapTexture;
uniform sampler3D LightGridSkylightTexture;
uniform samplerCube PrefilteredEnvTexture;
uniform samplerCube PrefilteredEnvIndoorTexture;
uniform sampler2D PrecomputedBRDFTexture;
uniform sampler2D DiffuseMapTexture;

in vec2 VARYING0;
in vec4 VARYING2;
in vec4 VARYING3;
in vec4 VARYING4;
in vec4 VARYING5;
in vec4 VARYING6;
out vec4 _entryPointOutput;

void main()
{
    vec4 f0 = texture(DiffuseMapTexture, VARYING0) * VARYING2;
    vec3 f1 = normalize(VARYING5.xyz);
    vec3 f2 = -CB0[11].xyz;
    float f3 = dot(f1, f2);
    vec3 f4 = f0.xyz;
    vec3 f5 = VARYING6.xyz - (CB0[11].xyz * VARYING3.w);
    float f6 = clamp(dot(step(CB0[19].xyz, abs(VARYING3.xyz - CB0[18].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 f7 = VARYING3.yzx - (VARYING3.yzx * f6);
    vec4 f8 = vec4(clamp(f6, 0.0, 1.0));
    vec4 f9 = mix(texture(LightMapTexture, f7), vec4(0.0), f8);
    vec4 f10 = mix(texture(LightGridSkylightTexture, f7), vec4(1.0), f8);
    vec3 f11 = (f9.xyz * (f9.w * 120.0)).xyz;
    float f12 = f10.x;
    float f13 = f10.y;
    vec3 f14 = f5 - CB0[41].xyz;
    vec3 f15 = f5 - CB0[42].xyz;
    vec3 f16 = f5 - CB0[43].xyz;
    vec4 f17 = vec4(f5, 1.0) * mat4(CB8[((dot(f14, f14) < CB0[41].w) ? 0 : ((dot(f15, f15) < CB0[42].w) ? 1 : ((dot(f16, f16) < CB0[43].w) ? 2 : 3))) * 4 + 0], CB8[((dot(f14, f14) < CB0[41].w) ? 0 : ((dot(f15, f15) < CB0[42].w) ? 1 : ((dot(f16, f16) < CB0[43].w) ? 2 : 3))) * 4 + 1], CB8[((dot(f14, f14) < CB0[41].w) ? 0 : ((dot(f15, f15) < CB0[42].w) ? 1 : ((dot(f16, f16) < CB0[43].w) ? 2 : 3))) * 4 + 2], CB8[((dot(f14, f14) < CB0[41].w) ? 0 : ((dot(f15, f15) < CB0[42].w) ? 1 : ((dot(f16, f16) < CB0[43].w) ? 2 : 3))) * 4 + 3]);
    vec4 f18 = textureLod(ShadowAtlasTexture, f17.xy, 0.0);
    vec2 f19 = vec2(0.0);
    f19.x = CB0[45].z;
    vec2 f20 = f19;
    f20.y = CB0[45].w;
    float f21 = (2.0 * f17.z) - 1.0;
    float f22 = exp(CB0[45].z * f21);
    float f23 = -exp((-CB0[45].w) * f21);
    vec2 f24 = (f20 * CB0[46].y) * vec2(f22, f23);
    vec2 f25 = f24 * f24;
    float f26 = f18.x;
    float f27 = max(f18.y - (f26 * f26), f25.x);
    float f28 = f22 - f26;
    float f29 = f18.z;
    float f30 = max(f18.w - (f29 * f29), f25.y);
    float f31 = f23 - f29;
    float f32 = length(VARYING4.xyz);
    vec3 f33 = VARYING4.xyz / vec3(f32);
    vec3 f34 = (f4 * f4).xyz;
    float f35 = CB0[26].w * clamp(1.0 - (VARYING4.w * CB0[23].y), 0.0, 1.0);
    float f36 = max(VARYING5.w, 0.04500000178813934326171875);
    vec3 f37 = reflect(-f33, f1);
    float f38 = f36 * 5.0;
    vec3 f39 = vec4(f37, f38).xyz;
    vec4 f40 = texture(PrecomputedBRDFTexture, vec2(f36, max(9.9999997473787516355514526367188e-05, dot(f1, f33))));
    float f41 = VARYING6.w * f35;
    vec3 f42 = mix(vec3(0.039999999105930328369140625), f34, vec3(f41));
    vec3 f43 = normalize(f2 + f33);
    float f44 = clamp(f3 * ((f3 > 0.0) ? mix(f13, mix(min((f22 <= f26) ? 1.0 : clamp(((f27 / (f27 + (f28 * f28))) - 0.20000000298023223876953125) * 1.25, 0.0, 1.0), (f23 <= f29) ? 1.0 : clamp(((f30 / (f30 + (f31 * f31))) - 0.20000000298023223876953125) * 1.25, 0.0, 1.0)), f13, clamp((length(f5 - CB0[7].xyz) * CB0[45].y) - (CB0[45].x * CB0[45].y), 0.0, 1.0)), CB0[46].x) : 0.0), 0.0, 1.0);
    float f45 = f36 * f36;
    float f46 = max(0.001000000047497451305389404296875, dot(f1, f43));
    float f47 = dot(f2, f43);
    float f48 = 1.0 - f47;
    float f49 = f48 * f48;
    float f50 = (f49 * f49) * f48;
    vec3 f51 = vec3(f50) + (f42 * (1.0 - f50));
    float f52 = f45 * f45;
    float f53 = (((f46 * f52) - f46) * f46) + 1.0;
    float f54 = 1.0 - f41;
    float f55 = f35 * f54;
    vec3 f56 = vec3(f54);
    float f57 = f40.x;
    float f58 = f40.y;
    vec3 f59 = ((f42 * f57) + vec3(f58)) / vec3(f57 + f58);
    vec3 f60 = f56 - (f59 * f55);
    vec3 f61 = f1 * f1;
    bvec3 f62 = lessThan(f1, vec3(0.0));
    vec3 f63 = vec3(f62.x ? f61.x : vec3(0.0).x, f62.y ? f61.y : vec3(0.0).y, f62.z ? f61.z : vec3(0.0).z);
    vec3 f64 = f61 - f63;
    float f65 = f64.x;
    float f66 = f64.y;
    float f67 = f64.z;
    float f68 = f63.x;
    float f69 = f63.y;
    float f70 = f63.z;
    vec3 f71 = (mix(textureLod(PrefilteredEnvIndoorTexture, f39, f38).xyz * f11, textureLod(PrefilteredEnvTexture, f39, f38).xyz * mix(CB0[26].xyz, CB0[25].xyz, vec3(clamp(f37.y * 1.58823525905609130859375, 0.0, 1.0))), vec3(f12)) * f59) * f35;
    vec3 f72 = (((((((f56 - (f51 * f55)) * CB0[10].xyz) * f44) + (f60 * (((((((CB0[35].xyz * f65) + (CB0[37].xyz * f66)) + (CB0[39].xyz * f67)) + (CB0[36].xyz * f68)) + (CB0[38].xyz * f69)) + (CB0[40].xyz * f70)) + (((((((CB0[29].xyz * f65) + (CB0[31].xyz * f66)) + (CB0[33].xyz * f67)) + (CB0[30].xyz * f68)) + (CB0[32].xyz * f69)) + (CB0[34].xyz * f70)) * f12)))) + (CB0[27].xyz + (CB0[28].xyz * f12))) * f34) + (((f51 * (((f52 + (f52 * f52)) / (((f53 * f53) * ((f47 * 3.0) + 0.5)) * ((f46 * 0.75) + 0.25))) * f44)) * CB0[10].xyz) + f71)) + (f11 * mix(f34, f71 * (1.0 / (max(max(f71.x, f71.y), f71.z) + 0.00999999977648258209228515625)), (vec3(1.0) - f60) * (f35 * (1.0 - f12))));
    float f73 = f0.w;
    vec4 f74 = vec4(f72.x, f72.y, f72.z, vec4(0.0).w);
    f74.w = f73;
    float f75 = clamp(exp2((CB0[13].z * f32) + CB0[13].x) - CB0[13].w, 0.0, 1.0);
    vec3 f76 = textureLod(PrefilteredEnvTexture, vec4(-VARYING4.xyz, 0.0).xyz, max(CB0[13].y, f75) * 5.0).xyz;
    bvec3 f77 = bvec3(CB0[13].w != 0.0);
    vec3 f78 = sqrt(clamp(mix(vec3(f77.x ? CB0[14].xyz.x : f76.x, f77.y ? CB0[14].xyz.y : f76.y, f77.z ? CB0[14].xyz.z : f76.z), f74.xyz, vec3(f75)).xyz * CB0[15].y, vec3(0.0), vec3(1.0))) + vec3((-0.00048828125) + (0.0009765625 * fract(52.98291778564453125 * fract(dot(gl_FragCoord.xy, vec2(0.067110560834407806396484375, 0.005837149918079376220703125))))));
    vec4 f79 = vec4(f78.x, f78.y, f78.z, f74.w);
    f79.w = f73;
    _entryPointOutput = f79;
}

//$$ShadowAtlasTexture=s1
//$$LightMapTexture=s6
//$$LightGridSkylightTexture=s7
//$$PrefilteredEnvTexture=s15
//$$PrefilteredEnvIndoorTexture=s14
//$$PrecomputedBRDFTexture=s11
//$$DiffuseMapTexture=s3
