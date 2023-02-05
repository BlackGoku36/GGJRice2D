package;

import rice2d.App;

class Main {

    public static function main() {
        App.init("Empty Rice2D", 1280, 720, kha.Color.Black, kha.WindowMode.Fullscreen, ()->{
            new UIController();
            UIController.showMenu();
            new MapController();
            MapController.paused = true;
            new LevelsController();
            LevelsController.hideMenu();
            new GameOverScreen();
            GameOverScreen.hideMenu();
        });// 1
        // new MapController();
        // MapController.setLevel(1, true);
        // new UIController();
    }
}
