// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#ifndef FUNCELL_NGUI_CG_INCLUDED
#define FUNCELL_NGUI_CG_INCLUDED


/*******************T4M的处理***************************/

//顺序不可以变化
#if defined(_USE_CLIP_3_ON) //支持三层Clip
    //默认打开2层的Clip	
	#ifndef _USE_CLIP_2_ON
		#define _USE_CLIP_2_ON
	#endif
		//定义变量
		float4 _ClipRange2 = float4(0.0, 0.0, 1.0, 1.0);
		float4 _ClipArgs2 = float4(1000.0, 1000.0, 0.0, 1.0);
		
		//定义UV寄存器
		#define FUNCELL_CLIP_3_COORD(idx1) float2 worldPos2 : TEXCOORD##idx1;		
		
		//计算UV
		#define FUNCELL_TRANSFER_CLIP_3(i,o) \
						o.worldPos2 = Rotate(v.vertex.xy, _ClipArgs2.zw) * _ClipRange2.zw + _ClipRange2.xy;
						
		//应用颜色				
		#define FUNCELL_APPLY_CLIP_3(i) \
						factor = (float2(1.0, 1.0) - abs(i.worldPos2)) * _ClipArgs2.xy;\
						f = min(f, min(factor.x, factor.y));
#else
		#define FUNCELL_CLIP_3_COORD(idx1)
		#define FUNCELL_TRANSFER_CLIP_3(i,o)
		#define FUNCELL_APPLY_CLIP_3(i)
#endif


#if defined(_USE_CLIP_2_ON) //支持2个Clip
	//默认打开1个Clip
	#ifndef _USE_CLIP_1_ON
		#define _USE_CLIP_1_ON
	#endif
		
		//定义变量
		float4 _ClipRange1 = float4(0.0, 0.0, 1.0, 1.0);
		float4 _ClipArgs1 = float4(1000.0, 1000.0, 0.0, 1.0);
		
		//定义UV寄存器 -- 在clip1上已经定义了worldPos(float4).
		#define FUNCELL_CLIP_2_COORD(idx1)
		
		//计算UV
		#define FUNCELL_TRANSFER_CLIP_2(i,o) \
					o.worldPos.zw = Rotate(i.vertex.xy, _ClipArgs1.zw) * _ClipRange1.zw + _ClipRange1.xy;
			
		//应用颜色				
		#define FUNCELL_APPLY_CLIP_2(i) \
					factor = (float2(1.0, 1.0) - abs(i.worldPos.zw)) * _ClipArgs1.xy;\
					f = min(f, min(factor.x, factor.y));
#else
		//定义UV寄存器
		#define FUNCELL_CLIP_2_COORD(idx1)
		//计算UV
		#define FUNCELL_TRANSFER_CLIP_2(i,o)
		//应用颜色				
		#define FUNCELL_APPLY_CLIP_2(i)
#endif

#if defined(_USE_CLIP_1_ON) //支持1个Clip

	//定义变量
	float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
	float4 _ClipArgs0 = float4(1000.0, 1000.0, 0.0, 1.0);
	float4 _ClipSoftnessHide = float4(0.0, 0.0, 0.0, 0.0);
		
	//定义UV寄存器
	#define FUNCELL_CLIP_1_COORD(idx1) float4 worldPos : TEXCOORD##idx1; 					
	
	//计算UV
	#define FUNCELL_TRANSFER_CLIP_1(i,o) \
					o.worldPos.xy = i.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
	
	#if defined(_USE_CLIP_SOFT_NESS_HIDE) //定义那些边得渐变处理被隐藏
	    //定义那些边得渐变处理被隐藏
		float4 _ClipSoftnessHide = float4(0.0, 0.0, 0.0, 0.0);
		
	    #define FUNCELL_APPLY_CLIP_1(i) \
						float2 factor = (float2(1.0, 1.0) - abs(i.worldPos.xy)) * _ClipArgs0.xy;\
						float4 map = float4(step(i.worldPos.x,0),step(0,i.worldPos.x),step(0,i.worldPos.y),step(i.worldPos.y,0)) + float4(step(0,factor.x),step(0,factor.x),step(0,factor.y),step(0,factor.y)) - float4(1,1,1,1);\
						map = map * _ClipSoftnessHide + float4(factor.x,factor.x,factor.y,factor.y);\
						factor = float2(map.x + map.y,map.z + map.w);\
						float f = min(factor.x, factor.y);
	#else
	
		//应用颜色			
		#define FUNCELL_APPLY_CLIP_1(i) \
						float2 factor = (float2(1.0, 1.0) - abs(i.worldPos.xy)) * _ClipArgs0.xy; \
						float f = min(factor.x, factor.y);
	#endif
