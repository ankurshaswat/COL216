#include <iostream>
using namespace std;
#include <unistd.h>

void clearScreen()
{
        const char *CLEAR_SCREEN_ANSI = "\e[1;1H\e[2J";
        write(STDOUT_FILENO, CLEAR_SCREEN_ANSI, 12);
}

// grid   -1 -> neutral
//      0  -> black
//      1  -> white

int grid[8][8],
    player_input,
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

bool check_marker(int x,int y,bool active_player){

        bool valid=false;
        bool disc_to_find=!active_player;

        if(grid[x][y]>-1) {
                return false;
        }

        if(x>7 || x<0) {
                return false;
        }

        if(y>7 || y<0) {
                return false;
        }
// cout<<"Tag4"<<endl;

        for(int i=-1; i<2; i++) {
                for(int j=-1; j<2; j++) {

                        if(i==0 && j==0) {
                                continue;
                        }
                        int x_copy=x,y_copy=y;
                        int to_flip=0;
// int disc_to_find=!active_player;
                        x_copy+=i;
                        y_copy+=j;
// cout<<"Tag5"<<endl;

                        while (x_copy<8 && y_copy<8 && x_copy>-1 && y_copy>-1) {
// cout<<"Tag6"<<endl;

                                if(grid[x_copy][y_copy]==disc_to_find) {
// cout<<"Tag7"<<endl;

                                        to_flip++;


                                        x_copy+=i;
                                        y_copy+=j;
                                        continue;
                                }else if(grid[x_copy][y_copy]==(!disc_to_find)) {
                                        if(to_flip!=0) {
// cout<<"Tag8"<<endl;

                                                int direction_x=0-i;
                                                int direction_y=0-j;

                                                x_copy+=direction_x;
                                                y_copy+=direction_y;
                                                while(x_copy!=x || y_copy!=y) {


                                                        grid[x_copy][y_copy]=active_player;
                                                        score[active_player]++;
                                                        score[!active_player]--;

                                                        x_copy+=direction_x;
                                                        y_copy+=direction_y;
                                                }

                                                grid[x][y]=active_player;


                                                valid=true;
                                        }else{
                                                break;
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
        if(valid==true){
          score[active_player]++;
        }
        return valid;
}




void place_marker(int x,int y){
// cout<<"Tag3"<<endl;

        if(check_marker(x,y,active_player)) {
// cout<<"Inside"<<endl;
                active_player=!active_player;
        }else{
                cout<<"Invalid Move"<<endl;
        }
}


void print_grid(){
        cout<<endl<<endl<<endl;

        cout<<" "<<'\t';

        for(int i=0; i<8; i++)
        {
                cout<<i<<'\t';
        }
        cout<<endl<<endl<<endl;

// int j=0;
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

bool show_available_moves(){

        bool moves_possible=false;

        for(int x=0; x<8; x++) {
                for(int y=0; y<8; y++) {

                        bool valid=false;
                        bool disc_to_find=!active_player;

                        if(grid[x][y]>-1) {
                                continue;
                        }else{
                                grid[x][y]=-1;
                        }

                        for(int i=-1; i<2; i++) {
                                for(int j=-1; j<2; j++) {

                                        if(i==0 && j==0) {
                                                continue;
                                        }
                                        int x_copy=x,y_copy=y;
                                        int to_flip=0;
                                        x_copy+=i;
                                        y_copy+=j;
                                        while (x_copy<8 && y_copy<8 && x_copy>-1 && y_copy>-1) {
                                                if(grid[x_copy][y_copy]==disc_to_find) {
                                                        to_flip++;
                                                        x_copy+=i;
                                                        y_copy+=j;
                                                        continue;
                                                }else if(grid[x_copy][y_copy]==(!disc_to_find)) {
                                                        if(to_flip!=0) {
                                                                int direction_x=0-i;
                                                                int direction_y=0-j;

                                                                x_copy+=direction_x;
                                                                y_copy+=direction_y;
                                                                while(x_copy!=x || y_copy!=y) {
                                                                        x_copy+=direction_x;
                                                                        y_copy+=direction_y;
                                                                }

                                                                grid[x][y]=-2;
                                                                valid=true;
                                                        }else{
                                                                break;
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
                                moves_possible=true;
                        }

                }
        }
        return moves_possible;
}


int main(){

        int player_input_y,player_input_x;

        initialize();
        clearScreen();

        show_available_moves();
        print_grid();


        while(success==false) {

                cout<<"Chance of Player "<<active_player<<endl;
                cout<<"Enter Column then row"<<endl;
                cin>>player_input_y;
                cin>>player_input_x;
// cout<<"Tag1"<<endl;
                clearScreen();
// cout<<"Tag2"<<endl;
                place_marker(player_input_x,player_input_y);
                success=!show_available_moves();
                print_grid();
        }

        cout<<"Game Over"<<endl;

        return 0;
}
