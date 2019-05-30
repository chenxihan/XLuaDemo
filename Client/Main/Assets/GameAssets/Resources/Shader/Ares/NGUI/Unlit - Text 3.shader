Shader "Hidden/Unlit/Text 3" 
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
		
		UsePass "Ares/Base/NGUIPassHelper/NGUI&TEXT&3"
	}
	Fallback "Unlit/Text"
}
