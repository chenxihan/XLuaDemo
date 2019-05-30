Shader "Hidden/Unlit/Text 1" 
{
	Properties
	{
		_MainTex ("Alpha (A)", 2D) = "white" {}
	}

	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		UsePass "Ares/Base/NGUIPassHelper/NGUI&TEXT&1"
	}
	Fallback "Unlit/Text"
}
