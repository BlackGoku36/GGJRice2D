
import rice2d.App;
import kha.Color;

enum State {
  Won;
  Failed;
  Playing;
}

class MapController{

    public static var mapSize:Int = 4;

    public static var map: Array<Array<Int>> = [
        [270, 0, 0, 0, 0, 0], 
        [0, 0, 0, 0, 0, 0], 
        [520, 521, 0, 0, 0, 0], 
        [773, 0, 0, 0, 0, 0],
        [773, 0, 0, 0, 0, 0],
        [773, 0, 0, 0, 0, 0]
    ];
    static var blockSize: Int = 150;

    public static var paused = true;

    var kb = rice2d.Input.getKeyboard();

    static var state: State = Playing;
    static var level = 4;
    public static var mergeTotal = 2;
    static var time = 0.0;
    public static var timeLimit = 0.0; // In seconds

    static var buttonback: UIController.ButtonUI;

    static var mergeCount = 0;

    public function new() {
        buttonback = new UIController.ButtonUI("<", 100, 100, 100, 100, ()->{
            reset(false);
            paused = true;
            UIController.showMenu();
        });

        setLevel(level, false);
        time = haxe.Timer.stamp();

        App.notifyOnUpdate(()-> {
            // var mergeCount = 0;
            if(paused){
                buttonback.pauseHide();
                return;
            }else{
                buttonback.resumeShow();
            }
            if((haxe.Timer.stamp()-time) > timeLimit) state = State.Failed;
            if(state == State.Won || state == State.Failed){
                if(state == State.Won){
                    GameOverScreen.showMenu("You won!");
                }else{
                    GameOverScreen.showMenu("You lost!");
                }
                buttonback.pauseHide();
                paused = true;
                reset(false);
                return;
            }

            if(kb.started(Up)){
                for (y in 0...mapSize) {
                    for (x in 0...mapSize){
                        if(y > 0){
                            if(getType(x, y) == 2){
                                if(getType(x, y-1) == 0){
                                    map[y-1][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }else if(getType(x, y) == 3){
                                if(getType(x, y-1) == 0){
                                    var newY = y;
                                    while(true){
                                        if(newY > 0 && getType(x, newY-1) == 0){
                                            newY--;
                                        }else break;
                                    }
                                    map[newY][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                        }
                    }
                }
            }
            else if(kb.started(Down)){
                for (y in new ReverseIterator(mapSize, 0)) {
                    for (x in 0...mapSize){
                        if(y < mapSize-1){
                            if(getType(x, y) == 2){
                                if(getType(x, y+1) == 0){
                                    map[y+1][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                            else if(getType(x, y) == 3){
                                if(getType(x, y+1) == 0){
                                    var newY = y;
                                    while(true){
                                        if(newY < mapSize-1 && getType(x, newY+1) == 0){
                                            newY++;
                                        }else break;
                                    }
                                    map[newY][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }

                        }
                    }
                }
            }
            else if(kb.started(Left)){
                for (x in 0...mapSize){
                    for (y in 0...mapSize) {
                        if(x > 0){
                            if(getType(x, y) == 2){
                                if(getType(x-1, y) == 0){
                                    map[y][x-1] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                            else if(getType(x, y) == 3){
                                if(getType(x-1, y) == 0){
                                    var newX = x;
                                    while(true){
                                        if(newX > 0 && getType(newX-1, y) == 0){
                                            newX--;
                                        }else break;
                                    }
                                    map[y][newX] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                        }
                    }
                }
            }
            else if(kb.started(Right)){
                for (x in new ReverseIterator(mapSize, 0)){
                    for (y in 0...mapSize) {
                        if(x < mapSize-1){
                            if(getType(x, y) == 2){
                                if(getType(x+1, y) == 0){
                                    map[y][x+1] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                            else if(getType(x, y) == 3){
                                if(getType(x+1, y) == 0){
                                    var newX = x;
                                    while(true){
                                        if(newX < mapSize-1 && getType(newX+1, y) == 0){
                                            newX++;
                                        }else break;
                                    }
                                    map[y][newX] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                        }
                    }
                }
            }

            if(state == State.Playing){
                var square_root = 0;
                var x_pos = 0;
                var y_pos = 0;
                for(y in 0...(mapSize-1)){
                    if(state == State.Won) break;
                    for (x in 0...(mapSize-1)) {
                        var block1 = getValue(x, y);
                        var block2 = getValue(x+1, y);
                        var block3 = getValue(x, y+1);
                        var block4 = getValue(x+1, y+1);
                        if(block1 == 0 || block2 == 0 || block3 == 0 || block4 == 0) continue;
                        var sum = block1+block2+block3+block4;
                        if(sum > 0){
                            var sr = Math.floor(Math.sqrt(sum));
                            if(sr * sr == (sum*1.0)){
                                // BEWARE OF FLOATING POINT!!!!!!!
                                square_root = Math.ceil(sr);
                                x_pos = x;
                                y_pos = y;

                                map[y_pos][x_pos] = square_root + 768;
                                map[y_pos+1][x_pos] = 0;
                                map[y_pos][x_pos+1] = 0;
                                map[y_pos+1][x_pos+1] = 0;

                                mergeCount++;
                                if(mergeCount == mergeTotal){
                                    state = State.Won;
                                    break;
                                }
                                // else state = State.Playing;
                            }
                        }
                    }
                }
            }
        });

        App.notifyOnRenderG2((canvas)->{
            if(paused) return;
            var windowDimension = rice2d.Window.getWindowSize();
            var mapWidth = mapSize*blockSize;
            var mapHeight = mapSize*blockSize;
            var mapWidth2 = mapWidth / 2;
            var mapHeight2 = mapHeight / 2;
            var mapPosX = (windowDimension.width/2) - mapWidth2;
            var mapPosY = (windowDimension.height/2) - mapHeight2;
            var g = canvas.g2;
            var col = g.color;
            g.font = rice2d.App.font;
            g.fontSize = 70;
            
            if(state == State.Playing){
                for (y in 0...mapSize) {
                    for (x in 0...mapSize){
                        var type = getType(x, y);
                        if(type == 0) g.color = Color.fromBytes(240, 230, 239, 255);
                        else if(type == 1) g.color = Color.fromBytes(156, 137, 184, 255);
                        else if(type == 2) g.color = Color.fromBytes(240, 166, 202, 255);
                        else if(type == 3) g.color = Color.fromBytes(239, 195, 230, 255);
                        g.fillRect(x*blockSize+mapPosX, y*blockSize+mapPosY, blockSize, blockSize);
                        g.color = Color.Black;
                        if(type != 0) g.drawString(getValue(x, y) + "", x*blockSize+mapPosX+50, y*blockSize+mapPosY+40);
                    }
                }
            }
            g.color = col;
        });

    }

    public static function reset(resume: Bool){
        state = Playing;
        time = haxe.Timer.stamp();
        paused = !resume;
    }

    public static function copy(arr: Array<Array<Int>>){
        return arr.copy();
    }

    public static function setLevel(level: Int, resume: Bool){
        var invalidLevel = false;
        switch (level) {
            case 1:{
                for(i in 0...Levels.level1.length){
                    for(j in 0...Levels.level1.length){
                        map[j][i] = Levels.level1[j][i];
                    }
                }
                timeLimit = Levels.level1TimeLimit;
                mapSize = 4;
                mergeTotal = 1;
                mergeCount = 0;
            }
            case 2:{
                for(i in 0...Levels.level2.length){
                    for(j in 0...Levels.level2.length){
                        map[j][i] = Levels.level2[j][i];
                    }
                }
                timeLimit = Levels.level2TimeLimit;
                mapSize = 4;
                mergeTotal = 1;
                mergeCount = 0;
            }
            case 3:{
                for(i in 0...Levels.level3.length){
                    for(j in 0...Levels.level3.length){
                        map[j][i] = Levels.level3[j][i];
                    }
                }
                timeLimit = Levels.level3TimeLimit;
                mapSize = 5;
                mergeTotal = 1;
                mergeCount = 0;
            }
            case 4:{
                for(i in 0...Levels.level4.length){
                    for(j in 0...Levels.level4.length){
                        map[j][i] = Levels.level4[j][i];
                    }
                }
                timeLimit = Levels.level4TimeLimit;
                mapSize = 5;
                mergeTotal = 2;
                mergeCount = 0;
            }
            case 5:{
                for(i in 0...Levels.level5.length){
                    for(j in 0...Levels.level5.length){
                        map[j][i] = Levels.level5[j][i];
                    }
                }
                timeLimit = Levels.level5TimeLimit;
                mapSize = 5;
                mergeTotal = 2;
                mergeCount = 0;
            }
            case 6:{
                for(i in 0...Levels.level6.length){
                    for(j in 0...Levels.level6.length){
                        map[j][i] = Levels.level6[j][i];
                    }
                }
                timeLimit = Levels.level6TimeLimit;
                mapSize = 5;
                mergeTotal = 1;
                mergeCount = 0;
            }
            case 7:{
                for(i in 0...Levels.level7.length){
                    for(j in 0...Levels.level7.length){
                        map[j][i] = Levels.level7[j][i];
                    }
                }
                timeLimit = Levels.level7TimeLimit;
                mapSize = 5;
                mergeTotal = 4;
                mergeCount = 0;
            }
            case 8:{
                for(i in 0...Levels.level8.length){
                    for(j in 0...Levels.level8.length){
                        map[j][i] = Levels.level8[j][i];
                    }
                }
                timeLimit = Levels.level8TimeLimit;
                mapSize = 6;
                mergeTotal = 3;
                mergeCount = 0;
            }
            case 9:{
                for(i in 0...Levels.level9.length){
                    for(j in 0...Levels.level9.length){
                        map[j][i] = Levels.level9[j][i];
                    }
                }
                timeLimit = Levels.level9TimeLimit;
                mapSize = 6;
                mergeTotal = 3;
                mergeCount = 0;
            }
            default: invalidLevel = true;
        }
        if(!invalidLevel) reset(resume);
        else{
            trace("INVALID LEVEL!");
            reset(false);
        }
    }

    public static function getType(x: Int, y: Int): Int {
        var type = map[y][x] & (3 << 8);
        if(type == 256) return 1;
        else if(type == 512) return 2;
        else if(type == 768) return 3;
        else return 0;
    }

    public static function getValue(x:Int, y:Int): Int {
        return map[y][x] & 255;
    }

    public static function printMap(){
        trace(
            map[0] + ", " + map[1] + ", " + map[2] + ", " + map[3] + "\n"
            + map[4] + ", " + map[5] + ", " + map[6] + ", " + map[7] + "\n"
            + map[8] + ", " + map[9] + ", " + map[10] + ", " + map[11] + "\n"
        );
    }

}

class ReverseIterator {
  var end:Int;
  var i:Int;

  public inline function new(start:Int, end:Int) {
    this.i = start;
    this.end = end;
  }

  public inline function hasNext() return i >= end;
  public inline function next() return i--;
}