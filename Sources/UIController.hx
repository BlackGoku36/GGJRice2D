
import rice2d.App;
import kha.Color;

class UIController{


    public function new() {

        haxe.ui.Toolkit.init();

        final screen = haxe.ui.core.Screen.instance;
        final ui = haxe.ui.ComponentBuilder.fromFile("main.xml");

        screen.addComponent(ui);

        App.notifyOnUpdate(()-> {
        });

        App.notifyOnRenderG2((canvas)->{
            var g = canvas.g2;
            // var col = g.color;
            // g.color = Color.Red;
            // g2.begin(true, kha.Color.White);
                        screen.renderTo(g);
                    // g2.end();
            // g.color = col;
        });

    }

}