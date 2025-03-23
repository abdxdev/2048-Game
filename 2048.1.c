#include <stdio.h>
#include <stdlib.h>

#define SIZE 4
#define WIN_SCORE 2048

int board[SIZE * SIZE];
int score = 0;

// Convert 2D coordinates to 1D index
int idx(int i, int j) {
    return i * SIZE + j;
}

void init_board() {
    for (int i = 0; i < SIZE * SIZE; i++) {
        board[i] = 0;
    }
    
    // Add two initial tiles
    for (int k = 0; k < 2; k++) {
        int i = rand() % (SIZE * SIZE);
        while (board[i] != 0) {
            i = rand() % (SIZE * SIZE);
        }
        int value = (rand() % 2 + 1) * 2;
        board[i] = value;
    }
}

void print_board() {
    system("cls");
    printf("Score: %d\n", score);
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            printf("%4d", board[idx(i, j)]);
        }
        printf("\n");
    }
}

int is_full() {
    for (int i = 0; i < SIZE * SIZE; i++) {
        if (board[i] == 0) {
            return 0;
        }
    }
    return 1;
}

int is_won() {
    for (int i = 0; i < SIZE * SIZE; i++) {
        if (board[i] == WIN_SCORE) {
            return 1;
        }
    }
    return 0;
}

int can_move() {
    // Check for empty cells
    for (int i = 0; i < SIZE * SIZE; i++) {
        if (board[i] == 0) {
            return 1;
        }
    }
    
    // Check for adjacent matching tiles
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            int current = idx(i, j);
            
            // Check right
            if (j < SIZE - 1 && board[current] == board[idx(i, j + 1)]) {
                return 1;
            }
            
            // Check down
            if (i < SIZE - 1 && board[current] == board[idx(i + 1, j)]) {
                return 1;
            }
        }
    }
    
    return 0;
}

int move(int dir) {
    int moved = 0;
    int prev_board[SIZE * SIZE];
    
    // Save the current board state
    for (int i = 0; i < SIZE * SIZE; i++) {
        prev_board[i] = board[i];
    }
    
    if (dir == 0) {  // Up
        for (int j = 0; j < SIZE; j++) {
            for (int i = 1; i < SIZE; i++) {
                if (board[idx(i, j)] != 0) {
                    int k = i;
                    while (k > 0 && board[idx(k - 1, j)] == 0) {
                        board[idx(k - 1, j)] = board[idx(k, j)];
                        board[idx(k, j)] = 0;
                        k--;
                        moved = 1;
                    }
                    if (k > 0 && board[idx(k - 1, j)] == board[idx(k, j)]) {
                        board[idx(k - 1, j)] *= 2;
                        score += board[idx(k - 1, j)];
                        board[idx(k, j)] = 0;
                        moved = 1;
                    }
                }
            }
        }
    } else if (dir == 1) {  // Down
        for (int j = 0; j < SIZE; j++) {
            for (int i = SIZE - 2; i >= 0; i--) {
                if (board[idx(i, j)] != 0) {
                    int k = i;
                    while (k < SIZE - 1 && board[idx(k + 1, j)] == 0) {
                        board[idx(k + 1, j)] = board[idx(k, j)];
                        board[idx(k, j)] = 0;
                        k++;
                        moved = 1;
                    }
                    if (k < SIZE - 1 && board[idx(k + 1, j)] == board[idx(k, j)]) {
                        board[idx(k + 1, j)] *= 2;
                        score += board[idx(k + 1, j)];
                        board[idx(k, j)] = 0;
                        moved = 1;
                    }
                }
            }
        }
    } else if (dir == 2) {  // Left
        for (int i = 0; i < SIZE; i++) {
            for (int j = 1; j < SIZE; j++) {
                if (board[idx(i, j)] != 0) {
                    int k = j;
                    while (k > 0 && board[idx(i, k - 1)] == 0) {
                        board[idx(i, k - 1)] = board[idx(i, k)];
                        board[idx(i, k)] = 0;
                        k--;
                        moved = 1;
                    }
                    if (k > 0 && board[idx(i, k - 1)] == board[idx(i, k)]) {
                        board[idx(i, k - 1)] *= 2;
                        score += board[idx(i, k - 1)];
                        board[idx(i, k)] = 0;
                        moved = 1;
                    }
                }
            }
        }
    } else if (dir == 3) {  // Right
        for (int i = 0; i < SIZE; i++) {
            for (int j = SIZE - 2; j >= 0; j--) {
                if (board[idx(i, j)] != 0) {
                    int k = j;
                    while (k < SIZE - 1 && board[idx(i, k + 1)] == 0) {
                        board[idx(i, k + 1)] = board[idx(i, k)];
                        board[idx(i, k)] = 0;
                        k++;
                        moved = 1;
                    }
                    if (k < SIZE - 1 && board[idx(i, k + 1)] == board[idx(i, k)]) {
                        board[idx(i, k + 1)] *= 2;
                        score += board[idx(i, k + 1)];
                        board[idx(i, k)] = 0;
                        moved = 1;
                    }
                }
            }
        }
    }
    
    if (moved) {
        // Add a new tile
        int i = rand() % (SIZE * SIZE);
        while (board[i] != 0) {
            i = rand() % (SIZE * SIZE);
        }
        board[i] = (rand() % 2 + 1) * 2;
    } else {
        // Restore the board if no movement was made
        for (int i = 0; i < SIZE * SIZE; i++) {
            board[i] = prev_board[i];
        }
        return 0;
    }
    
    return 1;
}

int main() {
    srand(time(NULL));  // Initialize random seed
    
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
        
        if (direction >= 0 && direction <= 3) {
            if (move(direction)) {
                print_board();
            } else {
                printf("Invalid move. Try again.\n");
            }
        } else {
            printf("Invalid direction. Please enter 0, 1, 2, or 3.\n");
        }
    }
    
    return 0;
}