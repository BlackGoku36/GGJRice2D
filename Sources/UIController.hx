
import rice2d.App;
import kha.Color;

import kha.math.Vector2;

class UIController{

    static var title1: TitleUI;
    static var title2: TitleUI;
    static var button1: ButtonUI;
    static var button2: ButtonUI;
    public static var paused = false;


    public function new() {

        var sponsorLogo1 = false;
        var sponsorLogo2 = false;
        var sponsorLogo3 = false;

        rice2d.Assets.loadImage("yumside", ()->{sponsorLogo1 = true;});
        rice2d.Assets.loadImage("pepsi", ()->{sponsorLogo2 = true;});
        rice2d.Assets.loadImage("lavazza", ()->{sponsorLogo3 = true;});

        var windowSize = rice2d.Window.getWindowSize();

        title1 = new TitleUI("square", 0, -400);
        title2 = new TitleUI("ROOTS", 0, -200);

        button1 = new ButtonUI("Play", Std.int((windowSize.width/2)-(550/2)), 100+Std.int((windowSize.height/2)-(125/2)), 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(1, true);
            }
        });

        button2 = new ButtonUI("Levels", Std.int((windowSize.width/2)-(550/2)), 300+Std.int((windowSize.height/2)-(125/2)), 550, 125, ()->{
            if(isInitialized()){
                UIController.hideMenu();
                MapController.paused = true;
                LevelsController.showMenu();
            }
        });

        App.notifyOnRenderG2((canvas)->{
            if(paused) return;
            if(!sponsorLogo1 && !sponsorLogo2 && !sponsorLogo3) return;

            var g = canvas.g2;
            var col = g.color;

            var windowSize2 = rice2d.Window.getWindowSize();

            g.drawScaledImage(rice2d.Assets.assets[2].value, 0, windowSize2.height-300, 300, 300);
            g.drawScaledImage(rice2d.Assets.assets[3].value, 300, windowSize2.height-300, 300, 300);
            g.drawScaledImage(rice2d.Assets.assets[4].value, 600, windowSize2.height-300, 300, 300);

            g.color = col;
        });

    }

    static function isInitialized(): Bool{
        if(title1 != null && title2 != null && button1 != null && button2 != null)
            return true;
        return false;
    }

    static function hideMenu(){
        paused = true;
        title1.pauseHide();
        title2.pauseHide();
        button1.pauseHide();
        button2.pauseHide();
    }

    public static function showMenu(){
        paused = false;
        title1.resumeShow();
        title2.resumeShow();
        button1.resumeShow();
        button2.resumeShow();
    }

}

class TitleUI {
    var x: Int = 0;
    var y: Int = 0;
    var title: String;
    var paused = true;

    public function new(title: String, x:Int, y:Int) {
        this.x = x;
        this.y = y;
        this.title = title;

        App.notifyOnRenderG2((canvas)->{
            if(paused) return;

            var windowSize = rice2d.Window.getWindowSize();

            var g = canvas.g2;
            var col = g.color;
            g.color = kha.Color.White;
            g.font = rice2d.App.font;
            g.fontSize = 200;
            g.drawString(this.title, x+(windowSize.width/2)-(rice2d.App.font.width(g.fontSize, title)/2), y+(windowSize.height/2)-(rice2d.App.font.height(g.fontSize)/2));
            g.color = col;
        });
    }

    public function pauseHide(){
        paused = true;
    }

    public function resumeShow(){
        paused = false;
    }

    public function setString(message: String){
        this.title = message;
    }
}

class ButtonUI {
    var x: Int = 0;
    var y: Int = 0;
    var width: Int = 0;
    var height: Int = 0;

    var mouse = rice2d.Input.getMouse();
    var hover = false;
    var paused = true;

    public function new(label: String, x:Int, y:Int, w: Int, h:Int, onPress: Void->Void) {
        this.x = x;
        this.y = y;
        this.width = w;
        this.height = h;

        App.notifyOnUpdate(()-> {
            if(paused) return;

            var mousePos = new Vector2(mouse.x, mouse.y);
            var rectPos = new Vector2(x, y);

            if(rice2d.Overlap.CirclevsRect(mousePos, 0.1, rectPos, width, height)){
                hover = true;
                if(mouse.started(0)){
                    onPress();
                }
            }else{
                hover = false;
            }
        });

        App.notifyOnRenderG2((canvas)->{
            if(paused) return;

            var g = canvas.g2;
            var col = g.color;

            if(hover) g.color = kha.Color.fromBytes(200, 200, 200);
            else g.color = kha.Color.White;

            g.fillRect(x, y, width, height);
            g.color = kha.Color.Black;
            g.font = rice2d.App.font;
            g.fontSize = 64;
            g.drawString(label, x+(width/2)-(rice2d.App.font.width(g.fontSize, label)/2), y+(height/2)-(rice2d.App.font.height(g.fontSize)/2));
            g.color = col;
        });
    }

    public function pauseHide(){
        paused = true;
    }

    public function resumeShow(){
        paused = false;
    }
}