attribute vec3 pos;
attribute vec2 tex;

varying vec2 texcoord;
uniform mat4 mvp;

void kore() {
	gl_Position = mvp * vec4(pos.xy, 0.5, 1.0);
	texcoord = tex;
}
