let project = new Project('New Project');
project.addAssets('Sources/Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
project.addLibrary('haxeui-core');
project.addLibrary('haxeui-kha');
project.addLibrary('hscript');
await project.addProject('Rice2D');
resolve(project);