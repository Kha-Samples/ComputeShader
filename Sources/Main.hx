package;

import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.compute.Compute;
import kha.compute.ConstantLocation;
import kha.compute.Shader;
import kha.compute.ShaderStorageBuffer;
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
	private static var shaderStorage: ShaderStorageBuffer;
	private static var texture: Image;
	private static var texunit: kha.graphics4.TextureUnit;
	private static var offset: kha.graphics4.ConstantLocation;
	private static var computeTexunit: kha.compute.TextureUnit;
	private static var computeLocation: kha.compute.ConstantLocation;
	private static var computeT2: kha.compute.ConstantLocation;
	
	public static function main(): Void {
		System.start({title: "ComputeShader", width: 512, height: 512}, function (_) {
			texture = Image.create(512, 512, TextureFormat.RGBA128);
			
			computeTexunit = Shaders.tex_comp.getTextureUnit("destTex");
			computeLocation = Shaders.tex_comp.getConstantLocation("sine");
			
			computeT2 = Shaders.move_comp.getConstantLocation("delta");
			
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

			vertices = new VertexBuffer(6, structure, Usage.StaticUsage);
			var v = vertices.lock();
			v.set(0, -1.0); v.set(1, -1.0); v.set(2, 0.5); v.set(3, 0.0); v.set(4, 0.0);
			v.set(5, 1.0); v.set(6, -1.0); v.set(7, 0.5); v.set(8, 1.0); v.set(9, 0.0);
			v.set(10, -1.0); v.set(11, 1.0); v.set(12, 0.5); v.set(13, 0.0); v.set(14, 1.0);

			v.set(15, 1.0); v.set(16, 1.0); v.set(17, 0.5); v.set(18, 1.0); v.set(19, 1.0);
			v.set(20, -1.0); v.set(21, 1.0); v.set(22, 0.5); v.set(23, 0.0); v.set(24, 1.0);
			v.set(25, 1.0); v.set(26, -1.0); v.set(27, 0.5); v.set(28, 1.0); v.set(29, 0.0);
			vertices.unlock();
			
			indices = new IndexBuffer(6, Usage.StaticUsage);
			var i = indices.lock();
			i[0] = 0; i[1] = 1; i[2] = 2;
			i[3] = 3; i[4] = 4; i[5] = 5;
			indices.unlock();

			shaderStorage = new ShaderStorageBuffer(6, VertexData.Float3);
			var s = shaderStorage.lock();
			v.set(0, -1.0); v.set(1, -1.0); v.set(2, 0.5);
			v.set(5, 1.0); v.set(6, -1.0); v.set(7, 0.5);
			v.set(10, -1.0); v.set(11, 1.0); v.set(12, 0.5);

			v.set(15, 1.0); v.set(16, 1.0); v.set(17, 0.5);
			v.set(20, -1.0); v.set(21, 1.0); v.set(22, 0.5);
			v.set(25, 1.0); v.set(26, -1.0); v.set(27, 0.5);
			shaderStorage.unlock();
			
			System.notifyOnFrames(render);
		});
	}
	
	private static function render(frames: Array<Framebuffer>): Void {
		var g = frames[0].g4;
		g.begin();
		g.clear(Color.Black);
		
		Compute.setShader(Shaders.tex_comp);
		Compute.setTexture(computeTexunit, texture, Access.Write);
		Compute.setFloat(computeLocation, (1 + Math.sin(kha.Scheduler.time())) / 2);
		Compute.compute(Std.int(texture.width / 16), Std.int(texture.height / 16), 1);

		Compute.setShader(Shaders.move_comp);
		Compute.setBuffer(shaderStorage, 1);
		Compute.setFloat(computeT2, (1 + Math.sin(kha.Scheduler.time())) / 2 );
		Compute.compute(6, 1, 1);

		// TODO: Reading the content this way doesn't work
		var s = shaderStorage.lock();
		trace(s[0]);
		shaderStorage.unlock();
		
		// TODO: Using the ShaderStorageBuffer as a VertexBuffer does not work
		// Could be the concept of another buffer is flawed and we need a modified VertexBuffer instead.
		// However, this seems incompatible with having multiple elements (e.g. pos and texCoords) in a
		// single VertexBuffer when only one is used in the compute shader. 
		g.setPipeline(pipeline);
		g.setMatrix(offset, FastMatrix4.rotationZ(0));
		g.setTexture(texunit, texture);
		g.setVertexBuffer(vertices);
		g.setIndexBuffer(indices);
		g.drawIndexedVertices();
			
		g.end();
	}
}
