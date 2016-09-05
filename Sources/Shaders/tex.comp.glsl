#version 450

uniform float sine;
uniform writeonly image2D destTex;

layout (local_size_x = 16, local_size_y = 16) in;

void main() {
	ivec2 storePos = ivec2(gl_GlobalInvocationID.xy);
	vec2 halfSize = vec2(gl_NumWorkGroups.xy) / 2;

	vec2 pos = (ivec2(gl_GlobalInvocationID.xy) - halfSize) * 1.5 / (halfSize.x * sine);
	float col = (1 + sign(pow(pos.x, 2) * pow(pos.y, 3) - pow(pow(pos.x, 2) + pow(pos.y, 2) - 1, 3))) / 2;

	imageStore(destTex, storePos, vec4(col, 0.0, 0.0, 1.0));

}
