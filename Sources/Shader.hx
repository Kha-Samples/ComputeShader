package;

import kha.Framebuffer;
import kha.Game;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Program;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Loader;

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
		vertexShader = new VertexShader(Loader.the.getShader("shader.vert"));
		fragmentShader = new FragmentShader(Loader.the.getShader("shader.frag"));
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		program = new Program();
		program.setVertexShader(vertexShader);
		program.setFragmentShader(fragmentShader);
		program.link(structure);
		
		vertices = new VertexBuffer(3, structure, Usage.StaticUsage);
		var v = vertices.lock();
		v[0] = -1; v[1] = -1; v[2] = 0.5;
		v[3] = 1;  v[4] = -1; v[5] = 0.5;
		v[6] = -1; v[7] = 1;  v[8] = 0.5;
		vertices.unlock();
		
		indices = new IndexBuffer(3, Usage.StaticUsage);
		var i = indices.lock();
		i[0] = 0; i[1] = 1; i[2] = 2;
		indices.unlock();
	}
	
	override public function render(frame: Framebuffer): Void {
		var g = frame.g4;
		g.begin();
		g.setProgram(program);
		g.setVertexBuffer(vertices);
		g.setIndexBuffer(indices);
		g.drawIndexedVertices();
		g.end();
	}
}
