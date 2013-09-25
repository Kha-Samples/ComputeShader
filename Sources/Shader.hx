package;

import kha.Game;
import kha.graphics.FragmentShader;
import kha.graphics.IndexBuffer;
import kha.graphics.Program;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexStructure;
import kha.Loader;
import kha.Painter;

class Shader extends Game {
	private var vertexShader: VertexShader;
	private var fragmentShader: FragmentShader;
	private var program: Program;
	private var vertices: VertexBuffer;
	private var indices: IndexBuffer;
	
	public function new() {
		super("Shader", false);
	}
	
	override public function init(): Void {
		vertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getShader("shader.vert"));
		fragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getShader("shader.frag"));
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		program = kha.Sys.graphics.createProgram();
		program.setVertexShader(vertexShader);
		program.setFragmentShader(fragmentShader);
		program.link(structure);
		
		vertices = kha.Sys.graphics.createVertexBuffer(3, structure);
		var v = vertices.lock();
		v[0] = -1; v[1] = -1; v[2] = 0.5;
		v[3] = 1;  v[4] = -1; v[5] = 0.5;
		v[6] = -1; v[7] = 1;  v[8] = 0.5;
		vertices.unlock();
		
		indices = kha.Sys.graphics.createIndexBuffer(3);
		var i = indices.lock();
		i[0] = 0; i[1] = 1; i[2] = 2;
		indices.unlock();
	}
	
	override public function render(painter: Painter): Void {
		kha.Sys.graphics.setProgram(program);
		kha.Sys.graphics.setVertexBuffer(vertices);
		kha.Sys.graphics.setIndexBuffer(indices);
		kha.Sys.graphics.drawIndexedVertices();
	}
}
