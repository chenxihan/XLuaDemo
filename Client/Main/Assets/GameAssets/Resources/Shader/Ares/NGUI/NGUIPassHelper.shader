// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Ares/Base/NGUIPassHelper"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}		
		_AlphaTex ("Alpha (R)", 2D) = "white" {}	
	}
	
	CGINCLUDE
		#include "FuncellNGUICG.cginc"
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_TexelSize;
		#if defined(_USE_ALPHA_TEX_ON)
		//Alpha贴图
		uniform sampler2D _AlphaTex;
		#endif
		
		struct appdata_t
		{
			float4 vertex : POSITION;
			half4 color : COLOR;
			half2 texcoord : TEXCOORD0;
			half2 texcoord1 : TEXCOORD1;
		};

		struct v2f
		{
			float4 vertex : POSITION;
			half4 color : COLOR;
			half4 texcoord : TEXCOORD0;
			FUNCELL_CLIP_1_COORD(1)
			FUNCELL_CLIP_2_COORD(2)
			FUNCELL_CLIP_3_COORD(3)
			FUNCELL_TEXTURE_CLIP_COORD(4)		
			FUNCELL_UI_FLOW_LIGHT_COORD(5)
		};
		
		v2f vert (appdata_t v)
		{
			v2f o = (v2f)0;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.color = v.color;
			o.texcoord.xy = v.texcoord;
			
			FUNCELL_TRANSFER_CLIP_1(v,o)
			FUNCELL_TRANSFER_CLIP_2(v,o)
			FUNCELL_TRANSFER_CLIP_3(v,o)
			FUNCELL_TRANSFER_TEXTURE_CLIP(v,o)
			//FUNCELL_TRANSFER_UI_FLOW_LIGHT(v,o)	
			return o;
		}
		
		fixed4 frag (v2f IN) : COLOR
		{
			FUNCELL_APPLY_CLIP_1(IN)
			FUNCELL_APPLY_CLIP_2(IN)
			FUNCELL_APPLY_CLIP_3(IN)			
	
			#if defined(_USE_ALPHA_TEX_ON)
				fixed4 mainTex =fixed4(tex2D(_MainTex, IN.texcoord).rgb,tex2D(_AlphaTex, IN.texcoord).r);
			#else
				fixed4 mainTex = tex2D(_MainTex, IN.texcoord);
			#endif
			
			//处理clip的颜色
			FUNCELL_APPLY_CLIP_COLOR(IN,mainTex)
			
			//流光颜色
			FUNCELL_APPLY_UI_FLOW_LIGHT(IN,mainTex)
			
			//处理灰色颜色			
			#if defined(_USE_GRAY_ON) 
			fixed grey = dot(mainTex.rgb, fixed3(0.299, 0.587, 0.114));
			mainTex.rgb = fixed3(grey, grey, grey);
			#endif	
			return mainTex;			
		}
	ENDCG

	SubShader
	{		
		Cull Off
		Lighting Off
		ZWrite Off
		AlphaTest Off
		Fog { Mode Off }
		Offset -1, -1
		ColorMask RGB		
		
		//Transparent Color的Pass列表
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&T"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_TEXTURE_CLIP_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&1"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_CLIP_1_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&2"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_CLIP_2_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&3"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_CLIP_3_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON
			ENDCG
		}
		
		//Transparent Color 带有AlphaTex的Pass列表
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&ALPHATEX"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_ALPHA_TEX_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&T&ALPHATEX"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_TEXTURE_CLIP_ON	
			#pragma multi_compile _USE_ALPHA_TEX_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&1&ALPHATEX"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_CLIP_1_ON
			#pragma multi_compile _USE_ALPHA_TEX_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&2&ALPHATEX"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_CLIP_2_ON
			#pragma multi_compile _USE_ALPHA_TEX_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		Pass
		{
			//transparent colored
		    Name "NGUI&TRANSPARENT&3&ALPHATEX"
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _USE_GRAY_ON _USE_GRAY_OFF
			#pragma multi_compile _USE_CLIP_3_ON
			#pragma multi_compile _USE_ALPHA_TEX_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON			
			ENDCG
		}
		
		//文本的Shader
		Pass
		{
		    //text
		    Name "NGUI&TEXT"
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag				
			#pragma multi_compile _USE_TEXT_ON
			#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON
			ENDCG
		}		
		
		Pass
		{
		    //text
		    Name "NGUI&TEXT&T"
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag					
			#pragma multi_compile _USE_TEXT_ON
			#pragma multi_compile _USE_TEXTURE_CLIP_ON
			//#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON
			ENDCG
		}
		
		Pass
		{
		    //text
		    Name "NGUI&TEXT&1"
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#pragma multi_compile _USE_TEXT_ON
			#pragma multi_compile _USE_CLIP_1_ON
			//#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON
			ENDCG
		}		
		Pass
		{
		    //text
		    Name "NGUI&TEXT&2"
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#pragma multi_compile _USE_TEXT_ON
			#pragma multi_compile _USE_CLIP_2_ON
			//#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON
			ENDCG
		}		
		Pass
		{
		    //text
		    Name "NGUI&TEXT&3"
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#pragma multi_compile _USE_TEXT_ON
			#pragma multi_compile _USE_CLIP_3_ON
			//#pragma multi_compile _USE_UI_FLOW_LIGHT_OFF _USE_UI_FLOW_LIGHT_ON
			ENDCG
		}		
		
	}
}
