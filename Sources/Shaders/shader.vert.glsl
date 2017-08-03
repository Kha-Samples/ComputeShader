#version 450

in vec3 pos;
in vec2 tex;

out vec2 texcoord;
uniform mat4 mvp;

void main() {
	gl_Position = mvp * vec4(pos.xy, 0.5, 1.0);
	texcoord = tex;
}
