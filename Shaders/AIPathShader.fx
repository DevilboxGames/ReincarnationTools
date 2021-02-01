
float4 normColour <
	string UIName = "Normal Colour";
> = float4 (1.0f, 0.0f, 0.0f,1.0f);

float4 waterColour <
	string UIName = "Water Colour";
> = float4 (0.0f, 0.0f, 1.0f,1.0f);

float4 loopColour <
	string UIName = "Loop Colour";
> = float4 (0.0f, 1.0f, 0.0f,1.0f);

float4 interiorColour <
	string UIName = "Interior Colour";
> = float4 (0.0f, 1.0f, 1.0f,1.0f);

float4 shortcutColour <
	string UIName = "Shortcut Colour";
> = float4 (1.0f, 0.0f, 1.0f,1.0f);

float4 trackColour <
	string UIName = "Track Colour";
> = float4 (1.0f, 0.745f, 0.0f, 1.0f);



float oneWayThreshhold <
	string UIName = "One Way Icon Threshold";
> = 0.9;

float oneWayBorderMinThreshhold <
	string UIName = "One Way Icon Min Border Threshold";
> = 0.75;
float oneWayBorderMaxThreshhold <
	string UIName = "One Way Icon Max Border Threshold";
> = 0.95;
float oneWayScale <
	string UIName = "One Way Icon Scale";
	float UIMin = 0.0f;
	float UIMax = 50.0f;	
> = 1;
float4 oneWayColour <
	string UIName = "One Way Icon Colour";	
> = float4 (1.0f, 1.0f, 1.0f, 1.0f);
float4 oneWayBorderColour <
	string UIName = "One Way Icon Border Colour";	
> = float4 (0.0f, 0.0f, 0.0f, 1.0f);

bool isOneWay <
	string UIName = "Is One Way";
> = false;
bool isWater <
	string UIName = "Is Water";
> = false;

bool isLoop <
	string UIName = "Is Loop";
> = false;

bool isInterior <
	string UIName = "Is Interior";
> = false;

bool isTrack <
	string UIName = "Is Track";
> = false;

bool isShortcut <
	string UIName = "Is Shortcut";
> = false;


Texture2D <float4> maskTex1 : DiffuseMap< 
	string UIName = "Mask Texture 1";
	string ResourceType = "2D";
	int Texcoord = 0;
	int MapChannel = 1;
>;
Texture2D <float4> maskTex2 : DiffuseMap< 
	string UIName = "Mask Texture 2";
	string ResourceType = "2D";
	int Texcoord = 0;
	int MapChannel = 1;
>;
Texture2D <float4> oneWayTex : DiffuseMap< 
	string UIName = "One Way Texture ";
	string ResourceType = "2D";
	int Texcoord = 0;
	int MapChannel = 2;
>;

SamplerState maskTex1Sampler
{
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
    AddressV = Wrap;
	
};
SamplerState maskTex2Sampler
{
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
    AddressV = Wrap;
	
};
SamplerState oneWayTexSampler
{
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	AddressU = Wrap;
    AddressV = Wrap;
	
};

// transformations
cbuffer everyFrame
{
	matrix World      : 		WORLD;
	matrix WorldIT   : 		WORLDINVERSETRANSPOSE;
	matrix WorldViewProj : 		WORLDVIEWPROJ;
	matrix WorldView 	: 		WORLDVIEW;
	matrix Projection 	: 		PROJECTION;
	matrix ViewI		:		VIEWINVERSE;
};

RasterizerState DataCulling
{
	FillMode = SOLID;
	CullMode = FRONT;
	FrontCounterClockwise = false;
};

RasterizerState NoCulling
{
	FillMode = SOLID;
	CullMode = NONE;

};

DepthStencilState EnableDepth
{
    DepthEnable = TRUE;
    DepthWriteMask = ALL;
};

DepthStencilState Depth
{
    DepthEnable = TRUE;
    DepthFunc = 4;//LESSEQUAL
    DepthWriteMask = ALL;
};

struct VS_INPUT
{
    float3 Pos  : POSITION;
	float2 UV0		: TEXCOORD0;	
	float2 UV1		: TEXCOORD1;	
    float3 Norm : NORMAL;
};

struct VS_OUTPUT
{
    float4 Pos  : SV_Position;
    float2 UV0		: TEXCOORD0;
    float2 UV1		: TEXCOORD1;
       
};
VS_OUTPUT VS(  VS_INPUT In)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;




    Out.Pos  = mul(float4(In.Pos,1),WorldViewProj);    	  // position (projected)
    Out.UV0 = In.UV0;
    Out.UV1 = In.UV1;

    return Out;
}


