#include <stdio.h>
#include <stdlib.h>

#define SIZE 4
#define WIN_SCORE 2048

int board[SIZE][SIZE];
int score = 0;

void init_board() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            board[i][j] = 0;
        }
    }
    for (int k = 0; k < 2; k++) {
        int i = rand() % SIZE;
        int j = rand() % SIZE;
        int value = (rand() % 2 + 1) * 2;
        board[i][j] = value;
    }
}

void print_board() {
    system("cls");
    printf("Score: %d\n", score);
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%4d", board[i][j]);
        }
        printf("\n");
    }
}

int is_full() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (board[i][j] == 0) {
                return 0;
            }
        }
    }
    return 1;
}

int is_won() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (board[i][j] == WIN_SCORE) {
                return 1;
            }
        }
    }
    return 0;
}

int can_move() {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (board[i][j] == 0) {
                return 1;
            }
            if (j > 0 && board[i][j] == board[i][j - 1]) {
                return 1;
            }
            if (j < SIZE - 1 && board[i][j] == board[i][j + 1]) {
                return 1;
            }
            if (i > 0 && board[i][j] == board[i - 1][j]) {
                return 1;
            }
            if (i < SIZE - 1 && board[i][j] == board[i + 1][j]) {
                return 1;
            }
        }
    }
    return 0;
}

int move(int dir) {
    int moved = 0;
    int prev_board[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            prev_board[i][j] = board[i][j];
        }
    }
    if (dir == 0) {
        for (int j = 0; j < SIZE; j++) {
            for (int i = 1; i < SIZE; i++) {
                if (board[i][j] != 0) {
                    int k = i;
                    while (k > 0 && board[k - 1][j] == 0) {
                        board[k - 1][j] = board[k][j];
                        board[k][j] = 0;
                        k--;
                        moved = 1;
                    }
                    if (k > 0 && board[k - 1][j] == board[k][j]) {
                        board[k - 1][j] *= 2;
                        score += board[k - 1][j];
                        board[k][j] = 0;
                        moved = 1;
                    }
                }
            }
        }
    } else if (dir == 1) {
        for (int j = 0; j < SIZE; j++) {
            for (int i = SIZE - 2; i >= 0; i--) {
                if (board[i][j] != 0) {
                    int k = i;
                    while (k < SIZE - 1 && board[k + 1][j] == 0) {
                        board[k + 1][j] = board[k][j];
                        board[k][j] = 0;
                        k++;
                        moved = 1;
                    }
                    if (k < SIZE - 1 && board[k + 1][j] == board[k][j]) {
                        board[k + 1][j] *= 2;
                        score += board[k + 1][j];
                        board[k][j] = 0;
                        moved = 1;
                    }
                }
            }
        }
    } else if (dir == 2) {
        for (int i = 0; i < SIZE; i++) {
            for (int j = 1; j < SIZE; j++) {
                if (board[i][j] != 0) {
                    int k = j;
                    while (k > 0 && board[i][k - 1] == 0) {
                        board[i][k - 1] = board[i][k];
                        board[i][k] = 0;
                        k--;
                        moved = 1;
                    }
                    if (k > 0 && board[i][k - 1] == board[i][k]) {
                        board[i][k - 1] *= 2;
                        score += board[i][k - 1];
                        board[i][k] = 0;
                        moved = 1;
                    }
                }
            }
        }
    } else if (dir == 3) {
        for (int i = 0; i < SIZE; i++) {
            for (int j = SIZE - 2; j >= 0; j--) {
                if (board[i][j] != 0) {
                    int k = j;
                    while (k < SIZE - 1 && board[i][k + 1] == 0) {
                        board[i][k + 1] = board[i][k];
                        board[i][k] = 0;
                        k++;
                        moved = 1;
                    }
                    if (k < SIZE - 1 && board[i][k + 1] == board[i][k]) {
                        board[i][k + 1] *= 2;
                        score += board[i][k + 1];
                        board[i][k] = 0;
                        moved = 1;
                    }
                }
            }
        }
    }
    if (moved) {
        int i = rand() % SIZE;
        int j = rand() % SIZE;
        while (board[i][j] != 0) {
            i = rand() % SIZE;
            j = rand() % SIZE;
        }
        board[i][j] = (rand() % 2 + 1) * 2;
        print_board();
    }
    if (moved) {
        return 1;
    } else {
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                board[i][j] = prev_board[i][j];
            }
        }
        return 0;
    }
}

int main() {
    init_board();
    print_board();
    while (1) {
        if (is_won()) {
            printf("You won!\n");
            break;
        }
        if (is_full() && !can_move()) {
            printf("Game over!\n");
            break;
        }
        int direction;
        printf("Enter the move direction (0-Up, 1-Down, 2-Left, 3-Right): ");
        scanf("%d", &direction);
        if (move(direction)) {
            print_board();
        }
    }
    return 0;
}
