#include <iostream>
using namespace std;
#include <unistd.h>
void clearScreen()
{
        const char *CLEAR_SCREEN_ANSI = "\e[1;1H\e[2J";
        write(STDOUT_FILENO, CLEAR_SCREEN_ANSI, 12);
}
int grid[8][8],
    active_player,
    score[2];
bool success;
void initialize(){
        for(int i=0; i<8; i++) {
                for(int j=0; j<8; j++) {
                        grid[i][j]=-1;
                }
        }
        grid[3][3]=1;
        grid[4][4]=1;
        grid[3][4]=0;
        grid[4][3]=0;
        score[0]=2;
        score[1]=2;
        active_player=0;
}
bool occupied(int x, int y){
        return grid[x][y]>-1;
}
bool valid_coordinate(int x, int y){
        if(x>7 || x<0) {
                return false;
        }
        if(y>7 || y<0) {
                return false;
        }
        return true;
}
void print_grid(){
        cout<<endl<<endl<<endl;
        cout<<" "<<'\t';
        for(int i=0; i<8; i++)
        {
                cout<<i<<'\t';
        }
        cout<<endl<<endl<<endl;
        for(int i=0; i<8; i++) {
                cout<<i<<'\t';
                for(int j=0; j<8; j++) {
                        if(grid[i][j]==-1) {
                                cout<<"_"<<'\t';
                        }else if(grid[i][j]==-2) {
                                cout<<"[]"<<'\t';
                        }
                        else{
                                cout<<grid[i][j]<<'\t';
                        }
                }
                cout<<endl<<endl<<endl;
        }
        cout<<"Score Player 1 = "<<score[0]<<endl;
        cout<<"Score Player 2 = "<<score[1]<<endl;
}
int main(){
        int player_input_y,player_input_x;
        bool success;
        initialize();
        clearScreen();
        print_grid();
        while(true) {
                cout<<"Chance of Player "<<active_player<<endl;
                cout<<"Enter Column then row"<<endl;
                cin>>player_input_y;
                cin>>player_input_x;
                clearScreen();
                bool valid=false;
                bool disc_to_find=!active_player;
                if(occupied(player_input_x,player_input_y)) {
                        continue;
                }
                if(!valid_coordinate(player_input_x,player_input_y)) {
                        continue;
                }
                for(int i=-1; i<2; i++) {
                        for(int j=-1; j<2; j++) {
                                if(i==0 && j==0) {
                                        continue;
                                }
                                int x_copy=player_input_x,y_copy=player_input_y;
                                int to_flip=0;
                                x_copy+=i;
                                y_copy+=j;
                                while (valid_coordinate(x_copy,y_copy)) {
                                        if(grid[x_copy][y_copy]==disc_to_find) {
                                                to_flip++;
                                                x_copy+=i;
                                                y_copy+=j;
                                                continue;
                                        }
                                        else if(grid[x_copy][y_copy]==(!disc_to_find)) {
                                                if(to_flip!=0) {
                                                        int direction_x=0-i;
                                                        int direction_y=0-j;
                                                        x_copy+=direction_x;
                                                        y_copy+=direction_y;
                                                        while(true) {
                                                                if(x_copy==player_input_x) {
                                                                    if(y_copy==player_input_y){
                                                                      break;
                                                                    }
                                                                }
                                                                grid[x_copy][y_copy]=active_player;
                                                                score[active_player]++;
                                                                score[!active_player]--;
                                                                x_copy+=direction_x;
                                                                y_copy+=direction_y;
                                                        }
                                                        grid[x_copy][y_copy]=active_player;
                                                        valid=true;
                                                }
                                                break;
                                        }else{
                                                break;
                                        }
                                        x_copy+=i;
                                        y_copy+=j;
                                }
                        }
                }
                if(valid==true) {
                        score[active_player]++;
                        active_player=!active_player;
                }else{
                        cout<<"Invalid Move"<<endl;
                }
                print_grid();
        }
        cout<<"Game Over"<<endl;
        return 0;
}
