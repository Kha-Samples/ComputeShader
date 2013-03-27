package;

import kha.Game;
import kha.graphics.FragmentShader;
import kha.graphics.VertexBuffer;
import kha.graphics.VertexData;
import kha.graphics.VertexShader;
import kha.graphics.VertexStructure;
import kha.graphics.VertexType;
import kha.Loader;
import kha.Painter;

class Shader extends Game {
	private var vertexShader: VertexShader;
	private var fragmentShader: FragmentShader;
	private var vertices: VertexBuffer;
	
	public function new() {
		super("Shader", false);
	}
	
	override public function loadFinished(): Void {
		vertexShader = kha.Sys.graphics.createVertexShader(Loader.the.getShader("shader.vert").toString());
		fragmentShader = kha.Sys.graphics.createFragmentShader(Loader.the.getShader("shader.frag").toString());
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3, VertexType.Position);
		vertices = kha.Sys.graphics.createVertexBuffer(3, structure);
		var v = vertices.lock();
		v[0] = -1; v[1] = -1; v[2] = 0.5;
		v[3] = 1;  v[4] = -1; v[5] = 0.5;
		v[6] = -1; v[7] = 1;  v[8] = 0.5;
		vertices.unlock();
	}
	
	override public function render(painter: Painter): Void {
		kha.Sys.graphics.setVertexShader(vertexShader);
		kha.Sys.graphics.setFragmentShader(fragmentShader);
		kha.Sys.graphics.linkShaders();
		kha.Sys.graphics.setVertexBuffer(vertices);
		kha.Sys.graphics.drawArrays();
	}
}
