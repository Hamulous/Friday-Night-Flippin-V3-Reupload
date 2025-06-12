package shaders;

import flixel.system.FlxAssets.FlxShader;

class BloomShader extends FlxShader //Shader Written By https://twitter.com/dvnomnom (Thx Buddy :D)
{
    public var shaderblurSize:Float = 1.0/512.0;
    public var shaderintensity:Float = 0.35;

    @:glFragmentSource('
        #pragma header

        vec2 uv = openfl_TextureCoordv.xy;
        vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
        vec2 iResolution = openfl_TextureSize;
        uniform float iTime;
        #define iChannel0 bitmap
        #define texture flixel_texture2D
        #define fragColor gl_FragColor
        #define mainImage main

        uniform float blurSize;
        uniform float intensity;

        void main()
        {
            vec4 sum = vec4(0);
            vec2 texcoord = fragCoord.xy/iResolution.xy;
            int j;
            int i;

            sum += texture(bitmap, vec2(texcoord.x - 4.0*blurSize, texcoord.y)) * 0.05;
            sum += texture(bitmap, vec2(texcoord.x - 3.0*blurSize, texcoord.y)) * 0.09;
            sum += texture(bitmap, vec2(texcoord.x - 2.0*blurSize, texcoord.y)) * 0.12;

            sum += texture(bitmap, vec2(texcoord.x, texcoord.y - 4.0*blurSize)) * 0.05;
            sum += texture(bitmap, vec2(texcoord.x, texcoord.y - 3.0*blurSize)) * 0.09;

            fragColor = sum*intensity + texture(bitmap, texcoord);
        }
    ')

    public function new()
    {
        data.intensity.value = shaderintensity;
		data.blurSize.value = shaderblurSize;
        super();
    }
}