#else
	//定义UV寄存器
	#define FUNCELL_CLIP_1_COORD(idx1)
	//计算UV
	#define FUNCELL_TRANSFER_CLIP_1(i,o)
	//应用颜色			
	#define FUNCELL_APPLY_CLIP_1(i)
#endif

//适用Texture来ClipUI -- 这个与上面的clip有互斥关系
#if defined(_USE_TEXTURE_CLIP_ON)
		sampler2D _ClipTex;
		float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
		
		//定义寄存器
		#define FUNCELL_TEXTURE_CLIP_COORD(idx1) float2 clipUV : TEXCOORD##idx1;
		
		//处理clipuv
		#define FUNCELL_TRANSFER_TEXTURE_CLIP(i,o) o.clipUV = (i.vertex.xy * _ClipRange0.zw + _ClipRange0.xy) * 0.5 + float2(0.5, 0.5);
		
		//应用颜色
		#define FUNCELL_APPLY_TEXTURE_CLIP(i,col) col.a *= tex2D(_ClipTex, i.clipUV).a;
	
#else
		//定义寄存器
		#define FUNCELL_TEXTURE_CLIP_COORD(idx1)
		//处理clipuv
		#define FUNCELL_TRANSFER_TEXTURE_CLIP(i,o)
		//应用颜色
		#define FUNCELL_APPLY_TEXTURE_CLIP(i,col)
#endif

//应用颜色处理
#if defined(_USE_CLIP_1_ON) || defined(_USE_CLIP_2_ON) || defined(_USE_CLIP_3_ON)

    #if defined(_USE_PREMULTIPLIED_ON)  //适用于one,oneminusscralpha
		#define FUNCELL_APPLY_CLIP_COLOR(i,col) \
					col *= i.color;\
					float fade = clamp(f, 0.0, 1.0);\
					col.a *= fade;\
					col.rgb = lerp(half3(0.0, 0.0, 0.0), col.rgb, fade);
					
	#elif defined(_USE_PACKED_ON)  //用于与颜色被打包的处理
	    #define FUNCELL_APPLY_CLIP_COLOR(i,col) \
					fixed4 mixed = saturate(ceil(i.color - 0.5));\
					fixed4 icol = saturate((mixed*0.51 - i.color)/-0.49);\
					col *= mixed;\
					icol.a *= col.r + col.g + col.b + col.a;\
					col = icol;\
					float fade = clamp(f, 0.0, 1.0);\
					col.a *= fade;
					
    #elif defined(_USE_TEXT_ON) //字体的处理
		#define FUNCELL_APPLY_CLIP_COLOR(i,col) \
					col.rgb = i.color.rgb;\
					col.a *= i.color.a;\
					float fade = clamp(f, 0.0, 1.0);\
					col.a *= fade;
	#else  //默认的颜色处理
		#define FUNCELL_APPLY_CLIP_COLOR(i,col) \
					col *= i.color;\
					float fade = clamp(f, 0.0, 1.0);\
					col.a *= fade;
					
	#endif    
