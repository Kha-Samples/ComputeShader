
#version 430 compatibility
#extension GL_ARB_compute_shader: enable
#extension GL_ARB_shader_storage_buffer_object : enable

uniform float delta;

layout(std140, binding = 1) buffer Pos {
	vec3 Positions[];
};

layout (local_size_x = 2, local_size_y = 1) in;

void main() {
	uint gid = gl_GlobalInvocationID.x; // y and z are constant
	Positions[ gid ] = Positions[ gid ] + vec3(delta, delta, delta);
}
