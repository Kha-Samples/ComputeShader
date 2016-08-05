let project = new Project('Shader');

project.addSources('Sources');

project.addShaders('Sources/Shaders/**');

resolve(project);
