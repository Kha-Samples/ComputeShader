#version 450

in vec2 texcoord;

uniform sampler2D texsampler;

out vec4 fragColor;

void main() {
	vec4 color = texture(texsampler, texcoord);
	fragColor = vec4(color.r, color.g, color.b, 1.0);
}
