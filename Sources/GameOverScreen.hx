
import rice2d.App;
import kha.Color;

import kha.math.Vector2;
import UIController.TitleUI;
import UIController.ButtonUI;

class GameOverScreen{

    static var title1: TitleUI;
    static var buttonback: ButtonUI;
    public static var paused = true;


    public function new() {

        var windowSize = rice2d.Window.getWindowSize();

        title1 = new TitleUI("", -300, -500);

        buttonback = new ButtonUI("Back", Std.int((windowSize.width/2)-(550/2)), Std.int((windowSize.height/2)-(125/2))-200, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                LevelsController.showMenu();
            }
        });

        // hideMenu();
    }

    static function isInitialized(): Bool{
        if(title1 != null && buttonback != null) return true;
        return false;
    }

    public static function hideMenu(){
        paused = true;
        title1.pauseHide();
        buttonback.pauseHide();
    }

    public static function showMenu(message: String){
        paused = false;
        title1.setString(message);
        title1.resumeShow();
        buttonback.resumeShow();
    }

}