﻿Shader "Custom/Mask"
{
	Properties
	{
		_MainTex("Base (RGB), Alpha (A)", 2D) = "black" {}
		_Mask("Mask, Alpha (A)", 2D) = "black" {}
		_Cutoff("Alpha cutoff",Range(0,1)) = 0
	}

	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"DisableBatching" = "True"
		}

		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend One SrcAlpha
			// Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag			
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_ST;
		sampler2D _Mask;
		float4 _MaskTex_ST;
		float _Cutoff;

		struct appdata_t
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			half2 texcoord : TEXCOORD0;
			fixed4 color : COLOR;
			UNITY_VERTEX_OUTPUT_STEREO
		};

		v2f o;

		v2f vert(appdata_t v)
		{
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.texcoord = v.texcoord;
			o.color = v.color;
			return o;
		}

		fixed4 frag(v2f IN) : SV_Target
		{
			half4 mask = tex2D(_Mask, IN.texcoord);
			half4 col = tex2D(_MainTex, IN.texcoord);

			
			fixed s = step(_Cutoff,mask.a);
			col.rgb *= s;
			col.a += (1-s);
			
			return col;
		}
		ENDCG
	}
	}
}