float4 PS( VS_OUTPUT input ) : SV_Target
{
	
    float4 color = normColour;  
	if (isWater || isLoop || isInterior || isTrack || isShortcut) {
		int numColours = 1;
		float4 c1 = normColour;
		float4 c2 = normColour;
		float4 c3 = normColour;
		float4 c4 = normColour;
		if(isWater) {
			c1 = waterColour;
				c2 = waterColour;
				c3 = waterColour;
				c4 = waterColour;
			if(isInterior && !isLoop && !isTrack && !isShortcut){
				numColours += 1;
				c2 = interiorColour;
				c4 = interiorColour;
			}
			else if(!isInterior && isLoop && !isTrack && !isShortcut){
				numColours += 1;
				c2 = loopColour;
				c4 = loopColour;
			}
			else if(!isInterior && !isLoop && isTrack && !isShortcut){
				numColours += 1;
				c2 = trackColour;
				c4 = trackColour;
			}
			else if(!isInterior && !isLoop && !isTrack && isShortcut){
				numColours += 1;
				c2 = shortcutColour;
				c4 = shortcutColour;
			}
			else if(isLoop && isInterior && !isTrack && !isShortcut){
				numColours += 2;
				c4 = waterColour;
				c2 = loopColour;
				c3 = interiorColour;
			}
			else if(isLoop && !isInterior && isTrack && !isShortcut){
				numColours += 2;
				c4 = waterColour;
				c2 = loopColour;
				c3 = trackColour;
			}
			else if(isLoop && !isInterior && !isTrack && isShortcut){
				numColours += 2;
				c4 = waterColour;
				c2 = loopColour;
				c3 = shortcutColour;
			}
			else if(!isLoop && isInterior && isTrack && !isShortcut){
				numColours += 2;
				c4 = waterColour;
				c2 = interiorColour;
				c3 = trackColour;
			}
			else if(!isLoop && isInterior && !isTrack && isShortcut){
				numColours += 2;
				c4 = waterColour;
				c2 = interiorColour;
				c3 = shortcutColour;
			}
			else if(isLoop && isInterior && isTrack && !isShortcut){
				numColours += 3;
				c2 = loopColour;
				c3 = interiorColour;
				c4 = trackColour;
			}
			else if(isLoop && isInterior && isShortcut){
				numColours += 3;
				c2 = loopColour;
				c3 = interiorColour;
				c4 = shortcutColour;
			}
		}
		else if(isLoop) {
			c1 = loopColour;
				c2 = loopColour;
				c3 = loopColour;
				c4 = loopColour;
			if(isInterior && !isTrack && !isShortcut) {
				numColours += 1;
				c2 = interiorColour;
				c3 = loopColour;
				c4 = interiorColour;
			}
			else if(!isInterior && isTrack && !isShortcut) {
				numColours += 1;
				c2 = trackColour;
				c3 = loopColour;
				c4 = trackColour;
			}
			else if(!isInterior && !isTrack && isShortcut) {
				numColours += 1;
				c2 = shortcutColour;
				c3 = loopColour;
				c4 = shortcutColour;
			}
			else if(isInterior && isShortcut) {
				numColours += 2;
				c4 = loopColour;
				c2 = interiorColour;
				c3 = shortcutColour;
			}
			else if(isInterior && isTrack && !isShortcut) {
				numColours += 2;
				c4 = loopColour;
				c2 = interiorColour;
				c3 = trackColour;
			}
		}
		else if(isInterior){
			c1 = interiorColour;
				c2 = interiorColour;
				c3 = interiorColour;
				c4 = interiorColour;
				
			if(isTrack && !isShortcut){
				numColours += 1;
				c2 = trackColour;
				c3 = interiorColour;
				c4 = trackColour;
			}
			else if(isShortcut){numColours += 1;
				c2 = shortcutColour;
				c3 = interiorColour;
				c4 = shortcutColour;
			}
		}
		else if(isTrack && !isShortcut){
			c1 = trackColour;
			c2 = trackColour;
			c3 = trackColour;
			c4 = trackColour;
		}
		else if(isShortcut){
			c1 = shortcutColour;
			c2 = shortcutColour;
			c3 = shortcutColour;
			c4 = shortcutColour;
		}
		float m1 = maskTex1.Sample(maskTex1Sampler, input.UV0).r;
		//float4 m2 = maskTex2.Sample(maskTex2Sampler, input.UV0);
		if(numColours == 4) {
			if(m1 < 0.07f) {
				color.rgb = c4.rgb;
			}
			else if (m1 < 0.25f){
				color.rgb = c3.rgb;
			}
			else if (m1 < 0.55f){
				color.rgb = c2.rgb;
			}
			else {
				color.rgb = c1.rgb;
			}
		}
		else if(numColours == 3) {
			if(m1 < 0.1f) {
				color.rgb = c3.rgb;
			}
			else if (m1 < 0.45f){
				color.rgb = c2.rgb;
			}
			else {
				color.rgb = c1.rgb;
			}
		}
		else if(numColours == 2) {
			if(m1 < 0.25f) {
				color.rgb = c2.rgb;
			}
			else {
				color.rgb = c1.rgb;
			}
		}
		else {
			color.rgb = c1.rgb;
		}
		//color = c1 * m1.r * m2.r + c2 * (1-m1.r) * m2.r + c3 * m1.r * (1-m2.r) + c4 * (1-m1.r) * (1-m2.r);
	}
	if (isOneWay){
		float4 oneWayCol = oneWayTex.Sample(oneWayTexSampler, input.UV1 * oneWayScale);
		color.rgb *= (oneWayCol.a) < oneWayThreshhold ? 1 : 0;
		color.rgb += (oneWayCol.a) < oneWayThreshhold ? 0 : oneWayColour.rgb;
		
		color.rgb *= (oneWayCol.a) > oneWayBorderMinThreshhold && (oneWayCol.a) < oneWayBorderMaxThreshhold ? 0 : 1;
		color.rgb += (oneWayCol.a) > oneWayBorderMinThreshhold && (oneWayCol.a) < oneWayBorderMaxThreshhold ? oneWayBorderColour.rgb : 0;
	}
	color.a = 1.0f;
    return color;
}

technique10 Shaded
{
    pass P0
    {
    	//SetRasterizerState(DataCulling);
        //SetDepthStencilState( EnableDepth, 0 );	
        // shaders
       SetVertexShader( CompileShader( vs_4_0, VS()));
       SetGeometryShader(NULL);
       SetPixelShader( CompileShader( ps_4_0, PS()));
    }  
  
}