#else 
    #if defined(_USE_PREMULTIPLIED_ON)
		#define FUNCELL_APPLY_CLIP_COLOR(i,col)\
					col *= i.color;\
					FUNCELL_APPLY_TEXTURE_CLIP(i,col)\
					col.rgb = lerp(half3(0.0, 0.0, 0.0), col.rgb, col.a);
					
	#elif defined(_USE_PACKED_ON)
	    #define FUNCELL_APPLY_CLIP_COLOR(i,col) \
					fixed4 mixed = saturate(ceil(i.color - 0.5));\
					fixed4 icol = saturate((mixed*0.51 - i.color)/-0.49);\
					col *= mixed;\
					icol.a *= col.r + col.g + col.b + col.a;\
					FUNCELL_APPLY_TEXTURE_CLIP(i,icol)\
					col = icol;
					
					
    #elif defined(_USE_TEXT_ON)
		#define FUNCELL_APPLY_CLIP_COLOR(i,col)\
					col.rgb = i.color.rgb;\
					FUNCELL_APPLY_TEXTURE_CLIP(i,col)\
					col.a *= i.color.a;
					
	#else
		#define FUNCELL_APPLY_CLIP_COLOR(i,col)\
					FUNCELL_APPLY_TEXTURE_CLIP(i,col)\
					col *= i.color;
	#endif 
#endif

//在UI上生成流光-- 这个功能在target3.0以上才计算
#if defined(_USE_UI_FLOW_LIGHT_ON) && (SHADER_TARGET >= 30)
    
	#if defined(_USE_FLOW_LIGHT_PARAM)
		//流光的颜色
		fixed4 _FlowColor;
		//宽度--值越大就越细
		half _FlowWidth;
		//速度, 光在UI上流过的速度
		half _FlowSpeed;	
		//周期,周期越大,在UI上闪过的之后等待时间越长
		half _FlowPeriod;
	#else	
		#define _FlowColor fixed3(0.5,0.5,0.5)
		#define _FlowWidth 6
		#define _FlowSpeed 1.5f
		#define _FlowPeriod 4	
	#endif
	
	//ui流光的定义
	#define FUNCELL_UI_FLOW_LIGHT_COORD(idx1) half4 flowUV : TEXCOORD##idx1;
	
	//设置流光的uv,位移,宽度
	#define FUNCELL_TRANSFER_UI_FLOW_LIGHT(i,o) o.flowUV.xy = i.texcoord1.xy;\
													 half __p = _FlowPeriod;\
													 o.flowUV.z = __p - frac(_Time.y * _FlowSpeed / __p) * __p * 2;\
													 o.flowUV.w = _FlowWidth;
								
	//应用流光
	#define FUNCELL_APPLY_UI_FLOW_LIGHT(i,color)  half __flow = CalcFlowLight30(i.flowUV.xy,i.flowUV.z,i.flowUV.w);\
													   color.xyz = color.xyz + __flow * _FlowColor;
#else
	#define FUNCELL_UI_FLOW_LIGHT_COORD(idx1)
	#define FUNCELL_TRANSFER_UI_FLOW_LIGHT(i,o)	
	#define FUNCELL_APPLY_UI_FLOW_LIGHT(i,color)
#endif

//在物体上生成一道流光闪过,右旋转45度
//uv:是采样图片的uv值[0,1],offset:是用于移动的偏移,值在[0,1]
inline half CalcFlowLight45(half2 uv, half offset, half width)
{
	half2 fuv = uv - 0.5;        
	fuv.x = fuv.x + offset;
	half flow = abs(fuv.x - fuv.y); //近似45度
	flow *= width;
	flow = max(0 , lerp(1,0,flow));//flow的值必须是大于0
	return flow;
}

//在物体上生成一道流光闪过,右旋转30度
//uv:是采样图片的uv值[0,1],offset:是用于移动的偏移,值在[0,1]
inline half CalcFlowLight30(half2 uv, half offset, half width)
{
	half2 fuv = uv - 0.5;        
	fuv.x = fuv.x + offset;
	half flow = abs(fuv.x * 0.88 - fuv.y*0.5); //近似30度
	flow *= width;
	flow = max(0 , lerp(1,0,flow));//flow的值必须是大于0
	return flow;
}

//旋转处理
inline half2 Rotate (half2 v, half2 rot)
{
	half2 ret;
	ret.x = v.x * rot.y - v.y * rot.x;
	ret.y = v.x * rot.x + v.y * rot.y;
	return ret;
}

#endif  //FUNCELL_NGUI_CG_INCLUDED
