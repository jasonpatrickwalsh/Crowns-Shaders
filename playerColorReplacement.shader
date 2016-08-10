 Shader "Custom/playerColorReplacement"
 {  
     Properties
     {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _Palette ("Palette", 2D) = "white" {}
        _Color ("Alpha Color Key", Color) = (0,0,0,1)
        _GreyABase ("Grey 1 Base", Color) = (0,0,0,1)
        _GreyBBase ("Grey 2 Base", Color) = (0,0,0,1)
        _GreyCBase ("Grey 3 Base", Color) = (0,0,0,1)
        _GreyAReplace ("Grey 1 Replace", Color) = (0,0,0,1)
        _GreyBReplace ("Grey 2 Replace", Color) = (0,0,0,1)
        _GreyCBReplace ("Grey 3 Replace", Color) = (0,0,0,1)
     }
     SubShader
     {
         Tags 
         { 
             "RenderType" = "Opaque" 
             "Queue" = "Transparent+1" 
         }
 
         Pass
         {
             ZWrite Off
             Blend SrcAlpha OneMinusSrcAlpha 
  
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             #pragma multi_compile DUMMY PIXELSNAP_ON
  
             sampler2D _MainTex;
             sampler2D _Palette;
             half4 _Color;
             half4 _GreyABase;
             half4 _GreyBBase;
             half4 _GreyAReplace;
             half4 _GreyBReplace;
 
             struct Vertex
             {
                 float4 vertex : POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float2 uv2 : TEXCOORD1;
             };
     
             struct Fragment
             {
                 float4 vertex : POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float2 uv2 : TEXCOORD1;
             };
  
             Fragment vert(Vertex v)
             {
                 Fragment o;
     
                 o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
                 o.uv_MainTex = v.uv_MainTex;
                 o.uv2 = v.uv2;
     
                 return o;
             }
                                                     
             float4 frag(Fragment IN) : COLOR
             {
                 float4 o = float4(1, 1, 1, 1);
 
                 half4 c = tex2D (_MainTex, IN.uv_MainTex);
                 half4 t1 = tex2D (_Palette, (0,0.5));
                 half4 t2 = tex2D (_Palette, (0,1));
                 half4 t3 = tex2D (_Palette, (0,0));
                 o.rgb = c.rgb;
                 
                 if(c.r == _Color.r && c.g == _Color.g && c.b == _Color.b)
                 {
                     o.a = 0;
                 }
                 else
                 {
                     o.a = 1;
                 }
                 
                 if(c.r > 0.5 && c.b < 0.5)//red base
                 {
                 	o.rgb = t1.rgb;
                 }
                 if(c.b > 0.5 && c.r < 0.5)//blue base
                 {
                 	o.rgb = t3.rgb;
                 }
                 if(c.b > 0.7 && c.r >0.7)//white base
                 {
                 	o.rgb = t2.rgb;
                 }
                 
                     
                 return o;
             }
 
             ENDCG
         }
     }
 }