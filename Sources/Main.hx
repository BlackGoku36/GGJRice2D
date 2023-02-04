package;

import rice2d.App;

class Main {

    public static function main() {
        App.init("Empty Rice2D", 1280, 720, kha.Color.Black, kha.WindowMode.Fullscreen, ()->{
        });// 1
        // new MapController();
        new UIController();
    }
}
