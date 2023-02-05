
import rice2d.App;
import kha.Color;

import kha.math.Vector2;
import UIController.TitleUI;
import UIController.ButtonUI;

class LevelsController{

    static var title1: TitleUI;
    static var buttonback: ButtonUI;
    static var button1: ButtonUI;
    static var button2: ButtonUI;
    static var button3: ButtonUI;
    static var button4: ButtonUI;
    static var button5: ButtonUI;
    static var button6: ButtonUI;
    static var button7: ButtonUI;
    static var button8: ButtonUI;
    static var button9: ButtonUI;
    public static var paused = true;


    public function new() {

        var windowSize = rice2d.Window.getWindowSize();

        title1 = new TitleUI("Levels", 0, -600);

        buttonback = new ButtonUI("Back", Std.int((windowSize.width/2)-(550/2)), Std.int((windowSize.height/2)-(125/2))-400, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                UIController.showMenu();
            }
        });

        button1 = new ButtonUI("Level 1", Std.int((windowSize.width/2)-(550/2))-600, 100+Std.int((windowSize.height/2)-(125/2))-300, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(1, true);
            }
        });

        button2 = new ButtonUI("Level 2", Std.int((windowSize.width/2)-(550/2))+600, 100+Std.int((windowSize.height/2)-(125/2))-300, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(2, true);
            }
        });

        button3 = new ButtonUI("Level 3", Std.int((windowSize.width/2)-(550/2))-600, Std.int((windowSize.height/2)-(125/2)), 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(3, true);
            }
        });

        button4 = new ButtonUI("Level 4", Std.int((windowSize.width/2)-(550/2))+600, Std.int((windowSize.height/2)-(125/2)), 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(4, true);
            }
        });

        button5 = new ButtonUI("Level 5", Std.int((windowSize.width/2)-(550/2))-600, Std.int((windowSize.height/2)-(125/2))+200, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(5, true);
            }
        });

        button6 = new ButtonUI("Level 6", Std.int((windowSize.width/2)-(550/2))+600, Std.int((windowSize.height/2)-(125/2))+200, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(6, true);
            }
        });

        button7 = new ButtonUI("Level 7", Std.int((windowSize.width/2)-(550/2))-600, Std.int((windowSize.height/2)-(125/2))+400, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(7, true);
            }
        });

        button8 = new ButtonUI("Level 8", Std.int((windowSize.width/2)-(550/2))+600, Std.int((windowSize.height/2)-(125/2))+400, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(8, true);
            }
        });

        button9 = new ButtonUI("Level 9", Std.int((windowSize.width/2)-(550/2)), Std.int((windowSize.height/2)-(125/2))+600, 550, 125, ()->{
            if(isInitialized()){
                hideMenu();
                MapController.reset(false);
                MapController.setLevel(9, true);
            }
        });
        hideMenu();
    }

    static function isInitialized(): Bool{
        if(title1 != null && button1 != null && button2 != null && button3 != null
            && button4 != null && button5 != null && button6 != null && button7 != null
            && button8 != null && button9 != null && buttonback != null) return true;
        return false;
    }

    public static function hideMenu(){
        paused = true;
        title1.pauseHide();
        buttonback.pauseHide();
        button1.pauseHide();
        button2.pauseHide();
        button3.pauseHide();
        button4.pauseHide();
        button5.pauseHide();
        button6.pauseHide();
        button7.pauseHide();
        button8.pauseHide();
        button9.pauseHide();
    }

    public static function showMenu(){
        paused = false;
        title1.resumeShow();
        buttonback.resumeShow();
        button1.resumeShow();
        button2.resumeShow();
        button3.resumeShow();
        button4.resumeShow();
        button5.resumeShow();
        button6.resumeShow();
        button7.resumeShow();
        button8.resumeShow();
        button9.resumeShow();
    }

}