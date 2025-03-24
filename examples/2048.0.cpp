#include "conio.h"
#include <iostream>
#include <vector>

using namespace std;

class Game2048 {
public:
    vector<vector<int>> game;
    int size;
    int score;
    int highScore;

    enum class Direction {
        UP,
        DOWN,
        LEFT,
        RIGHT
    };

    Game2048(int size = 4) {
        game = vector<vector<int>>(size, vector<int>(size, 0));
        this->size = size;
        this->score = 0;
        this->highScore = 0;
    }

    void run() {
        placeRandom();
        display();

        while (true) {
            char key;
            key = _getch();

            switch (key) {
            case 'w':
                if (move(Direction::UP)) {
                    placeRandom();
                }
                break;
            case 's':
                if (move(Direction::DOWN)) {
                    placeRandom();
                }
                break;
            case 'a':
                if (move(Direction::LEFT)) {
                    placeRandom();
                }
                break;
            case 'd':
                if (move(Direction::RIGHT)) {
                    placeRandom();
                }
                break;
            case 'r':
                reset();
                placeRandom();
                break;
            case 'q':
                return;
            }
            display();
            if (isGameOver()) {
                cout << "Game Over!" << endl;
                if (score > highScore) {
                    highScore = score;
                }
                cout << "Score: " << score << endl;
                cout << "High Score: " << highScore << endl;
                return;
            }
        }
    }

    bool placeRandom() {
        vector<pair<int, int>> emptyCells;
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (game[i][j] == 0) {
                    emptyCells.push_back({i, j});
                }
            }
        }
        if (emptyCells.empty()) {
            return false;
        }
        int idx = rand() % emptyCells.size();
        int num = (rand() % 2 + 1) * 2;
        game[emptyCells[idx].first][emptyCells[idx].second] = num;
        return true;
    }

    void display() {
        system("cls");
        cout << "Welcome to 2048!" << endl;
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                cout << game[i][j] << " ";
            }
            cout << endl;
        }
    }

    bool move(Direction dir) {
        switch (dir) {
        case Direction::UP:
            return moveUp();
        case Direction::DOWN:
            return moveDown();
        case Direction::LEFT:
            return moveLeft();
        case Direction::RIGHT:
            return moveRight();
        }
    }

    bool canMove() {
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (game[i][j] == 0) {
                    return true;
                }
                if (i > 0 && game[i][j] == game[i - 1][j]) {
                    return true;
                }
                if (i < size - 1 && game[i][j] == game[i + 1][j]) {
                    return true;
                }
                if (j > 0 && game[i][j] == game[i][j - 1]) {
                    return true;
                }
                if (j < size - 1 && game[i][j] == game[i][j + 1]) {
                    return true;
                }
            }
        }
        return false;
    }

    bool moveUp() {
        bool moved = false;
        for (int j = 0; j < size; j++) {
            int idx = 0;
            for (int i = 0; i < size; i++) {
                if (game[i][j] != 0) {
                    if (idx > 0 && game[idx - 1][j] == game[i][j]) {
                        game[idx - 1][j] *= 2;
                        score += game[idx - 1][j];
                        game[i][j] = 0;
                        moved = true;
                    } else {
                        if (idx != i) {
                            game[idx][j] = game[i][j];
                            game[i][j] = 0;
                            moved = true;
                        }
                        idx++;
                    }
                }
            }
        }
        return moved;
    }

    bool moveDown() {
        bool moved = false;
        for (int j = 0; j < size; j++) {
            int idx = size - 1;
            for (int i = size - 1; i >= 0; i--) {
                if (game[i][j] != 0) {
                    if (idx < size - 1 && game[idx + 1][j] == game[i][j]) {
                        game[idx + 1][j] *= 2;
                        score += game[idx + 1][j];
                        game[i][j] = 0;
                        moved = true;
                    } else {
                        if (idx != i) {
                            game[idx][j] = game[i][j];
                            game[i][j] = 0;
                            moved = true;
                        }
                        idx--;
                    }
                }
            }
        }
        return moved;
    }

    bool moveLeft() {
        bool moved = false;
        for (int i = 0; i < size; i++) {
            int idx = 0;
            for (int j = 0; j < size; j++) {
                if (game[i][j] != 0) {
                    if (idx > 0 && game[i][idx - 1] == game[i][j]) {
                        game[i][idx - 1] *= 2;
                        score += game[i][idx - 1];
                        game[i][j] = 0;
                        moved = true;
                    } else {
                        if (idx != j) {
                            game[i][idx] = game[i][j];
                            game[i][j] = 0;
                            moved = true;
                        }
                        idx++;
                    }
                }
            }
        }
        return moved;
    }

    bool moveRight() {
        bool moved = false;
        for (int i = 0; i < size; i++) {
            int idx = size - 1;
            for (int j = size - 1; j >= 0; j--) {
                if (game[i][j] != 0) {
                    if (idx < size - 1 && game[i][idx + 1] == game[i][j]) {
                        game[i][idx + 1] *= 2;
                        score += game[i][idx + 1];
                        game[i][j] = 0;
                        moved = true;
                    } else {
                        if (idx != j) {
                            game[i][idx] = game[i][j];
                            game[i][j] = 0;
                            moved = true;
                        }
                        idx--;
                    }
                }
            }
        }
        return moved;
    }

    bool isGameOver() {
        if (canMove()) {
            return false;
        }
        return true;
    }

    void reset() {
        game = vector<vector<int>>(size, vector<int>(size, 0));
        score = 0;
    }
};

int main() {
    Game2048 game;
    game.run();
    return 0;
}