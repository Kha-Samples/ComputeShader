package;

import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.compute.Compute;
import kha.compute.ConstantLocation;
import kha.compute.Shader;
import kha.compute.TextureUnit;
import kha.compute.Access;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureFormat;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Shaders;
import kha.System;
import kha.math.FastMatrix3;
import kha.math.FastMatrix4;

class Main {
	private static var pipeline: PipelineState;
	private static var vertices: VertexBuffer;
	private static var indices: IndexBuffer;
	private static var texture: Image;
	private static var texunit: kha.graphics4.TextureUnit;
	private static var offset: kha.graphics4.ConstantLocation;
	private static var computeTexunit: kha.compute.TextureUnit;
	private static var computeLocation: kha.compute.ConstantLocation;
	
	public static function main(): Void {
		System.start({title: "ComputeShader", width: 640, height: 480}, function (_) {
			texture = Image.create(256, 256, TextureFormat.RGBA128);
			
			computeTexunit = Shaders.test_comp.getTextureUnit("destTex");
			computeLocation = Shaders.test_comp.getConstantLocation("roll");
			
			var structure = new VertexStructure();
			structure.add("pos", VertexData.Float3);
			structure.add("tex", VertexData.Float2);
			
			pipeline = new PipelineState();
			pipeline.inputLayout = [structure];
			pipeline.vertexShader = Shaders.shader_vert;
			pipeline.fragmentShader = Shaders.shader_frag;
			pipeline.compile();
			
			texunit = pipeline.getTextureUnit("texsampler");
			offset = pipeline.getConstantLocation("mvp");

			vertices = new VertexBuffer(3, structure, Usage.StaticUsage);
			var v = vertices.lock();
			v.set(0, -1.0); v.set(1, -1.0); v.set(2, 0.5); v.set(3, 0.0); v.set(4, 1.0);
			v.set(5, 1.0); v.set(6, -1.0); v.set(7, 0.5); v.set(8, 1.0); v.set(9, 1.0);
			v.set(10, -1.0); v.set(11, 1.0); v.set(12, 0.5); v.set(13, 0.0); v.set(14, 0.0);

			vertices.unlock();
			
			indices = new IndexBuffer(3, Usage.StaticUsage);
			var i = indices.lock();
			i[0] = 0; i[1] = 1; i[2] = 2;
			indices.unlock();
			
			System.notifyOnFrames(render);
		});
	}
	
	private static function render(frames: Array<Framebuffer>): Void {
		var g = frames[0].g4;
		g.begin();
		g.clear(Color.Black);
		
		Compute.setShader(Shaders.test_comp);
		Compute.setTexture(computeTexunit, texture, Access.Write);
		Compute.setFloat(computeLocation, 0);
		Compute.compute(texture.width, texture.height, 1);
		
		g.setPipeline(pipeline);
		g.setMatrix(offset, FastMatrix4.rotationZ(0));
		g.setTexture(texunit, texture);
		g.setVertexBuffer(vertices);
		g.setIndexBuffer(indices);
		g.drawIndexedVertices();
			
		g.end();
	}
}
