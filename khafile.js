let project = new Project('ComputeShader');

project.addSources('Sources');

project.addShaders('Sources/Shaders/**');

resolve(project);
