package;

import kha.Starter;

class Main {
	public static function main() {
		kha.Sys.needs3d = true;
		new Starter().start(new Shader());
	}
}
