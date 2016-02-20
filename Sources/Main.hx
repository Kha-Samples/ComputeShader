package;

import kha.Color;
import kha.Framebuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Shaders;
import kha.System;

class Main {
	private static var pipeline: PipelineState;
	private static var vertices: VertexBuffer;
	private static var indices: IndexBuffer;
	
	public static function main(): Void {
		System.init({title: "Shader", width: 640, height: 480}, function () {
			var structure = new VertexStructure();
			structure.add("pos", VertexData.Float3);
			
			pipeline = new PipelineState();
			pipeline.inputLayout = [structure];
			pipeline.vertexShader = Shaders.shader_vert;
			pipeline.fragmentShader = Shaders.shader_frag;
			pipeline.compile();
			
			vertices = new VertexBuffer(3, structure, Usage.StaticUsage);
			var v = vertices.lock();
			v.set(0, -1); v.set(1, -1); v.set(2, 0.5);
			v.set(3,  1); v.set(4, -1); v.set(5, 0.5);
			v.set(6, -1); v.set(7,  1); v.set(8, 0.5);
			vertices.unlock();
			
			indices = new IndexBuffer(3, Usage.StaticUsage);
			var i = indices.lock();
			i[0] = 0; i[1] = 1; i[2] = 2;
			indices.unlock();
			
			System.notifyOnRender(render);
		});
	}
	
	private static function render(frame: Framebuffer): Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black);
		g.setPipeline(pipeline);
		g.setVertexBuffer(vertices);
		g.setIndexBuffer(indices);
		g.drawIndexedVertices();
		g.end();
	}
}
