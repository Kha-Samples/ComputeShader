package;

import kha.Starter;

class Main {
	public static function main() {
		kha.Sys.needs3d = true;
		var starter = new Starter();
		starter.start(new Shader());
	}
}
