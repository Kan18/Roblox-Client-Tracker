#version 150

#extension GL_ARB_shading_language_include : require
#include <Globals.h>
#include <GridParam.h>
uniform vec4 CB0[52];
uniform vec4 CB3[1];
uniform sampler2D ShadowMapTexture;
uniform sampler3D LightMapTexture;
uniform sampler3D LightGridSkylightTexture;
uniform samplerCube PrefilteredEnvTexture;
uniform sampler2D DiffuseMapTexture;

in vec4 VARYING2;
in vec4 VARYING3;
in vec4 VARYING4;
in vec4 VARYING5;
in vec4 VARYING6;
in vec4 VARYING7;
out vec4 _entryPointOutput;

void main()
{
    vec3 f0 = (CB0[7].xyz - VARYING4.xyz) * CB3[0].x;
    vec3 f1 = abs(VARYING5.xyz);
    float f2 = f1.x;
    float f3 = f1.y;
    float f4 = f1.z;
    vec2 f5;
    if ((f2 >= f3) && (f2 >= f4))
    {
        f5 = f0.yz;
    }
    else
    {
        vec2 f6;
        if ((f3 >= f2) && (f3 >= f4))
        {
            f6 = f0.xz;
        }
        else
        {
            f6 = f0.xy;
        }
        f5 = f6;
    }
    vec4 f7 = texture(DiffuseMapTexture, f5) * VARYING2;
    vec3 f8 = f7.xyz;
    vec3 f9 = VARYING7.xyz - (CB0[11].xyz * VARYING3.w);
    float f10 = clamp(dot(step(CB0[19].xyz, abs(VARYING3.xyz - CB0[18].xyz)), vec3(1.0)), 0.0, 1.0);
    vec3 f11 = VARYING3.yzx - (VARYING3.yzx * f10);
    vec4 f12 = vec4(clamp(f10, 0.0, 1.0));
    vec4 f13 = mix(texture(LightMapTexture, f11), vec4(0.0), f12);
    vec4 f14 = mix(texture(LightGridSkylightTexture, f11), vec4(1.0), f12);
    vec4 f15 = texture(ShadowMapTexture, f9.xy);
    float f16 = f9.z;
    float f17 = (1.0 - ((step(f15.x, f16) * clamp(CB0[24].z + (CB0[24].w * abs(f16 - 0.5)), 0.0, 1.0)) * f15.y)) * f14.y;
    vec3 f18 = (((VARYING6.xyz * f17) + min((f13.xyz * (f13.w * 120.0)).xyz + (CB0[8].xyz + (CB0[9].xyz * f14.x)), vec3(CB0[16].w))) * (f8 * f8).xyz) + (CB0[10].xyz * ((VARYING6.w * f17) * 0.100000001490116119384765625));
    float f19 = f7.w;
    vec4 f20 = vec4(f18.x, f18.y, f18.z, vec4(0.0).w);
    f20.w = f19;
    float f21 = clamp(exp2((CB0[13].z * length(VARYING4.xyz)) + CB0[13].x) - CB0[13].w, 0.0, 1.0);
    vec3 f22 = textureLod(PrefilteredEnvTexture, vec4(-VARYING4.xyz, 0.0).xyz, max(CB0[13].y, f21) * 5.0).xyz;
    bvec3 f23 = bvec3(CB0[13].w != 0.0);
    vec3 f24 = sqrt(clamp(mix(vec3(f23.x ? CB0[14].xyz.x : f22.x, f23.y ? CB0[14].xyz.y : f22.y, f23.z ? CB0[14].xyz.z : f22.z), f20.xyz, vec3(f21)).xyz * CB0[15].y, vec3(0.0), vec3(1.0)));
    vec4 f25 = vec4(f24.x, f24.y, f24.z, f20.w);
    f25.w = f19;
    _entryPointOutput = f25;
}

//$$ShadowMapTexture=s1
//$$LightMapTexture=s6
//$$LightGridSkylightTexture=s7
//$$PrefilteredEnvTexture=s15
//$$DiffuseMapTexture=s3
