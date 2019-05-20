//单击开始游戏--》startPage消失--》游戏开始
//随机出现食物，出现三节蛇开始运动
//按上下左右--》根据方向运动
//判断是不是吃到食物--》食物消失，蛇长度加一
//判断游戏结束，弹出框。

//init()
//取map地图。
//this.mapW = parseInt(getComputedStyle(content).width);
var startP = document.getElementById('startP');
var startPage = document.getElementById('startPage');
var loserScore = document.getElementById('loserScore');
var lose = document.getElementById('lose');
var scoreBox = document.getElementById('score');
var content = document.getElementById('content');
var startPage = document.getElementById('startPage');
var snakeMove;
var close = document.getElementById('close');
var startBtn = document.getElementById('startBtn');
var speed = 200;
var startGameBool = true;
var startPaushBool = true;
var showMusic = document.getElementById("showMusic");
init();
function init() {
    //地图
    this.mapW = parseInt(getComputedStyle(content).width);
    this.mapH = parseInt(getComputedStyle(content).height);
    this.mapDiv = content;
    //食物
    this.foodW = 20;
    this.foodH = 20;
    this.foodX = 0;
    this.foodY = 0;
    //蛇
    this.snakeW = 20;
    this.snakeH = 20;
    this.snakeBody = [
        [3, 1, 'head'],
        [2, 1, 'body'],
        [1, 1, 'body']
    ];
    //游戏属性
    this.direction = 'right';
    this.left = false;
    this.right = false;
    this.up = true;
    this.down = true;
    this.score = 0;
    bindEvent();
}
//开始游戏
function startGame() {
    startPage.style.display = 'none';
    startP.style.display = 'block';
    food();
    snake();
}
//食物
function food() {
    var food = document.createElement('div');
    food.style.width = this.foodW + 'px';
    food.style.height = this.foodH + 'px';
    food.style.position = 'absolute';
    this.foodX = Math.floor(Math.random() * (this.mapW / 20));
    this.foodY = Math.floor(Math.random() * (this.mapH / 20));
    food.style.top = this.foodY * 20 + 'px';
    food.style.left = this.foodX * 20 + 'px';
    this.mapDiv.appendChild(food).setAttribute('class', 'food');
}
//蛇
function snake() {
    for (var i = 0; i < this.snakeBody.length; i++) {
        var snake = document.createElement('div');
        snake.style.width = this.snakeW + 'px';
        snake.style.height = this.snakeH + 'px';
        snake.style.position = 'absolute';
        snake.style.left = this.snakeBody[i][0] * 20 + 'px';
        snake.style.top = this.snakeBody[i][1] * 20 + 'px';
        snake.classList.add(this.snakeBody[i][2]);
        this.mapDiv.appendChild(snake).classList.add('snake');
        //改变方向的时候蛇头也改变方向
        switch (this.direction) {
            case 'right':
                break;
            case 'up':
                snake.style.transform = 'rotate(270deg)';
                break;
            case 'left':
                snake.style.transform = 'rotate(180deg)';
                break;
            case 'down':
                snake.style.transform = 'rotate(90deg)';
                break;
            default:
                break;
        }
    }
}
//蛇移动
function move() {
    for (var i = this.snakeBody.length - 1; i > 0; i--) {
        this.snakeBody[i][0] = this.snakeBody[i - 1][0];
        this.snakeBody[i][1] = this.snakeBody[i - 1][1];
    }
    switch (this.direction) {
        case 'right':
            this.snakeBody[0][0] += 1;
            break;
        case 'up':
            this.snakeBody[0][1] -= 1;
            break;
        case 'left':
            this.snakeBody[0][0] -= 1;
            break;
        case 'down':
            this.snakeBody[0][1] += 1;
            break;
        default:
            break;
    }
    removeClass('snake');
    snake();
    //蛇吃到食物
    if (this.snakeBody[0][0] == this.foodX && this.snakeBody[0][1] == this.foodY) {
        var snakeEndX = this.snakeBody[this.snakeBody.length - 1][0];
        var snakeEndY = this.snakeBody[this.snakeBody.length - 1][1];
        switch (this.direction) {
            case 'right':
                this.snakeBody.push([snakeEndX + 1, snakeEndY, 'body']);
                break;
            case 'up':
                this.snakeBody.push([snakeEndX, snakeEndY - 1, 'body']);
                break;
            case 'left':
                this.snakeBody.push([snakeEndX - 1, snakeEndY, 'body']);
                break;
            case 'down':
                this.snakeBody.push([snakeEndX, snakeEndY + 1, 'body']);
                break;
            default:
                break;
        }
        //吃到一个加速。
        clearInterval(snakeMove);
        snakeMove = setInterval(function () {
            move();
        }, speed);
        this.speed = this.speed * 0.95;
        //
        this.score += 1;
        scoreBox.innerHTML = this.score;
        removeClass('food');
        food();
    }
    //判断蛇是不是咬到自己或者碰到墙壁
    if (this.snakeBody[0][0] < 0 || this.snakeBody[0][0] >= this.mapW / 20) {
        reloadGame();
        showMusic.setAttribute('src', './music/end.mp3');
        showMusic.removeAttribute('loop');
    }
    if (this.snakeBody[0][1] < 0 || this.snakeBody[0][1] >= this.mapH / 20) {
        reloadGame();
        showMusic.setAttribute('src', './music/end.mp3');
        showMusic.removeAttribute('loop');
    }
    var snakeHX = this.snakeBody[0][0];
    var snakeHY = this.snakeBody[0][1];
    for (var i = 1; i < this.snakeBody.length; i++) {
        if (snakeHX == snakeBody[i][0] && snakeHY == snakeBody[i][1]) {
            reloadGame();
            showMusic.setAttribute('src', './music/end.mp3');
            showMusic.removeAttribute('loop');
        }
    }
}
//重新开始游戏
function reloadGame() {
    removeClass('snake');
    removeClass('food');
    clearInterval(snakeMove);
    this.snakeBody = [
        [3, 1, 'head'],
        [2, 1, 'body'],
        [1, 1, 'body']
    ];
    this.direction = 'right';
    this.left = false;
    this.right = false;
    this.up = true;
    this.down = true;
    lose.style.display = 'block';
    loserScore.innerHTML = this.score;
    this.score = 0;
    scoreBox.innerHTML = 0;
    startGameBool = true;
    startPaushBool = true;
    startP.setAttribute('src', './images/start.png');
    this.speed = 150;
}
//移出传入的类名节点
function removeClass(className) {
    var ele = document.getElementsByClassName(className);
    while (ele.length > 0) {
        ele[0].parentNode.removeChild(ele[0]);
    }
}
//蛇的运动方向。
function setDerict(code) {
    switch (code) {
        case 37:
            if (this.left) {
                this.direction = 'left';
                this.left = false;
                this.right = false;
                this.up = true;
                this.down = true;
            }
            break;
        case 38:
            if (this.up) {
                this.direction = 'up';
                this.left = true;
                this.right = true;
                this.up = false;
                this.down = false;
            }
            break;
        case 39:
            if (this.right) {
                this.direction = 'right';
                this.left = false;
                this.right = false;
                this.up = true;
                this.down = true;
            }
            break;
        case 40:
            if (this.down) {
                this.direction = 'down';
                this.left = true;
                this.right = true;
                this.up = false;
                this.down = false;
            }
            break;
        default:
            break;
    }
}
//绑定开始，结束事件。
function bindEvent() {
    close.onclick = function () {
        lose.style.display = 'none';
    }
    startBtn.onclick = function () {
        startAndPaush();
    }
    startP.onclick = function () {
        startAndPaush();
        showMusic.setAttribute('src', './music/load.mp3');
        showMusic.setAttribute('loop', 'loop');
    }
}
//控制整个游戏的运行逻辑。
function startAndPaush() {
    if (startPaushBool) {
        if (startGameBool) {
            startGame();
            startGameBool = false;
        }
        startP.setAttribute('src', './images/pause.png');
        document.onkeydown = function (e) {
            var code = e.keyCode;
            setDerict(code);
        }
        snakeMove = setInterval(function () {
            move();
        }, this.speed);
        startPaushBool = false;
    } else {
        startP.setAttribute('src', './images/start.png');
        clearInterval(snakeMove);
        document.onkeydown = function (e) {
            e.returnValue = false;
            return false;
        };
        startPaushBool = true;
    }
}